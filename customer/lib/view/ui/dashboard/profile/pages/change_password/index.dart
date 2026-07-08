import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';
import '../../../../../components/form_field.dart';
import '../../../../auth/signup/signup_screen.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late TextEditingController oldPwdController;
  late TextEditingController newPwdController;
  late ValueNotifier<PasswordFormValidator> isPwdValid;
  @override
  void initState() {
    newPwdController = TextEditingController();
    oldPwdController = TextEditingController();
    isPwdValid = ValueNotifier(PasswordFormValidator());
    super.initState();
  }

  @override
  void dispose() {
    newPwdController.dispose();
    oldPwdController.dispose();
    isPwdValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppBackButton(),
          Expanded(
              child: SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Change Password',
                  style: AppTextStyles.mediumText(fontSize: 20)),
              HelperFunc.sb(10.h),
              Text('Reset the password to your account',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w)),
              HelperFunc.sb(25.h),
              AppFormField(
                  hintText: 'Enter Old Password',
                  labelText: 'Enter Old Password',
                  controller: oldPwdController,
                  keyBoardType: TextInputType.visiblePassword,
                  isPassword: true,
                  validator: (v) => null),
              HelperFunc.sb(15.h),
              AppFormField(
                  hintText: 'Enter New Password',
                  labelText: 'Enter New Password',
                  controller: newPwdController,
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
                            check: value.hasNumber, txt: 'Must contain Number'),
                        PasswordValidityCheck(
                            check: value.hasSpecialChar,
                            txt:
                                'Must contain Special character (including punctuations)'),
                      ],
                    );
                  }),
            ],
          ).pd(EdgeInsets.all(15.w)))),
          ValueListenableBuilder(
              valueListenable: isPwdValid,
              builder: (context, PasswordFormValidator value, _) {
                return AppButton(
                        btnText: 'Change Password',
                        color: value.isValid
                            ? null
                            : AppColors.grey.withOpacity(.5),
                        onTap: value.isValid
                            ? () => context.read<ProfileCubit>().changePassword(
                                oldPassword: oldPwdController.text,
                                newPassword: newPwdController.text)
                            : null)
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}
