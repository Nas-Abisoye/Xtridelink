import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import 'package:xtridelink/view/components/profile_avatar.dart';

import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';

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
              Text('CURRENT LOCATION',
                  style: AppTextStyles.regularText(
                      fontSize: 10, color: AppColors.grey)),
              HelperFunc.sb(3.h),
              GestureDetector(
                onTap: () => globalNavigateTo(route: Routes.editAddress),
                child: Text(currentLocation ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.mediumText()),
              )
            ]).EXPANDED,
        HelperFunc.sb(40.w),
        // const Icon(Icons.keyboard_arrow_down_sharp),
        // const Spacer(),
        IconAvatar(
            onTap: () => globalNavigateTo(route: Routes.notifications),
            avatar: Assets.notification,
            radius: 17),
        HelperFunc.sb(20.w)
      ],
    );
  }
}
