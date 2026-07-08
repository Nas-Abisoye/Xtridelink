import 'package:injectable/injectable.dart';
import 'package:xtridelink_driver/core/helpers/preferences/app_preferences.dart';
import 'package:xtridelink_driver/data/source/remote/model/auth/get_user_details_response.dart';

@Injectable()
class AuthenticationLocalSource {
  AuthenticationLocalSource(this._appPreferences);

  final AppPreferences _appPreferences;

  Future<bool> saveAccessToken(String token) =>
      _appPreferences.saveAccessToken(token);

  String? get accessToken => _appPreferences.accessToken;

  Future<bool> saveUserEmail(String email) =>
      _appPreferences.saveUserEmail(email);

  String? get userEmail => _appPreferences.userEmail;

  Future<bool> saveIsActivatedToken({required bool isActivated}) =>
      _appPreferences.saveIsActivatedToken(isActivated: isActivated);

  bool get isActivated => _appPreferences.isActivated;

  Future<void> saveUserData(UserAccountData user) =>
      _appPreferences.saveUserData(user);

  UserAccountData? get userData => _appPreferences.userData;

  Future<void> clearUserData() async {
    return _appPreferences.clearUserData();
  }
}
