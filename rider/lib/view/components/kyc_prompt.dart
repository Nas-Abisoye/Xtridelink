import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/helpers.dart';
import '../../core/constants/text_styles.dart';
import '../../core/services/navigation/index.dart';
import '../../core/services/navigation/routes.dart';
import 'button.dart';

class KycPrompt extends StatelessWidget {
  const KycPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      Image.asset(Assets.kyc, height: 110.h),
      HelperFunc.sb(30.h),
      Text('Complete your KYC',
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBold(fontSize: 20)),
      HelperFunc.sb(18.h),
      Text('To ensure your account is properly setup, you have to provide the necessary information',
              textAlign: TextAlign.center,
              style: AppTextStyles.regularText(color: AppColors.grey))
          .pd(EdgeInsets.symmetric(horizontal: 60.w)),
      HelperFunc.sb(50.h),
      AppButton(
          btnText: 'Complete KYC',
          color: Colors.black,
          onTap: () {
            globalPop();
            globalNavigateTo(route: Routes.verifyKYC);
          }),
      HelperFunc.sb(5.h),
      TextButton(
          onPressed: () => globalPop(),
          child: Text('Cancel',
              style: AppTextStyles.semiBold(fontSize: 13, color: Colors.black)))
    ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)));
  }
}
