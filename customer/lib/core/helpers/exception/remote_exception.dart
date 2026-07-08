import 'package:xtridelink/domain/entity/server_error.dart';

class RemoteException implements Exception {
  const RemoteException._(
    this.kind, {
    this.statusCode,
    this.errorResponse,
    this.exception,
  });

  const RemoteException.httpError(int? statusCode)
      : this._(RemoteExceptionKind.http, statusCode: statusCode);

  const RemoteException.serverError(int? statusCode, ServerError errorResponse)
      : this._(
          RemoteExceptionKind.server,
          statusCode: statusCode,
          errorResponse: errorResponse,
        );

  const RemoteException.networkError(int statusCode)
      : this._(RemoteExceptionKind.network, statusCode: statusCode);

  const RemoteException.noInternetError()
      : this._(RemoteExceptionKind.noInternet);

  const RemoteException.timeoutError() : this._(RemoteExceptionKind.timeout);

  const RemoteException.cancellationError()
      : this._(RemoteExceptionKind.cancellation);

  const RemoteException.unexpectedError(Object? exception)
      : this._(RemoteExceptionKind.unexpected, exception: exception);
  final RemoteExceptionKind kind;
  final int? statusCode;
  final ServerError? errorResponse;
  final Object? exception;

  bool get isServerInternalError =>
      statusCode != null && statusCode! >= 500 && statusCode! <= 599;

  @override
  String toString() {
    return 'RemoteException: {kind: $kind, statusCode: $statusCode, errorResponse: $errorResponse, exception: $exception}';
  }
}

enum RemoteExceptionKind {
  noInternet,
  network,
  http,
  server,
  timeout,
  cancellation,
  unexpected
}
