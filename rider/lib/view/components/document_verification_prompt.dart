import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';

import '../../core/constants/assets.dart';
import '../../core/constants/colors.dart';
import '../../core/constants/helpers.dart';
import '../../core/constants/text_styles.dart';
import '../../core/services/navigation/index.dart';
import 'button.dart';

class DocumentVerificationPrompt extends StatelessWidget {
  const DocumentVerificationPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(children: [
      Image.asset(Assets.kyc, height: 110.h),
      HelperFunc.sb(30.h),
      Text('Documents Under Review',
          textAlign: TextAlign.center,
          style: AppTextStyles.semiBold(fontSize: 20)),
      HelperFunc.sb(18.h),
      Text(
          'Your documents are currently being verified. We will notify you once your documents have been approved.',
          textAlign: TextAlign.center,
          style: AppTextStyles.regularText(color: AppColors.grey)).pd(
          EdgeInsets.symmetric(horizontal: 60.w)),
      HelperFunc.sb(50.h),
      AppButton(
          btnText: 'OK',
          color: Colors.black,
          onTap: () {
            globalPop();
          }),
    ]).pd(EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h)));
  }
}
