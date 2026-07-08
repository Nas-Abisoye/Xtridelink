import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/view/components/button.dart';

import '../../../../../../../core/services/navigation/index.dart';

class TimelineEnable2FA extends StatelessWidget {
  const TimelineEnable2FA({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          HelperFunc.sb(25.h),
          CircleAvatar(
              radius: 55.r,
              backgroundColor: AppColors.green.withOpacity(.2),
              child: SvgPicture.asset(Assets.shield)),
          HelperFunc.sb(20.h),
          Text('Enable 2FA delivery\nverification',
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(fontSize: 22)),
          HelperFunc.sb(10.h),
          Text('2FA delivery verification will activate once the driver ends the trip.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularText(
                      fontSize: 14, color: AppColors.grey))
              .pd(EdgeInsets.symmetric(horizontal: 50.w)),
          HelperFunc.sb(50.h),
          AppButton(
              onTap: () {
                globalPop();
                HelperFunc.showFittedBottomSheet(
                    context: context,
                    showBackButton: false,
                    child: const TimelineCopy2FACode());
              },
              btnText: 'Enable 2FA'),
          HelperFunc.sb(5.h),
          TextButton(
              onPressed: () => globalPop(),
              child: Text('Cancel',
                  style: AppTextStyles.mediumText(color: Colors.black)))
        ],
      ).pd(EdgeInsets.symmetric(horizontal: 20.w)),
    );
  }
}

class TimelineCopy2FACode extends StatelessWidget {
  const TimelineCopy2FACode({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          CircleAvatar(
              radius: 55.r,
              backgroundColor: AppColors.lightSec,
              child: SvgPicture.asset(Assets.code)),
          HelperFunc.sb(25.h),
          Text('Your 2FA code',
              textAlign: TextAlign.center,
              style: AppTextStyles.semiBold(fontSize: 22)),
          HelperFunc.sb(5.h),
          Text('Provide the code to driver on delivery',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularText(
                      fontSize: 14, color: AppColors.grey))
              .pd(EdgeInsets.symmetric(horizontal: 50.w)),
          Container(
            padding: EdgeInsets.symmetric(vertical: 25.h),
            margin: EdgeInsets.symmetric(horizontal: 30.h, vertical: 18.h),
            width: double.infinity,
            decoration: BoxDecoration(
                color: AppColors.ashBg,
                borderRadius: BorderRadius.circular(16.r)),
            child: Column(
              children: [
                Text('CODE',
                    style: AppTextStyles.regularText(fontSize: 10)
                        .copyWith(letterSpacing: 2.5)),
                HelperFunc.sb(10.h),
                Text('123-456',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.mediumText(fontSize: 22))
              ],
            ),
          ),
          HelperFunc.sb(20.h),
          AppButton(
              onTap: () {
                globalPop();
                HelperFunc.copyToClipboard('CODE');
              },
              color: Colors.black,
              btnText: 'Copy Code')
        ],
      ).pd(EdgeInsets.symmetric(horizontal: 20.w)),
    );
  }
}
