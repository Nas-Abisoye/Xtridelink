import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/debouncer.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/phone_input.dart';
import '../../../../cubit/auth/index.dart';
import '../../../../cubit/settings/index.dart';

class AddPhoneSignupPage extends StatefulWidget {
  const AddPhoneSignupPage({super.key});

  @override
  State<AddPhoneSignupPage> createState() => _AddPhoneSignupPageState();
}

class _AddPhoneSignupPageState extends State<AddPhoneSignupPage> {
  late TextEditingController phoneNoController;
  final _debouncer = Debouncer();
  String? countryCode;
  @override
  void initState() {
    countryCode = '+234';
    context.read<SettingsCubit>().clearSettings();
    phoneNoController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    phoneNoController.dispose();
    _debouncer.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Column(children: [
      Row(children: [
        const AppBackButton(),
        const Spacer(),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
                3,
                (index) => CircleAvatar(
                      radius: 4.r,
                      backgroundColor: index == 0
                          ? AppColors.secColor
                          : AppColors.grey.withValues(alpha: 0.3),
                    ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
        HelperFunc.sb(15.w)
      ]),
      SingleChildScrollView(
              child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('What is your phone number?',
              style: AppTextStyles.mediumText(fontSize: 20)),
          HelperFunc.sb(25.h),
          CustomPhoneInput(
              controller: phoneNoController,
              onInputChanged: (v) =>
                  _debouncer(() => countryCode = v.dialCode)),
          HelperFunc.sb(20.h),
          RichText(
              text: TextSpan(
                  text:
                      'By clicking on continue, you agree to xtridelink_driver’s  ',
                  style: AppTextStyles.regularText(
                      fontSize: 11.5, color: AppColors.grey),
                  children: [
                TextSpan(
                    text: 'Terms of service',
                    style: AppTextStyles.mediumText(
                        fontSize: 11.5, color: AppColors.materialColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => globalNavigateTo(
                          route: Routes.legal,
                          arguments: XtridelinkDocsType.terms))),
                TextSpan(
                    text: ' and ',
                    style: AppTextStyles.regularText(color: AppColors.grey)),
                TextSpan(
                    text: 'Privacy policy.',
                    style: AppTextStyles.mediumText(
                        fontSize: 11.5, color: AppColors.materialColor),
                    recognizer: TapGestureRecognizer()
                      ..onTap = (() => globalNavigateTo(
                          route: Routes.legal,
                          arguments: XtridelinkDocsType.privacy)))
              ])),
        ],
      ).pd(EdgeInsets.all(15.w)))
          .EXPANDED,
      ValueListenableBuilder(
          valueListenable: phoneNoController,
          builder: (context, value, _) {
            print(value.text);
            return AppButton(
                    btnText: 'Continue',
                    onTap: () => value.text.replaceAll(' ', '').length == 10
                        ? context.read<AuthCubit>().sendOtpToNumber(
                            countryCode: countryCode ?? '+234',
                            phoneNumber: value.text.replaceAll(' ', ''))
                        : null,
                    color: value.text.replaceAll(' ', '').length == 10
                        ? null
                        : AppColors.grey.withOpacity(.5))
                .pd(EdgeInsets.symmetric(horizontal: 15.w));
          }),
      HelperFunc.sb(5.h),
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
                  ..onTap = (() {
                    globalPopUntil(Routes.intro);
                    globalNavigateTo(route: Routes.login);
                  })),
          ])).pd(EdgeInsets.fromLTRB(15.w, 20.h, 15.w, 15.h))
    ])));
  }
}
