import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/cubit/auth/index.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';

class PasswordFormValidator {
  bool? hasUpperCase, hasLowerCase, hasNumber, hasSpecialChar;
  PasswordFormValidator(
      {this.hasUpperCase,
      this.hasLowerCase,
      this.hasNumber,
      this.hasSpecialChar});

  bool get isValid =>
      hasUpperCase == true &&
      hasLowerCase == true &&
      hasNumber == true &&
      hasSpecialChar == true;
}

class SignupUserFormPage extends StatefulWidget {
  const SignupUserFormPage({super.key});

  @override
  State<SignupUserFormPage> createState() => _SignupUserFormPageState();
}

class _SignupUserFormPageState extends State<SignupUserFormPage> {
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController refController;
  late ValueNotifier<PasswordFormValidator> isPwdValid;
  final GlobalKey<FormState> _formKey = GlobalKey();
  @override
  void initState() {
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    refController = TextEditingController();
    isPwdValid = ValueNotifier(PasswordFormValidator());
    super.initState();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    refController.dispose();
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
          SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 50.h),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tell us about yourself',
                        style: AppTextStyles.mediumText(fontSize: 20)),
                    HelperFunc.sb(10.h),
                    Text('Input brief details about you.',
                            style: AppTextStyles.regularText(
                                fontSize: 13, color: AppColors.grey))
                        .pd(EdgeInsets.only(right: 50.w)),
                    HelperFunc.sb(25.h),
                    AppFormField(
                        hintText: 'First Name',
                        labelText: 'First Name',
                        controller: firstNameController,
                        keyBoardType: TextInputType.name),
                    HelperFunc.sb(15.h),
                    AppFormField(
                        hintText: 'Last Name',
                        labelText: 'Last Name',
                        controller: lastNameController,
                        keyBoardType: TextInputType.name),
                    HelperFunc.sb(15.h),
                    AppFormField(
                        hintText: 'Email Address',
                        labelText: 'Email Address',
                        controller: emailController,
                        keyBoardType: TextInputType.emailAddress),
                    HelperFunc.sb(15.h),
                    AppFormField(
                        hintText: 'Enter Password',
                        labelText: 'Password',
                        controller: passwordController,
                        keyBoardType: TextInputType.visiblePassword,
                        isPassword: true,
                        onChanged: (v) {
                          isPwdValid.value = PasswordFormValidator(
                              hasLowerCase: v.contains(
                                  RegExp(r'[a-z]', caseSensitive: true)),
                              hasUpperCase: v.contains(
                                  RegExp(r'[A-Z]', caseSensitive: true)),
                              hasNumber: v.contains(RegExp(r'[0-9]')),
                              hasSpecialChar: v
                                  .contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]')));
                        },
                        validator: (v) => null),
                    HelperFunc.sb(25.h),
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
                        hintText: 'Referral Code (Optional)',
                        labelText: 'Referral Code (Optional)',
                        controller: refController,
                        validator: (v) => null),
                  ],
                ),
              )).EXPANDED,
          ListenableBuilder(
              // valueListenable: isPwdValid,
              listenable: Listenable.merge([
                isPwdValid,
                firstNameController,
                lastNameController,
                emailController
              ]),
              builder: (context, _) {
                final isValid = isPwdValid.value.isValid &&
                    firstNameController.text.isNotEmpty &&
                    lastNameController.text.isNotEmpty &&
                    emailController.text.isValidEmail;
                return AppButton(
                        btnText: 'Continue',
                        onTap: isValid
                            ? () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<AuthCubit>().signUp(
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      email: emailController.text,
                                      referralCode: refController.text,
                                      password: passwordController.text);
                                }
                              }
                            : null,
                        color: isValid ? null : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}

class PasswordValidityCheck extends StatelessWidget {
  final bool? check;
  final String txt;
  const PasswordValidityCheck(
      {super.key, required this.check, required this.txt});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_circle,
            color: check == null
                ? AppColors.grey
                : check == true
                    ? AppColors.green
                    : AppColors.red,
            size: 15.sp),
        HelperFunc.sb(7.w),
        Expanded(
            child: Text(txt,
                style: AppTextStyles.regularText(
                    color: AppColors.grey, fontSize: 11.5)))
      ],
    ).pd(EdgeInsets.only(bottom: 8.h));
  }
}
