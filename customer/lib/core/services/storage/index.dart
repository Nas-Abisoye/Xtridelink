import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/domain/model/local/settings.dart';
import '../../constants/storage.dart';

abstract class StorageService {
  Future<void> setUserToken(String token);
  Future<String> getToken();
  Future<void> setDeviceToken(String token);
  Future<String> getDeviceToken();
  Future<void> setUserId(String id);
  Future<String> getUserId();
  Future<void> setSettings(SettingsState settings);
  Future<SettingsState> getSettings();
}

@Injectable()
class StorageServiceImpl extends StorageService {
  FlutterSecureStorage storage;
  StorageServiceImpl({required this.storage});

  @override
  Future<void> setUserToken(String token) async {
    await storage.write(key: StorageConstants.userToken, value: token);
  }

  @override
  Future<String> getToken() async {
    final value = await storage.read(key: StorageConstants.userToken) ?? '';
    return value;
  }

  @override
  Future<void> setUserId(String id) async {
    await storage.write(key: StorageConstants.userId, value: id);
  }

  @override
  Future<String> getUserId() async {
    final value = await storage.read(key: StorageConstants.userId) ?? '';
    return value;
  }

  @override
  Future<void> setSettings(SettingsState settings) async {
    await storage.write(
        key: StorageConstants.settings, value: jsonEncode(settings.toJson));
  }

  @override
  Future<SettingsState> getSettings() async {
    final value = await storage.read(key: StorageConstants.settings);
    return value == null
        ? SettingsState(
            recentLocations: [],
            email: '',
            password: '',
            biometricsLogin: false,
            useEnglish: true)
        : SettingsState.fromJson(jsonDecode(value));
  }

  @override
  Future<void> setDeviceToken(String token) async {
    await storage.write(key: StorageConstants.deviceToken, value: token);
  }

  @override
  Future<String> getDeviceToken() async {
    final value = await storage.read(key: StorageConstants.deviceToken) ?? '';
    return value;
  }

  void clearUserData() {
    storage.delete(key: StorageConstants.userId);
    storage.delete(key: StorageConstants.userToken);
  }
}
