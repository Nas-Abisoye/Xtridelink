// ignore_for_file: omit_local_variable_types

import 'package:dio/dio.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';
import 'package:xtridelink/injector.dart';

class TokenInterceptor extends Interceptor {
  TokenInterceptor({
    required this.requireAuth,
  });

  final bool requireAuth;

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
}
