import 'dart:async';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/separator.dart';
import 'package:xtridelink_driver/view/components/back_button.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../../../../cubit/auth/index.dart';

class VerifyMailPage extends StatefulWidget {
  final VerifyType verifyType;
  const VerifyMailPage({super.key, required this.verifyType});

  @override
  State<VerifyMailPage> createState() => _VerifyMailPageState();
}

class _VerifyMailPageState extends State<VerifyMailPage> {
  late ValueNotifier<bool> isFormValid;
  late TextEditingController otpController;
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
    isFormValid = ValueNotifier(false);
    otpController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    isFormValid.dispose();
    oneMin.dispose();
    timer?.cancel();
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
              Text(
                  widget.verifyType == VerifyType.signup
                      ? 'Verify Phone Number'
                      : 'Verify email address',
                  style: AppTextStyles.mediumText(fontSize: 20)),
              HelperFunc.sb(10.h),
              BlocBuilder<AuthCubit, AuthState>(builder: (context, state) {
                return Text(
                        'We\'ve sent a 6 digit code to ${widget.verifyType == VerifyType.signup ? (state.phoneNumber ?? 'your phone number') : (state.email ?? 'your email')}',
                        style: AppTextStyles.regularText(
                            fontSize: 13, color: AppColors.grey))
                    .pd(EdgeInsets.only(right: 50.w));
              }),
              HelperFunc.sb(25.h),
              AppFormField(
                  hintText: '0 0 0 - 0 0 0',
                  controller: otpController,
                  inputFormatters: [
                    SeparatorFormatter(separator: '-', interval: 3),
                  ],
                  keyBoardType: TextInputType.number,
                  onChanged: (v) =>
                      isFormValid.value = v.replaceAll('-', '').length == 6,
                  validator: (v) => null),
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
                              recognizer: TapGestureRecognizer()
                                ..onTap = (() => context
                                    .read<AuthCubit>()
                                    .resendOtp(widget.verifyType)
                                    .then(
                                        (value) => value ? setTimer() : null))),
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
          ).pd(EdgeInsets.all(15.w)))
              .EXPANDED,
          ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, bool value, _) {
                return AppButton(
                        btnText: 'Continue',
                        onTap: value
                            ? () => switch (widget.verifyType) {
                                  VerifyType.signup => context
                                      .read<AuthCubit>()
                                      .verifyOtp(
                                          verifyType: widget.verifyType,
                                          otp: otpController.text
                                              .replaceAll('-', '')),
                                  VerifyType.resetPwd => context
                                      .read<AuthCubit>()
                                      .savePasswordResetOtp(otpController.text
                                          .replaceAll('-', ''))
                                }
                            : null,
                        color: value ? null : AppColors.grey.withOpacity(.5))
                    .pd(EdgeInsets.fromLTRB(15.w, 0, 15.w, 15.h));
              }),
        ],
      )),
    );
  }
}
