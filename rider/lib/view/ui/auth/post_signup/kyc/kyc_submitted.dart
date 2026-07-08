import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/biometrics/index.dart';
import '../../../../../di/get_it.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class KycDocumentSubmittedPage extends StatelessWidget {
  final bool fromSignUp;
  const KycDocumentSubmittedPage({super.key, required this.fromSignUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Align(alignment: Alignment.topLeft, child: AppBackButton()),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                CircleAvatar(
                    backgroundColor: AppColors.lightSec,
                    radius: 68.r,
                    child: SvgPicture.asset(Assets.hourGlass)),
                HelperFunc.sb(25.h),
                Text('Document submitted awaiting approval',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semiBold(fontSize: 25))
                    .pd(EdgeInsets.symmetric(horizontal: 30.w)),
                HelperFunc.sb(10.h),
                Text('Your documents have been submitted successfully and will be reviewed within a couple of hours.  You will be notified via in-app notification and email.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 35.w)),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          AppButton(
                  onTap: fromSignUp
                      ? () {
                          globalPopUntil(Routes.completeKYC);
                          globalReplaceWith(
                              route: getItInst<BiometricsService>()
                                      .canAuthenticate
                                      .value
                                  ? Routes.enableBiometrics
                                  : Routes.setUserLocation);
                        }
                      : () => globalPopUntil(Routes.base),
                  btnText: 'Continue')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
