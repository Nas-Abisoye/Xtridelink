import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';

import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';

class ChooseDriverTypePage extends StatefulWidget {
  const ChooseDriverTypePage({super.key});

  @override
  State<ChooseDriverTypePage> createState() => _ChooseDriverTypePageState();
}

class _ChooseDriverTypePageState extends State<ChooseDriverTypePage> {
  late ValueNotifier<DriverType?> driverType;
  @override
  void initState() {
    driverType = ValueNotifier(null);
    super.initState();
  }

  @override
  void dispose() {
    driverType.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const AppBackButton(),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Choose driver type',
              style: AppTextStyles.mediumText(fontSize: 20)),
          HelperFunc.sb(10.h),
          Text('Lorem ipsum dolor sit amet consectetur.\nMagna id feugiat diam quisque nunc.',
                  style: AppTextStyles.regularText(
                      fontSize: 13, color: AppColors.grey))
              .pd(EdgeInsets.only(right: 50.w)),
          ValueListenableBuilder(
              valueListenable: driverType,
              builder: (context, value, _) {
                return Row(children: [
                  DriverTypeCard(
                          driverType: DriverType.standalone,
                          isActive: value == DriverType.standalone,
                          onTap: (v) => driverType.value = v,
                          asset: Assets.standalone,
                          description:
                              'As a standalone driver, you own your vehicle and run your own logistics business.')
                      .EXPANDED,
                  HelperFunc.sb(10.w),
                  DriverTypeCard(
                          driverType: DriverType.merchant,
                          isActive: value == DriverType.merchant,
                          onTap: (v) => driverType.value = v,
                          asset: Assets.merchant,
                          description:
                              'As a merchant driver, you work with a logistics business that uses Xtride.')
                      .EXPANDED,
                ]);
              }).EXPANDED,
          ValueListenableBuilder(
              valueListenable: driverType,
              builder: (context, value, _) => AppButton(
                  btnText: 'Continue',
                  onTap: () => switch (value) {
                        DriverType.standalone =>
                          globalNavigateTo(route: Routes.signUpAddPhone),
                        DriverType.merchant =>
                          globalNavigateTo(route: Routes.addMerchantMail),
                        null => null
                      },
                  color:
                      value != null ? null : AppColors.grey.withOpacity(.5))),
          HelperFunc.sb(25.h),
          RichText(
              text: TextSpan(
                  text: 'Already a driver? ',
                  style: AppTextStyles.regularText(color: Colors.black),
                  children: [
                TextSpan(
                    text: 'Sign In',
                    style: AppTextStyles.mediumText(
                        fontSize: 12.5, color: AppColors.materialColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => globalReplaceWith(route: Routes.login))),
              ])).align(Alignment.center)
        ],
      ).pd(EdgeInsets.all(15.w)).EXPANDED,
    ])));
  }
}

class DriverTypeCard extends StatelessWidget {
  final DriverType driverType;
  final bool isActive;
  final String asset, description;
  final void Function(DriverType) onTap;
  const DriverTypeCard(
      {super.key,
      required this.driverType,
      required this.asset,
      required this.description,
      required this.onTap,
      required this.isActive});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(driverType),
      child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(15.w, 5.h, 5.w, 30.h),
          decoration: BoxDecoration(
              color: isActive
                  ? AppColors.materialColor.withOpacity(.15)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                  color: isActive
                      ? AppColors.materialColor
                      : AppColors.grey.withOpacity(.15),
                  width: isActive ? 2 : 1)),
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            isActive
                ? Icon(Icons.check_circle,
                        color: AppColors.materialColor, size: 18.h)
                    .align(Alignment.topRight)
                : HelperFunc.sb(20.h),
            CircleAvatar(
                radius: 27.r,
                backgroundColor:
                    isActive ? Colors.white : AppColors.grey.withOpacity(.15),
                child: SvgPicture.asset(asset,
                    color: isActive ? AppColors.materialColor : null)),
            HelperFunc.sb(15.w),
            Text('${driverType.name.capitalizeFirstLetter}\ndriver',
                textAlign: TextAlign.center,
                style: AppTextStyles.semiBold(fontSize: 16)),
            HelperFunc.sb(12.h),
            Text(description,
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(
                    fontSize: 10, color: AppColors.grey))
          ])),
    );
  }
}
