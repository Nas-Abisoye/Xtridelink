import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import '../../../../core/constants/enumerations.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../../core/services/navigation/index.dart';
import '../../../../core/services/navigation/routes.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';
import '../../../cubit/auth/index.dart';

class ForgotPwdPage extends StatefulWidget {
  const ForgotPwdPage({super.key});

  @override
  State<ForgotPwdPage> createState() => _ForgotPwdPageState();
}

class _ForgotPwdPageState extends State<ForgotPwdPage> {
  late ValueNotifier<bool> isFormValid;
  late TextEditingController emailController;
  @override
  void initState() {
    isFormValid = ValueNotifier(false);
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    isFormValid.dispose();
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
          SingleChildScrollView(
                  child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Forgot your password?',
                  style: AppTextStyles.mediumText(fontSize: 20)),
              HelperFunc.sb(10.h),
              Text('You can easily reset your password, enter your your registered email here.',
                      style: AppTextStyles.regularText(
                          fontSize: 13, color: AppColors.grey))
                  .pd(EdgeInsets.only(right: 50.w)),
              HelperFunc.sb(25.h),
              AppFormField(
                  hintText: 'Email Address',
                  labelText: 'Email Address',
                  controller: emailController,
                  keyBoardType: TextInputType.emailAddress,
                  onChanged: (v) => isFormValid.value = v.isValidEmail),
              HelperFunc.sb(20.h),
              RichText(
                  text: TextSpan(
                      text: 'Remember your password? ',
                      style: AppTextStyles.regularText(
                          fontSize: 12, color: Colors.black),
                      children: [
                    TextSpan(
                        text: 'Sign In',
                        style: AppTextStyles.mediumText(
                            fontSize: 12.5, color: AppColors.materialColor),
                        recognizer: TapGestureRecognizer()
                          ..onTap =
                              (() => globalReplaceWith(route: Routes.login))),
                  ]))
            ],
          ).pd(EdgeInsets.all(15.w)))
              .EXPANDED,
          ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, bool value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: () => value
                            ? context
                                .read<AuthCubit>()
                                .forgotPassword(email: emailController.text)
                            : null,
                        color: value ? null : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 10.h));
              }),
        ],
      )),
    );
  }
}
