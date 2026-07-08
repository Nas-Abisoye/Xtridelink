import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:uuid/uuid.dart';

class DeviceHelper {
  static DeviceInfoPlugin plugin = DeviceInfoPlugin();

  static const storage = const FlutterSecureStorage();

  static const DEVICEIDKEY = 'device-id-key';

  static Future<String> getDeviceUniqueId() async {
    final hasKey = await storage.containsKey(key: DEVICEIDKEY);
    if (hasKey) {
      final deviceId = await storage.read(key: DEVICEIDKEY);
      return deviceId ?? '';
    } else {
      try {
        final deviceId = await _generateDeviceUniqueId();
        return deviceId;
      } catch (e) {
        return '';
      }
    }
  }

  static Future<String> _generateDeviceUniqueId() async {
    if (Platform.isAndroid) {
      final deviceInfo = await plugin.androidInfo;
      final keys = [
        const Symbol('deviceVersion'),
        const Symbol('deviceBrand'),
        const Symbol('deviceName'),
        const Symbol('installId')
      ];
      final values = [
        deviceInfo.version,
        deviceInfo.brand,
        deviceInfo.device,
        deviceInfo.id
      ];
      final deviceId = const Uuid().v4(
        options: {'namedArgs': Map.fromIterables(keys, values)},
      );
      storage.write(key: DEVICEIDKEY, value: deviceId);
      return deviceId;
    } else if (Platform.isIOS) {
      final deviceInfo = await plugin.iosInfo;
      final deviceId =
          '${deviceInfo.identifierForVendor}-${deviceInfo.systemName}';
      storage.write(key: DEVICEIDKEY, value: deviceId);
      return deviceId;
    } else {
      return "";
    }
  }
}
