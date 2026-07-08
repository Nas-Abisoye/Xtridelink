import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import '../../../../../core/constants/assets.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/biometrics/index.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../../di/get_it.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class VerifyKYCPage extends StatelessWidget {
  final bool fromSignUp;
  const VerifyKYCPage({super.key, required this.fromSignUp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const AppBackButton(),
            const Spacer(),
            if (fromSignUp)
              TextButton(
                      onPressed: () {
                        globalPopUntil(Routes.completeKYC);
                        globalReplaceWith(
                            route: getItInst<BiometricsService>()
                                    .canAuthenticate
                                    .value
                                ? Routes.enableBiometrics
                                : Routes.setUserLocation);
                      },
                      child: Text('Skip',
                          style: AppTextStyles.semiBold(
                              color: Colors.black, fontSize: 13)))
                  .pd(EdgeInsets.only(right: 10.w)),
          ]),
          SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                HelperFunc.sb(5.h),
                Image.asset(Assets.kyc, height: 130.h, width: 100.w),
                HelperFunc.sb(15.h),
                Text('Verify your details',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(10.h),
                Text('To ensure your account is properly setup, you have to provide the necessary information',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(30.h),
                Text('What we will verify',
                    style: AppTextStyles.mediumText(
                        fontSize: 12, color: AppColors.grey)),
                HelperFunc.sb(25.h),
                const VerifyKYCTile(
                    asset: Assets.standalone,
                    header: 'Vehicle Details',
                    subText:
                        'You will provide the necessary registration documents for you to attest that you own such vehicle'),
                const VerifyKYCTile(
                    asset: Assets.id,
                    header: 'ID Verification',
                    subText:
                        'You will provide the necessary registration documents for you to attest that you own such vehicle'),
                const VerifyKYCTile(
                    showDivider: false,
                    asset: Assets.locationSvg2,
                    header: 'Address Verification',
                    subText:
                        'You will provide the necessary registration documents for you to attest that you own such vehicle'),
                HelperFunc.sb(10.h),
              ]).pd(EdgeInsets.all(20.w)))
              .EXPANDED,
          AppButton(
              btnText: 'Continue',
              onTap: () {
                if (fromSignUp == false) {
                  final profileCubit = context.read<ProfileCubit>();
                  final user = profileCubit.state.user;
                  final verificationStatus = user?.verificationStatus;
                  if (verificationStatus != null &&
                      verificationStatus.fullyVerified == true) {
                    globalPop();
                    HelperFunc.toast('Your KYC is already verified');
                    return;
                  } else if (verificationStatus != null &&
                      verificationStatus.vehicleStatus == 'not_provided') {
                    globalReplaceWith(route: Routes.addVehicleDetails);
                    return;
                  } else if (verificationStatus != null &&
                      verificationStatus.idStatus == 'not_provided') {
                    globalReplaceWith(route: Routes.addIdVerification);
                    return;
                  } else if (verificationStatus != null &&
                      verificationStatus.addressStatus == 'not_provided') {
                    globalReplaceWith(route: Routes.addressVerification);
                    return;
                  }
                }

                globalReplaceWith(
                    route: Routes.addVehicleDetails, arguments: fromSignUp);
              }).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h))
        ],
      )),
    );
  }
}

class VerifyKYCTile extends StatelessWidget {
  final String asset, header, subText;
  final bool showDivider;
  const VerifyKYCTile(
      {super.key,
      required this.asset,
      required this.header,
      required this.subText,
      this.showDivider = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(children: [
          SvgPicture.asset(asset, height: 17.h, color: AppColors.secColor),
          HelperFunc.sb(20.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(header, style: AppTextStyles.mediumText(fontSize: 12)),
            HelperFunc.sb(5.h),
            Text(subText,
                    style: AppTextStyles.regularText(
                        fontSize: 10, color: AppColors.grey.withOpacity(.8)))
                .pd(EdgeInsets.only(right: 50.w)),
          ]).EXPANDED
        ]),
        if (showDivider) Divider(height: 40.h)
      ],
    );
  }
}
