import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/base/base_stateful_page.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/separator.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/components/back_button.dart';
import 'package:xtridelink/view/ui/auth/signup/cubit/signup_cubit.dart';

import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';
import '../../../components/button.dart';
import '../../../components/form_field.dart';

class SignUpVerifyPhonePage extends StatelessWidget {
  final String phoneNumber;
  const SignUpVerifyPhonePage({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => getIt<SignupCubit>(),
        child: SignUpVerifyPhoneView(phoneNumber: phoneNumber));
  }
}

class SignUpVerifyPhoneView extends StatefulWidget {
  final String phoneNumber;
  const SignUpVerifyPhoneView({super.key, required this.phoneNumber});

  @override
  State<SignUpVerifyPhoneView> createState() => _SignUpVerifyPhoneViewState();
}

class _SignUpVerifyPhoneViewState
    extends BaseStatefulPage<SignupCubit, SignUpVerifyPhoneView> {
  late ValueNotifier<Duration> oneMin;
  late Timer? timer;

  void setTimer() {
    oneMin = ValueNotifier(const Duration(minutes: 2));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      oneMin.value = Duration(seconds: oneMin.value.inSeconds - 1);
      if (oneMin.value.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    setTimer();

    super.initState();
  }

  @override
  void dispose() {
    oneMin.dispose();
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget buildPage(BuildContext context) {
    return BlocListener<SignupCubit, SignupState>(
      listenWhen: (previous, current) =>
          previous.verifyOtpResponse != current.verifyOtpResponse,
      listener: (context, state) {
        if (state.verifyOtpResponse.hasSuccess) {
          globalReplaceUntil(
            route: Routes.signUp,
            arguments: widget.phoneNumber,
          );
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
                            backgroundColor: index == 1
                                ? AppColors.secColor
                                : AppColors.grey.withOpacity(0.3),
                          ).pd(EdgeInsets.symmetric(horizontal: 5.w)))),
              HelperFunc.sb(15.w)
            ]),
            Expanded(
                child: SingleChildScrollView(
                    child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Verify phone number',
                    style: AppTextStyles.mediumText(fontSize: 20)),
                HelperFunc.sb(10.h),
                BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                  return Text(
                          'We\'ve sent a 6 digit code to ${state.formData.phone.value ?? 'your phone number'}',
                          style: AppTextStyles.regularText(
                              fontSize: 13, color: AppColors.grey))
                      .pd(EdgeInsets.only(right: 50.w));
                }),
                HelperFunc.sb(25.h),
                BlocBuilder<SignupCubit, SignupState>(
                    builder: (context, state) {
                  return AppFormField(
                    hintText: '0 0 0 - 0 0 0',
                    inputFormatters: [
                      SeparatorFormatter(separator: '-', interval: 3),
                    ],
                    keyBoardType: TextInputType.number,
                    onChanged: (v) => context
                        .read<SignupCubit>()
                        .onOtpChanged(v.replaceAll('-', '')),
                    validator: (v) => state.formData.otp.error?.message,
                  );
                }),
                HelperFunc.sb(20.h),
                ValueListenableBuilder(
                    valueListenable: oneMin,
                    builder: (context, value, _) {
                      return RichText(
                          text: TextSpan(
                              text: 'We sent you a code. ',
                              style: AppTextStyles.regularText(
                                  fontSize: 11.5, color: AppColors.grey),
                              children: [
                            TextSpan(
                                text: 'Resend Code',
                                style: AppTextStyles.mediumText(
                                    fontSize: 11.5,
                                    color: value.inSeconds <= 0
                                        ? AppColors.materialColor
                                        : AppColors.grey),
                                recognizer: value.inSeconds <= 0
                                    ? (TapGestureRecognizer()
                                      ..onTap = (() => context
                                          .read<SignupCubit>()
                                          .resendOtp()
                                          .then((value) =>
                                              value ? setTimer() : null)))
                                    : null),
                            if (value.inSeconds > 0)
                              TextSpan(
                                  text: ' in ',
                                  style: AppTextStyles.regularText(
                                      color: AppColors.grey)),
                            if (value.inSeconds > 0)
                              TextSpan(
                                  text:
                                      '${value.inMinutes.toString().padLeft(2, '0')}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                  style: AppTextStyles.mediumText(
                                      fontSize: 11.5, color: Colors.black))
                          ]));
                    })
              ],
            ).pd(EdgeInsets.all(15.w)))),
            BlocBuilder<SignupCubit, SignupState>(builder: (context, state) {
              return AppButton(
                      btnText: 'Continue',
                      onTap: state.formData.canVerifyOtp
                          ? () => context.read<SignupCubit>().verifyPhone(
                                otp: state.formData.otp.value,
                                phone: widget.phoneNumber,
                              )
                          : null,
                      color: state.formData.canVerifyOtp
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
