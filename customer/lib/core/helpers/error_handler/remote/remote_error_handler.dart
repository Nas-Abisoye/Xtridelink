import 'package:flutter/material.dart';
import 'package:xtridelink/core/helpers/error_handler/error_handler.dart';
import 'package:xtridelink/core/helpers/error_handler/remote/remote_error_listener.dart';
import 'package:xtridelink/core/helpers/exception/remote_exception.dart';

class RemoteErrorHandler
    extends ErrorHandler<RemoteException, RemoteErrorListener> {
  @override
  void proceed(
    BuildContext context,
    RemoteException exception,
    RemoteErrorListener listener,
  ) {
    switch (exception.kind) {
      case RemoteExceptionKind.server:
        listener.onServerError(
          context,
          exception,
        );

        break;

      case RemoteExceptionKind.noInternet:
        listener.onNoInterNetConnectionError(
          context,
          'Please check your network connection',
        );
        break;
      case RemoteExceptionKind.network:
        listener.onNetworkError(
          context,
          'An error occurred, try again (100)',
        );
        break;
      case RemoteExceptionKind.timeout:
        listener.onTimeoutError(
          context,
          'Please check your network connection',
        );
        break;
      case RemoteExceptionKind.cancellation:
        break;
      case RemoteExceptionKind.unexpected:
        listener.onUnexpectedError(
          context,
          'An unexpected error occurred',
        );
        break;
      case RemoteExceptionKind.http:
        if (exception.isServerInternalError) {
          listener.onServerInternalError(
            context,
            'Server error',
          );
        } else {
          listener.onHttpError(
            context,
            'An unexpected error occurred',
          );
        }
        break;
    }
  }
}
