import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/error_listener.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/local/local_error_handler.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/local/local_error_listener.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/remote/remote_error_handler.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/remote/remote_error_listener.dart';
import 'package:xtridelink_driver/core/helpers/exception/local_exception.dart';
import 'package:xtridelink_driver/core/helpers/exception/remote_exception.dart';

class ErrorHandlerFactory {
  ErrorHandlerFactory._();

  static void handleErrorByType(
    BuildContext context,
    Object error,
    ErrorListener listener,
  ) {
    if (error is RemoteException) {
      return RemoteErrorHandler().proceed(
        context,
        error,
        listener as RemoteErrorListener,
      );
    }

    // database error

    // local error
    if (error is LocalException) {
      return LocalErrorHandler().proceed(
        context,
        error,
        listener as LocalErrorListener,
      );
    }

    throw 'Uncaught Exception: ${error.runtimeType}';
  }
}
