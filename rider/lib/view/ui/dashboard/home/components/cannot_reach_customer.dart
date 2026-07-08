import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';

class CantReachTimerButton extends StatefulWidget {
  final String orderId;
  const CantReachTimerButton({super.key, required this.orderId});

  @override
  State<CantReachTimerButton> createState() => _CantReachTimerButtonState();
}

class _CantReachTimerButtonState extends State<CantReachTimerButton> {
  late ValueNotifier<Duration> oneMin;
  Timer? timer;

  void setTimer() {
    oneMin.value = const Duration(minutes: 5);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      oneMin.value = Duration(seconds: oneMin.value.inSeconds - 1);
      if (oneMin.value.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    oneMin = ValueNotifier(const Duration());
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    oneMin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: oneMin,
        builder: (context, value, _) {
          return AppButton(
              onTap: () async {
                bool success = await context
                    .read<OrderFlowCubit>()
                    .userUnreachable(orderId: widget.orderId);
                if (success && mounted) {
                  HelperFunc.showFittedBottomSheet(
                      context: context,
                      child: Column(children: [
                        CircleAvatar(
                            backgroundColor: AppColors.lightPri,
                            radius: 55.r,
                            child: SvgPicture.asset(Assets.bell)),
                        HelperFunc.sb(25.h),
                        Text(
                            'Please wait for 5 minutes\nwhile we inform the\nsender',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.semiBold(fontSize: 22)),
                        HelperFunc.sb(50.h),
                        SafeArea(
                            child: AppButton(
                                onTap: () {
                                  globalPop();
                                  setTimer();
                                },
                                color: Colors.black,
                                btnText: 'Ok, i will wait'))
                      ]).pd(EdgeInsets.symmetric(
                          horizontal: 20.w, vertical: 5.h)));
                }
              },
              color: value.inSeconds > 0
                  ? AppColors.grey.withOpacity(.5)
                  : Colors.black,
              btnText:
                  'I can’t reach customer${value.inSeconds > 0 ? ' (${value.inMinutes}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')})' : ''}');
        });
  }
}
