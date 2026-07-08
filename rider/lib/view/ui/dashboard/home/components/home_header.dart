import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/view/components/profile_avatar.dart';
import '../../../../components/notification_icon.dart';

class HomePageHeader extends StatelessWidget {
  final String? avatar, currentLocation;
  const HomePageHeader(
      {super.key, required this.avatar, required this.currentLocation});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        HelperFunc.sb(20.w),
        ProfileAvatar(avatar: avatar),
        HelperFunc.sb(10.w),
        Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('LOCATION',
                  style: AppTextStyles.regularText(
                      fontSize: 10, color: AppColors.grey)),
              HelperFunc.sb(3.h),
              Text(currentLocation ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.mediumText())
            ]).EXPANDED,
        HelperFunc.sb(40.w),
        // const Icon(Icons.keyboard_arrow_down_sharp),
        // const Spacer(),
        const NotificationIcon(),
        HelperFunc.sb(20.w)
      ],
    );
  }
}
