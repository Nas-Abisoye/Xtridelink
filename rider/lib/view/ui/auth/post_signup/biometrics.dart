import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/biometrics/index.dart';
import 'package:xtridelink_driver/di/get_it.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/button.dart';
import '../../../cubit/settings/index.dart';

class EnableBiometrics extends StatelessWidget {
  const EnableBiometrics({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightSec,
      body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              HelperFunc.sb(20.h),
              Image.asset(Assets.biometrics).pd(EdgeInsets.all(40.w)).EXPANDED,
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.h),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.r))),
                child: SafeArea(
                  child: Column(
                    children: [
                      HelperFunc.sb(40.h),
                      Text('Enable\nBiometrics',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.boldText(fontSize: 28)),
                      HelperFunc.sb(15.h),
                      Text('For quick access.',
                              textAlign: TextAlign.center,
                              style: AppTextStyles.regularText(
                                  color: AppColors.grey))
                          .pd(EdgeInsets.symmetric(horizontal: 25.w)),
                      HelperFunc.sb(100.h),
                      AppButton(
                          btnText: 'Enable Face ID/Fingerprint',
                          onTap: () => getItInst<BiometricsService>()
                                  .authenticate(onAuth: () {
                                HelperFunc.toast('Face ID/Fingerprint enabled');
                                globalReplaceWith(
                                    route: Routes.setUserLocation);
                                context
                                    .read<SettingsCubit>()
                                    .toggleBiometricsLogin(true);
                              })),
                      HelperFunc.sb(5.h),
                      TextButton(
                          onPressed: () =>
                              globalReplaceWith(route: Routes.setUserLocation),
                          child: Text('Skip',
                              style: AppTextStyles.mediumText(
                                  fontSize: 12.5, color: Colors.black)))
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
