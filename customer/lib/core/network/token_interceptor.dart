// ignore_for_file: omit_local_variable_types

import 'package:dio/dio.dart';
import 'package:xtridelink/core/helpers/environment/environment.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';
import 'package:xtridelink/injector.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({
    required this.requireAuth,
  });

  final bool requireAuth;

  // Paths that must never trigger a refresh attempt (avoids recursion).
  static const _authPaths = ['/users/token/refresh/', '/users/login/'];

  // Single-flight guard so concurrent 401s share one refresh call.
  static Future<bool>? _refreshing;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final String? token = getIt<AuthenticationRepository>().getAccessToken();
    if (token != null && token.isNotEmpty && requireAuth) {
      options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final requestOptions = err.requestOptions;
    final isUnauthorized = err.response?.statusCode == 401;
    final alreadyRetried = requestOptions.extra['__auth_retry__'] == true;
    final isAuthCall = _authPaths.any((p) => requestOptions.path.contains(p));

    // Only attempt a refresh for authenticated calls that got a fresh 401.
    if (!requireAuth || !isUnauthorized || alreadyRetried || isAuthCall) {
      return handler.next(err);
    }

    final repo = getIt<AuthenticationRepository>();
    final refreshToken = repo.getRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _forceLogout(repo);
      return handler.next(err);
    }

    // Refresh once, shared across any concurrent 401s.
    final refreshed = await (_refreshing ??= _doRefresh(repo, refreshToken));
    _refreshing = null;

    if (!refreshed) {
      await _forceLogout(repo);
      return handler.next(err);
    }

    // Replay the original request with the new access token.
    try {
      final newToken = repo.getAccessToken();
      requestOptions.extra['__auth_retry__'] = true;
      requestOptions.headers['Authorization'] = 'Bearer $newToken';

      final retryDio = Dio(
        BaseOptions(baseUrl: Environment().config.apiHost),
      );
      final response = await retryDio.fetch<dynamic>(requestOptions);
      return handler.resolve(response);
    } catch (e) {
      return handler.next(e is DioException ? e : err);
    }
  }

  Future<bool> _doRefresh(
    AuthenticationRepository repo,
    String refreshToken,
  ) async {
    try {
      final result = await repo.refreshToken(refreshToken);
      return result.map(success: (_) => true, failure: (_) => false);
    } catch (_) {
      return false;
    }
  }

  Future<void> _forceLogout(AuthenticationRepository repo) async {
    try {
      await repo.logout();
    } catch (_) {
      // ignore — we still route to login below.
    }
    try {
      globalReplaceUntil(route: Routes.intro);
    } catch (_) {
      // Navigator may not be ready; the launch guard will handle it.
    }
  }
}
