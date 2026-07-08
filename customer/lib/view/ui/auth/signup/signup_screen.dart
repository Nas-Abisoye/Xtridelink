import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/base/base_stateful_page.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/ui/auth/signup/cubit/signup_cubit.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../components/back_button.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';

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

class SignupUserFormPage extends StatelessWidget {
  final String phoneNumber;

  SignupUserFormPage({required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<SignupCubit>(),
      child: SignupUserFormView(phoneNumber: phoneNumber),
    );
  }
}

class SignupUserFormView extends StatefulWidget {
  const SignupUserFormView({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<SignupUserFormView> createState() => _SignupUserFormViewState();
}

class _SignupUserFormViewState
    extends BaseStatefulPage<SignupCubit, SignupUserFormView> {
  late ValueNotifier<PasswordFormValidator> isPwdValid;

  @override
  void initState() {
    isPwdValid = ValueNotifier(PasswordFormValidator());
    super.initState();
  }

  @override
  void dispose() {
    isPwdValid.dispose();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          previous.createUserResponse != current.createUserResponse,
      listener: (context, state) {
        if (state.createUserResponse.hasSuccess) {
          globalReplaceUntil(route: Routes.base);
        }
      },
      child: Scaffold(
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
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return AppFormField(
                          hintText: 'First Name',
                          labelText: 'First Name',
                          keyBoardType: TextInputType.name,
                          validator: (v) =>
                              state.formData.firstName.error?.message,
                          onChanged: (v) =>
                              context.read<SignupCubit>().onFirstNameChanged(v),
                        );
                      },
                    ),
                    HelperFunc.sb(15.h),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return AppFormField(
                          hintText: 'Last Name',
                          labelText: 'Last Name',
                          keyBoardType: TextInputType.name,
                          validator: (v) =>
                              state.formData.lastName.error?.message,
                          onChanged: (v) =>
                              context.read<SignupCubit>().onLastNameChanged(v),
                        );
                      },
                    ),
                    HelperFunc.sb(15.h),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) => AppFormField(
                        hintText: 'Email',
                        labelText: 'Email',
                        keyBoardType: TextInputType.emailAddress,
                        validator: (v) => state.formData.email.error?.message,
                        onChanged: (v) =>
                            context.read<SignupCubit>().onEmailChanged(v),
                      ),
                    ),
                    HelperFunc.sb(15.h),
                    BlocBuilder<SignupCubit, SignupState>(
                      builder: (context, state) {
                        return AppFormField(
                            hintText: 'Enter Password',
                            labelText: 'Password',
                            keyBoardType: TextInputType.visiblePassword,
                            isPassword: true,
                            onChanged: (v) {
                              isPwdValid.value = PasswordFormValidator(
                                  hasLowerCase: v.contains(
                                      RegExp(r'[a-z]', caseSensitive: true)),
                                  hasUpperCase: v.contains(
                                      RegExp(r'[A-Z]', caseSensitive: true)),
                                  hasNumber: v.contains(RegExp(r'[0-9]')),
                                  hasSpecialChar: v.contains(
                                      RegExp(r'[!@#$%^&*(),.?":{}|<>]')));

                              if (isPwdValid.value.isValid) {
                                context
                                    .read<SignupCubit>()
                                    .onPasswordChanged(v);
                              }
                            },
                            validator: (v) => null);
                      },
                    ),
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
                    // AppFormField(
                    //     hintText: 'Referral Code (Optional)',
                    //     labelText: 'Referral Code (Optional)',
                    //     validator: (v) => null),
                  ],
                )).EXPANDED,
            BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
              return AppButton(
                      btnText: 'Continue',
                      onTap: state.formData.canCreateUser
                          ? () {
                              context
                                  .read<SignupCubit>()
                                  .completeRegistration(widget.phoneNumber);
                            }
                          : null,
                      color: state.formData.canCreateUser
                          ? null
                          : AppColors.grey.withOpacity(.5))
                  .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
            }),
          ],
        )),
      ),
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
