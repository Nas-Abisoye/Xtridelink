import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/error_handler.dart';
import 'package:xtridelink_driver/core/helpers/error_handler/local/local_error_listener.dart';
import 'package:xtridelink_driver/core/helpers/exception/local_exception.dart';

class LocalErrorHandler
    extends ErrorHandler<LocalException, LocalErrorListener> {
  @override
  void proceed(
    BuildContext context,
    LocalException exception,
    LocalErrorListener listener,
  ) {
    switch (exception.kind) {
      case LocalExceptionKind.sharedPreference:
        listener.onSharedPreferenceError(
          context,
          'An unexpected error occurred',
        );
        break;
      case LocalExceptionKind.mapper:
        listener.onMappingPreferenceError(
          context,
          'An unexpected error occurred',
        );
        break;
    }
  }
}
