import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import 'icon_avatar.dart';

class NotificationIcon extends StatelessWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return IconAvatar(
        onTap: () => globalNavigateTo(route: Routes.notifications),
        avatar: Assets.notification,
        color: Colors.black,
        fillColor: AppColors.lightSec,
        radius: 17);
  }
}
