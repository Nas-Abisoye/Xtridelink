import 'package:flutter/material.dart';
import 'package:xtridelink/core/helpers/error_handler/error_listener.dart';

abstract class LocalErrorListener extends ErrorListener {
  void onSharedPreferenceError(BuildContext context, String message);

  void onMappingPreferenceError(BuildContext context, String message);
}
