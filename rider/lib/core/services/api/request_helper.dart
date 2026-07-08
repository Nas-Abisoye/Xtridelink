import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/strings.dart';
import '../../constants/debouncer.dart';
import '../navigation/index.dart';
import '../navigation/routes.dart';
import '../storage/index.dart';

abstract class RequestHelpers {
  Future<http.Response?> post(
      {required String url,
      String? host,
      required Map<String, dynamic> body,
      Map<String, dynamic>? queryParameters,
      bool useToken = true});

  Future<http.Response?> patch(
      {required String url,
      String? host,
      required Map<String, dynamic> body,
      Map<String, dynamic>? queryParameters,
      bool useToken = true});

  Future<http.Response?> put(
      {required String url,
      String? host,
      required Map<String, dynamic> body,
      Map<String, dynamic>? queryParameters,
      bool useToken = true});

  Future<http.Response?> get(
      {required String url,
      String? host,
      bool useToken = true,
      Map<String, dynamic>? queryParameters});
  Future<http.Response?> delete(
      {required String url,
      String? host,
      bool useToken = true,
      Map<String, dynamic>? queryParameters});
}

class RequestHelpersImpl extends RequestHelpers {
  final http.Client httpClient;
  final StorageServiceImpl storageServiceImpl;
  final NavigationServiceImpl navigationServiceImpl;
  final _debouncer = Debouncer();

  RequestHelpersImpl(
      {required this.storageServiceImpl,
      required this.navigationServiceImpl,
      required this.httpClient});

  // Single-flight guard so concurrent 401s share one refresh call.
  static Future<bool>? _refreshing;

  @override
  Future<http.Response?> post({
    required String url,
    String? host,
    required Map<String, dynamic> body,
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        method: 'POST',
        url: url,
        host: host,
        body: body,
        queryParameters: queryParameters,
        useToken: useToken,
      );

  @override
  Future<http.Response?> patch({
    required String url,
    String? host,
    required Map<String, dynamic> body,
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        method: 'PATCH',
        url: url,
        host: host,
        body: body,
        queryParameters: queryParameters,
        useToken: useToken,
      );

  @override
  Future<http.Response?> put({
    required String url,
    String? host,
    required Map<String, dynamic> body,
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        method: 'PUT',
        url: url,
        host: host,
        body: body,
        queryParameters: queryParameters,
        useToken: useToken,
      );

  @override
  Future<http.Response?> get({
    required String url,
    String? host,
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        method: 'GET',
        url: url,
        host: host,
        queryParameters: queryParameters,
        useToken: useToken,
      );

  @override
  Future<http.Response?> delete({
    required String url,
    String? host,
    bool useToken = true,
    Map<String, dynamic>? queryParameters,
  }) =>
      _request(
        method: 'DELETE',
        url: url,
        host: host,
        queryParameters: queryParameters,
        useToken: useToken,
      );

  /// Single core request path shared by all verbs. Handles auth headers,
  /// timeouts, and — on a 401 — a single transparent token refresh + retry
  /// before falling back to forcing the user to re-login.
  Future<http.Response?> _request({
    required String method,
    required String url,
    String? host,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool useToken = true,
    bool isRetry = false,
  }) async {
    if (kDebugMode) {
      log('$method Url: $url');
      if (body != null) log('Payload: ${jsonEncode(body)}');
    }
    try {
      final uri = Uri.https(host ?? GlobalStrings.host, url, queryParameters);
      final token = useToken ? await storageServiceImpl.getToken() : null;
      final headers = <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Accept': 'application/json',
        if (useToken && token != null && token.isNotEmpty)
          HttpHeaders.authorizationHeader: 'Bearer $token',
      };

      Future<http.Response> send() {
        switch (method) {
          case 'POST':
            return httpClient.post(uri,
                headers: headers, body: jsonEncode(body ?? {}));
          case 'PATCH':
            return httpClient.patch(uri,
                headers: headers, body: jsonEncode(body ?? {}));
          case 'PUT':
            return httpClient.put(uri,
                headers: headers, body: jsonEncode(body ?? {}));
          case 'DELETE':
            return httpClient.delete(uri, headers: headers);
          case 'GET':
          default:
            return httpClient.get(uri, headers: headers);
        }
      }

      final res = await send().timeout(
        const Duration(seconds: 50),
        onTimeout: () {
          HelperFunc.toast('Connection Timeout.');
          return Future.error('Connection Timeout.');
        },
      );

      if (kDebugMode) {
        log('Response Code: ${res.statusCode}');
        log('Response Body: ${res.body}');
      }

      if (res.statusCode == 502) {
        HelperFunc.toast('502 Server error');
        return null;
      }

      if (res.statusCode == 401) {
        // Try a one-time refresh + retry before giving up on the session.
        if (useToken && !isRetry) {
          final refreshed = await _attemptRefresh();
          if (refreshed) {
            return _request(
              method: method,
              url: url,
              host: host,
              body: body,
              queryParameters: queryParameters,
              useToken: useToken,
              isRetry: true,
            );
          }
        }
        _debouncer(() {
          HelperFunc.toast('Please sign in to continue using app.');
          navigationServiceImpl.replaceWith(Routes.intro);
        });
        return null;
      }

      return res;
    } on SocketException {
      HelperFunc.toast('No internet connection.');
      return null;
    } catch (e) {
      if (kDebugMode) log('Request error: $e');
      HelperFunc.toast('An error occurred.\nTry again.');
    }
    return null;
  }

  /// Exchanges the stored refresh token for a new access token. Returns true
  /// on success. Concurrent callers share a single in-flight refresh.
  Future<bool> _attemptRefresh() async {
    final refreshToken = await storageServiceImpl.getRefreshToken();
    if (refreshToken.isEmpty) return false;

    _refreshing ??= _doRefresh(refreshToken);
    final ok = await _refreshing!;
    _refreshing = null;
    return ok;
  }

  Future<bool> _doRefresh(String refreshToken) async {
    try {
      final res = await httpClient
          .post(
            Uri.https(GlobalStrings.host, '/users/token/refresh/'),
            headers: {
              'Content-Type': 'application/json; charset=UTF-8',
              'Accept': 'application/json',
            },
            body: jsonEncode({'refresh_token': refreshToken}),
          )
          .timeout(const Duration(seconds: 30));

      if (res.statusCode == 200 || res.statusCode == 201) {
        final decoded = jsonDecode(res.body);
        final newToken = (decoded['data']?['access_token'] ??
            decoded['access_token']) as String?;
        if (newToken != null && newToken.isNotEmpty) {
          await storageServiceImpl.setUserToken(newToken);
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }
}
