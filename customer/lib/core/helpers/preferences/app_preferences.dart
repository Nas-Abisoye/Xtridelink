import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/helpers/exception/local_exception.dart';
import 'package:xtridelink/core/helpers/preferences/config/shared_pref_key.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:xtridelink/data/source/remote/model/auth/get_user_details_response.dart';

@Injectable()
class AppPreferences {
  AppPreferences(this._sharedPreferences);

  final SharedPreferences _sharedPreferences;

  Future<bool> saveAccessToken(String token) {
    return _sharedPreferences
        .setString(SharedPrefKey.accessToken, token)
        .catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Can not save access token',
            error,
          ),
        );
  }

  String? get accessToken {
    return _sharedPreferences.getString(SharedPrefKey.accessToken);
  }

  Future<bool> saveRefreshToken(String token) {
    return _sharedPreferences
        .setString(SharedPrefKey.refreshToken, token)
        .catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Can not save refresh token',
            error,
          ),
        );
  }

  String? get refreshToken {
    return _sharedPreferences.getString(SharedPrefKey.refreshToken);
  }

  Future<bool> saveIsActivatedToken({required bool isActivated}) =>
      _sharedPreferences
          .setBool(SharedPrefKey.isActivated, isActivated)
          .catchError(
            (dynamic error) => throw LocalException.sharedPreferenceError(
              'Can not save activated',
              error,
            ),
          );

  bool get isActivated {
    return _sharedPreferences.getBool(SharedPrefKey.isActivated) ?? false;
  }

  Future<void> saveUserData(User user) {
    return _sharedPreferences
        .setString(SharedPrefKey.currentUser, jsonEncode(user.toMap()))
        .catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Can not save user details',
            error,
          ),
        );
  }

  User? get userData {
    final user = _sharedPreferences.getString(SharedPrefKey.currentUser);
    if (user == null) return null;
    return User.fromMap(
      json.decode(user) as Map<String, dynamic>,
    );
  }

  Future<void> clearUserData() async {
    await _sharedPreferences.clear();
  }

  Future<bool> storeString({required String key, required String value}) async {
    return _sharedPreferences.setString(key, value).catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Could not save $key',
            error,
          ),
        );
  }

  String? getString(String key) {
    return _sharedPreferences.getString(key);
  }

  Future<bool> saveUserEmail(String email) {
    return _sharedPreferences.setString(SharedPrefKey.email, email).catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Can not save email',
            error,
          ),
        );
  }

  String? get userEmail {
    return _sharedPreferences.getString(SharedPrefKey.email);
  }

  Future<void> storeFCMDeviceToken(String token) async {
    await _sharedPreferences
        .setString(SharedPrefKey.deviceToken, token)
        .catchError(
          (dynamic error) => throw LocalException.sharedPreferenceError(
            'Could not save device token',
            error,
          ),
        );
  }

  String? get fcmDeviceToken {
    return _sharedPreferences.getString(SharedPrefKey.deviceToken);
  }
}
