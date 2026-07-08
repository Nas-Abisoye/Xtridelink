import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/cubit/order/ongoing_timer.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/separator.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';

class Provide2FASheet extends StatefulWidget {
  final void Function(String code) onSubmit;
  final void Function() resendOtp;
  final String senderPhoneNo, orderId;
  const Provide2FASheet(
      {super.key,
      required this.onSubmit,
      required this.senderPhoneNo,
      required this.resendOtp,
      required this.orderId});

  @override
  State<Provide2FASheet> createState() => _Provide2FASheetState();
}

class _Provide2FASheetState extends State<Provide2FASheet> {
  late ValueNotifier<bool> isFormValid;
  late FocusNode focusNode;
  late TextEditingController otpController;

  @override
  void initState() {
    isFormValid = ValueNotifier(false);
    focusNode = FocusNode();
    otpController = TextEditingController();
    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    otpController.dispose();
    focusNode.dispose();
    isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Provide 2FA delivery code',
            style: AppTextStyles.mediumText(fontSize: 20)),
        HelperFunc.sb(5.h),
        Text('Enter the code provided by the customer',
                style: AppTextStyles.regularText(
                    fontSize: 13, color: AppColors.grey))
            .pd(EdgeInsets.only(right: 50.w)),
        HelperFunc.sb(30.h),
        AppFormField(
            hintText: '0 0 0 - 0 0 0',
            controller: otpController,
            focusNode: focusNode,
            inputFormatters: [
              SeparatorFormatter(separator: '-', interval: 3),
            ],
            keyBoardType: TextInputType.number,
            onChanged: (v) =>
                isFormValid.value = v.replaceAll('-', '').length == 6,
            validator: (v) => null),
        // HelperFunc.sb(10.h),
        // BlocBuilder<OngoingTimerCubit, OngoingTimerState>(
        //     builder: (context, state) {
        //   final duration =
        //       state.timers[widget.orderId] ?? const Duration(minutes: 0);
        //   return RichText(
        //       text: TextSpan(
        //           text: 'We sent you a code. ',
        //           style: AppTextStyles.regularText(
        //               fontSize: 11, color: AppColors.grey),
        //           children: [
        //         TextSpan(
        //             text: 'Resend Code',
        //             style: AppTextStyles.mediumText(
        //                 fontSize: 11,
        //                 color: duration.inSeconds <= 0
        //                     ? AppColors.materialColor
        //                     : AppColors.grey),
        //             recognizer: duration.inSeconds <= 0
        //                 ? (TapGestureRecognizer()..onTap = (widget.resendOtp))
        //                 : null),
        //         if (duration.inSeconds > 0)
        //           TextSpan(
        //               text: ' in ',
        //               style: AppTextStyles.regularText(color: AppColors.grey)),
        //         if (duration.inSeconds > 0)
        //           TextSpan(
        //               text:
        //                   '${duration.inMinutes.toString().padLeft(2, '0')}:${duration.inSeconds.remainder(60).toString().padLeft(2, '0')}',
        //               style: AppTextStyles.mediumText(
        //                   fontSize: 11.5, color: Colors.black))
        //       ]));
        // }),
        HelperFunc.sb(10.h),
        RichText(
            text: TextSpan(
                text: 'Haven’t gotten the code?',
                style: AppTextStyles.regularText(
                    fontSize: 11, color: Colors.black),
                children: [
              TextSpan(
                  text: ' Call sender ',
                  style: AppTextStyles.mediumText(
                      fontSize: 11, color: AppColors.materialColor),
                  recognizer: TapGestureRecognizer()
                    ..onTap =
                        (() => HelperFunc.makePhoneCall(widget.senderPhoneNo))),
            ])),
        HelperFunc.sb(70.h),
        ValueListenableBuilder(
            valueListenable: isFormValid,
            builder: (context, bool value, _) {
              return SafeArea(
                top: false,
                child: AppButton(
                    btnText: 'Submit',
                    onTap: value
                        ? () => widget
                            .onSubmit(otpController.text.replaceAll('-', ''))
                        : null,
                    color: value ? null : AppColors.grey.withOpacity(.5)),
              );
            }),
        SizedBox(height: focusNode.hasFocus ? 200.h : 0)
      ],
    ).pd(EdgeInsets.fromLTRB(20.w, 0, 20.w, 10.h));
  }
}
