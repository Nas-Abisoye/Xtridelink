import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'dart:io';

@Injectable()
class BiometricsService {
  late LocalAuthentication auth;
  bool isIOS = true;
  ValueNotifier<bool> canAuthenticate = ValueNotifier(false);

  BiometricsService() {
    isIOS = Platform.isIOS;
    auth = LocalAuthentication();
    auth.getAvailableBiometrics().then((value) {
      canAuthenticate.value = value.isNotEmpty;
    });
  }

  Future<void> authenticate({void Function()? onAuth}) async {
    try {
      final bool didAuthenticate = await auth.authenticate(
          localizedReason: 'Please authenticate to continue',
          options: const AuthenticationOptions(
              biometricOnly: true, useErrorDialogs: false));

      if (didAuthenticate && onAuth != null) {
        onAuth();
      }
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        return HelperFunc.toast(
            e.message ?? 'Fingerprint not enrolled on device.');
      } else {
        return HelperFunc.toast(e.message ?? 'Something went wrong');
      }
    }
  }
}
