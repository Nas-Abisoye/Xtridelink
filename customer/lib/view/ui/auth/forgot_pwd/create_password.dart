import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';
import '../../../cubit/auth/index.dart';
import '../signup/signup_screen.dart';

class CreateNewPwdPage extends StatefulWidget {
  const CreateNewPwdPage({super.key});

  @override
  State<CreateNewPwdPage> createState() => _CreateNewPwdPageState();
}

class _CreateNewPwdPageState extends State<CreateNewPwdPage> {
  late TextEditingController confirmPwdController;
  late TextEditingController passwordController;
  late ValueNotifier<PasswordFormValidator> isPwdValid;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    passwordController = TextEditingController();
    confirmPwdController = TextEditingController();
    isPwdValid = ValueNotifier(PasswordFormValidator());
    super.initState();
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPwdController.dispose();
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
                    3,
                    (index) => CircleAvatar(
                          radius: 4.r,
                          backgroundColor: index == 2
                              ? AppColors.secColor
                              : AppColors.grey.withOpacity(0.3),
                        ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
            HelperFunc.sb(15.w)
          ]),
          Expanded(
              child: SingleChildScrollView(
                  child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Create new password',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(10.h),
                Text('Create a new password for your account',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w)),
                HelperFunc.sb(25.h),
                AppFormField(
                    hintText: 'Enter New Password',
                    labelText: 'Enter New Password',
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
                HelperFunc.sb(15.h),
                AppFormField(
                    hintText: 'Confirm Password',
                    labelText: 'Confirm Password',
                    controller: confirmPwdController,
                    keyBoardType: TextInputType.visiblePassword,
                    isPassword: true,
                    validator: (v) {
                      if (v != passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    }),
              ],
            ).pd(EdgeInsets.all(15.w)),
          ))),
          ValueListenableBuilder(
              valueListenable: isPwdValid,
              builder: (context, PasswordFormValidator value, _) {
                return AppButton(
                        btnText: 'Continue',
                        color: value.isValid
                            ? null
                            : AppColors.grey.withOpacity(.5),
                        onTap: value.isValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  // context.read<AuthCubit>().resetPassword(
                                  //     newPassword: passwordController.text);
                                }
                              }
                            : null)
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}
