import 'package:flutter/foundation.dart';

class AppConstants {
  AppConstants._();

  /// hero tags
  static const String heroTagSelectUser = 'heroTagSelectUser';
  static const String heroTagSelectAddress = 'heroTagSelectAddress';
  static const String heroTagSelectCurrency = 'heroTagSelectCurrency';

  static const String riderAvatar = 'https://avatar.iran.liara.run/public/15';

  /// api urls
  static const String baseUrl = 'https://pyramid-weng.onrender.com';

  static const List<String> countries = ['Nigeria'];
  static const List<String> statesInNigeria = ['Nigeria'];
  static const int sessionDialogTimeout = kDebugMode ? 1000 : 110;
  static const int showDialogTime = kDebugMode ? 100 : 20;
}
