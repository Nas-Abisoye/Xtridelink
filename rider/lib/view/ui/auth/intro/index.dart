import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import '../../../../core/constants/assets.dart';
import '../../../cubit/settings/index.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  @override
  void initState() {
    context.read<SettingsCubit>().loadSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.lightSec,
        body: SafeArea(
            bottom: false,
            child: Column(children: [
              HelperFunc.sb(20.h),
              Image.asset(Assets.intro).pd(EdgeInsets.all(40.w)).EXPANDED,
              Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20.h),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(50.r))),
                  child: SafeArea(
                      child: Column(children: [
                    HelperFunc.sb(40.h),
                    Text('Become a\nXtride driver',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.boldText(fontSize: 28)),
                    HelperFunc.sb(15.h),
                    Text('Join our numerous experienced and compliant partners to have access to delivery services to thousands of our esteemed customers with just a click.',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regularText(
                                fontSize: 13, color: AppColors.grey))
                        .pd(EdgeInsets.symmetric(horizontal: 35.w)),
                    HelperFunc.sb(80.h),
                    AppButton(
                        btnText: 'Sign up as a new driver',
                        onTap: () =>
                            globalNavigateTo(route: Routes.chooseDriverType)),
                    HelperFunc.sb(5.h),
                    RichText(
                        text: TextSpan(
                            text: 'Already a driver? ',
                            style: AppTextStyles.mediumText(
                                fontSize: 12.5, color: Colors.black),
                            children: [
                          TextSpan(
                              text: 'Sign In',
                              style: AppTextStyles.mediumText(
                                  fontSize: 12.5,
                                  color: AppColors.materialColor),
                              recognizer: TapGestureRecognizer()
                                ..onTap = (() =>
                                    globalNavigateTo(route: Routes.login))),
                        ])).pd(EdgeInsets.symmetric(vertical: 15.h))
                  ])))
            ])));
  }
}
