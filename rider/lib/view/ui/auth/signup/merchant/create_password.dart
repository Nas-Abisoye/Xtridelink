import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/biometrics/index.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../../di/get_it.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../standalone/index.dart';

class CreateMerchantPwdPage extends StatefulWidget {
  const CreateMerchantPwdPage({super.key});

  @override
  State<CreateMerchantPwdPage> createState() => _CreateMerchantPwdPageState();
}

class _CreateMerchantPwdPageState extends State<CreateMerchantPwdPage> {
  late TextEditingController passwordController;
  late ValueNotifier<PasswordFormValidator> isPwdValid;
  @override
  void initState() {
    passwordController = TextEditingController();
    isPwdValid = ValueNotifier(PasswordFormValidator());
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    isPwdValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(children: [
              const AppBackButton(),
              const Spacer(),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                      2,
                      (index) => CircleAvatar(
                            radius: 4.r,
                            backgroundColor: index == 1
                                ? AppColors.secColor
                                : AppColors.grey.withOpacity(0.3),
                          ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
              HelperFunc.sb(15.w)
            ]),
            SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create password',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(10.h),
                Text('Setup a password for your account',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(25.h),
                AppFormField(
                    hintText: 'Enter Password',
                    labelText: 'Enter Password',
                    controller: passwordController,
                    keyBoardType: TextInputType.visiblePassword,
                    isPassword: true,
                    onChanged: (v) {
                      isPwdValid.value = PasswordFormValidator(
                          hasLowerCase:
                              v.contains(RegExp(r'[a-z]', caseSensitive: true)),
                          hasUpperCase:
                              v.contains(RegExp(r'[A-Z]', caseSensitive: true)),
                          hasNumber: v.contains(RegExp(r'[0-9]')),
                          hasSpecialChar:
                              v.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')));
                    },
                    validator: (v) => null),
                HelperFunc.sb(20.h),
                Text('Password Criteria',
                    style: AppTextStyles.regularText(
                        fontSize: 13, color: AppColors.grey)),
                HelperFunc.sb(10.h),
                ValueListenableBuilder(
                    valueListenable: isPwdValid,
                    builder: (context, PasswordFormValidator value, _) {
                      return Column(
                        children: [
                          PasswordValidityCheck(
                              check: value.hasUpperCase,
                              txt: 'Must contain Upper case'),
                          PasswordValidityCheck(
                              check: value.hasLowerCase,
                              txt: 'Must contain Lower case'),
                          PasswordValidityCheck(
                              check: value.hasNumber,
                              txt: 'Must contain Number'),
                          PasswordValidityCheck(
                              check: value.hasSpecialChar,
                              txt:
                                  'Must contain Special character (including punctuations)'),
                        ],
                      );
                    }),
              ],
            ).pd(EdgeInsets.all(15.w)))
                .EXPANDED,
            ValueListenableBuilder(
                valueListenable: isPwdValid,
                builder: (context, PasswordFormValidator value, _) {
                  return AppButton(
                          btnText: 'Continue',
                          onTap: value.isValid
                              ? () => globalReplaceWith(
                                  route: getItInst<BiometricsService>()
                                          .canAuthenticate
                                          .value
                                      ? Routes.enableBiometrics
                                      : Routes.setUserLocation)
                              : null,
                          color: value.isValid
                              ? null
                              : AppColors.grey.withOpacity(.5))
                      .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
                }),
          ],
        ),
      ),
    );
  }
}
