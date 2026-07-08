import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/biometrics/index.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../../di/get_it.dart';
import '../../../../components/button.dart';

class CompleteKYC extends StatelessWidget {
  const CompleteKYC({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSec,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HelperFunc.sb(20.h),
              Image.asset(Assets.kyc).pd(EdgeInsets.all(50.w)).EXPANDED,
              Container(
                  width: double.infinity,
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50.r))),
                  child: SafeArea(
                      child: Column(children: [
                    HelperFunc.sb(50.h),
                    Text('Complete\nyour KYC',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.boldText(fontSize: 28)),
                    HelperFunc.sb(15.h),
                    Text('Upload your verifiable required documents and details.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regularText(
                                color: AppColors.grey))
                        .pd(EdgeInsets.symmetric(horizontal: 35.w)),
                    HelperFunc.sb(90.h),
                    AppButton(
                        btnText: 'Continue',
                        onTap: () => globalNavigateTo(
                            route: Routes.verifyKYC, arguments: true)),
                    HelperFunc.sb(5.h),
                    TextButton(
                        onPressed: () => globalReplaceWith(
                            route: getItInst<BiometricsService>()
                                    .canAuthenticate
                                    .value
                                ? Routes.enableBiometrics
                                : Routes.setUserLocation),
                        child: Text('Skip',
                            style: AppTextStyles.mediumText(
                                fontSize: 12.5, color: Colors.black)))
                  ])))
            ],
          )),
    );
  }
}
