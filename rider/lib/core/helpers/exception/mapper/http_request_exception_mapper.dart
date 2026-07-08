import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:logger/logger.dart';
import 'package:xtridelink_driver/core/helpers/exception/mapper/exception_mapper.dart';
import 'package:xtridelink_driver/core/helpers/exception/remote_exception.dart';
import 'package:xtridelink_driver/data/source/remote/model/error_response.dart';
import 'package:xtridelink_driver/data/source/remote/model/mapper/error_response_mapper.dart';
import 'package:xtridelink_driver/domain/entity/server_error.dart';

@Injectable()
class HttpRequestExceptionMapper extends ExceptionMapper<RemoteException> {
  HttpRequestExceptionMapper(this._errorResponseMapper);
  final ErrorResponseMapper _errorResponseMapper;

  @override
  RemoteException map(Object? exception) {
    if (exception is DioException) {
      Logger().i(exception.response?.data);
      if (exception.error is RemoteException && exception.error != null) {
        return exception.error! as RemoteException;
      }
      switch (exception.type) {
        case DioExceptionType.cancel:
          return const RemoteException.cancellationError();
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return const RemoteException.timeoutError();
        case DioExceptionType.unknown:
          return RemoteException.unexpectedError(exception);
        case DioExceptionType.badResponse:
          if (exception.response?.data != null) {
            if (exception.response!.data is String) {
              return RemoteException.serverError(
                exception.response!.statusCode,
                const ServerError(message: 'Unexpected Server error'),
              );
            }
            try {
              return RemoteException.serverError(
                exception.response!.statusCode,
                _errorResponseMapper.mapToEntity(
                  ErrorResponse.fromJson(
                    exception.response!.data! as Map<String, dynamic>,
                  ),
                ),
              );
            } catch (e) {
              return RemoteException.serverError(
                exception.response!.statusCode,
                const ServerError(message: 'An error occured'),
              );
            }
          } else {
            return RemoteException.httpError(exception.response!.statusCode);
          }
        case DioExceptionType.badCertificate:
        case DioExceptionType.connectionError:
          return RemoteException.unexpectedError(exception);
      }
    } else if (exception is SocketException) {
      return const RemoteException.timeoutError();
    } else {
      return RemoteException.unexpectedError(exception);
    }
  }
}
