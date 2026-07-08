import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:injectable/injectable.dart';
import 'package:xtridelink/core/constants/helpers.dart';

abstract class UpdateService {
  Future<void> updateIfAny();
}

@Injectable()
class UpdateServiceImpl extends UpdateService {
  @override
  Future<void> updateIfAny() async {
    if (!Platform.isAndroid) return;
    try {
      AppUpdateInfo updateInfo = await InAppUpdate.checkForUpdate();
      debugPrint('Ran Update Func $updateInfo');
      if (updateInfo.updateAvailability != UpdateAvailability.updateAvailable) {
        return;
      }
      if (updateInfo.immediateUpdateAllowed) {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          HelperFunc.toast(e.toString());
          return AppUpdateResult.inAppUpdateFailed;
        });
      } else if (updateInfo.flexibleUpdateAllowed) {
        InAppUpdate.startFlexibleUpdate().then((appUpdateResult) {
          if (appUpdateResult == AppUpdateResult.success) {
            InAppUpdate.completeFlexibleUpdate();
          }
        }).catchError((e) {
          HelperFunc.toast(e.toString());
        });
      } else {
        InAppUpdate.performImmediateUpdate().catchError((e) {
          HelperFunc.toast(e.toString());
          return AppUpdateResult.inAppUpdateFailed;
        });
      }
    } catch (e) {
      debugPrint('$e Update error');
      return;
    }
  }
}
