import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/helpers/preferences/app_preferences.dart';
import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';

@Injectable()
class AuthenticationLocalSource {
  AuthenticationLocalSource(this._appPreferences);

  final AppPreferences _appPreferences;

  Future<bool> saveAccessToken(String token) =>
      _appPreferences.saveAccessToken(token);

  String? get accessToken => _appPreferences.accessToken;

  Future<bool> saveRefreshToken(String token) =>
      _appPreferences.saveRefreshToken(token);

  String? get refreshToken => _appPreferences.refreshToken;

  Future<bool> saveUserEmail(String email) =>
      _appPreferences.saveUserEmail(email);

  String? get userEmail => _appPreferences.userEmail;

  Future<bool> saveIsActivatedToken({required bool isActivated}) =>
      _appPreferences.saveIsActivatedToken(isActivated: isActivated);

  bool get isActivated => _appPreferences.isActivated;

  Future<void> saveUserData(User user) => _appPreferences.saveUserData(user);

  User? get userData => _appPreferences.userData;

  Future<void> clearUserData() async {
    return _appPreferences.clearUserData();
  }

  Future<void> storeFCMDeviceToken(String token) async {
    return _appPreferences.storeFCMDeviceToken(token);
  }

  String? get fcmDeviceToken {
    return _appPreferences.fcmDeviceToken;
  }
}
