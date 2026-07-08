import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart' hide Environment;
import 'package:xtridelink_driver/core/helpers/environment/environment.dart';
import 'package:xtridelink_driver/core/network/token_interceptor.dart';

@Injectable()
class HttpService {
  Dio client({bool requireAuth = false}) => Dio(
        BaseOptions(
          baseUrl: Environment().config.apiHost,
          connectTimeout: const Duration(seconds: 60),
          receiveTimeout: const Duration(seconds: 60),
          sendTimeout: const Duration(seconds: 60),
          validateStatus: (status) => status == 200 || status == 201,
          headers: {
            'Accept':
                'application/json, application/geo+json, application/gpx+xml, img/png; charset=utf-8',
            'Content-type': 'application/json'
          },
        ),
      )
        ..interceptors.add(
          TokenInterceptor(
            requireAuth: requireAuth,
          ),
        )
        ..interceptors.add(
          LogInterceptor(
            responseHeader: false,
            responseBody: true,
            requestBody: true,
          ),
        );
}
