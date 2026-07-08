import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';

class ConfirmPaymentPage extends StatefulWidget {
  const ConfirmPaymentPage({super.key});

  @override
  State<ConfirmPaymentPage> createState() => _ConfirmPaymentPageState();
}

class _ConfirmPaymentPageState extends State<ConfirmPaymentPage> {
  late ValueNotifier<Duration> oneMin;
  Timer? timer;

  void setTimer() {
    oneMin = ValueNotifier(const Duration(minutes: 20));
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      oneMin.value = Duration(seconds: oneMin.value.inSeconds - 1);
      if (oneMin.value.inSeconds == 1190) {
        globalPop();
        globalReplaceWith(route: Routes.orderPlacedSuccess);
      }
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
    timer?.cancel();
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
                  padding: EdgeInsets.all(20.w),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Confirm payment',
                            style: AppTextStyles.mediumText(fontSize: 20)),
                        Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * .5,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          margin: EdgeInsets.symmetric(vertical: 40.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.grey.withOpacity(.2)),
                              borderRadius: BorderRadius.circular(20.r)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconAvatar(
                                      avatar: Assets.price,
                                      color: Colors.white,
                                      iconSize: 16.w,
                                      circleColor: AppColors.materialColor,
                                      radius: 26.r),
                                  HelperFunc.sb(10.w),
                                  ...List.generate(
                                      8,
                                      (index) => SizedBox(
                                              width: 3.w,
                                              child: const Divider(
                                                  color:
                                                      AppColors.materialColor,
                                                  thickness: 1.5))
                                          .pd(EdgeInsets.symmetric(
                                              horizontal: 5.w))),
                                  HelperFunc.sb(10.w),
                                  CircleAvatar(
                                      backgroundColor: AppColors.materialColor,
                                      radius: 26.r,
                                      child: Icon(Icons.check_circle,
                                          color: Colors.white, size: 20.h))
                                ],
                              ),
                              HelperFunc.sb(20.h),
                              ValueListenableBuilder(
                                  valueListenable: oneMin,
                                  builder: (context, value, _) {
                                    return RichText(
                                            textAlign: TextAlign.center,
                                            text: TextSpan(
                                                text:
                                                    'We are processing your transaction at the moment. You will be notified in the next ',
                                                style:
                                                    AppTextStyles.regularText(
                                                        fontSize: 15,
                                                        color: Colors.black),
                                                children: [
                                                  TextSpan(
                                                      text:
                                                          '${value.inMinutes.toString().padLeft(2, '0')}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                                      style: AppTextStyles
                                                          .semiBold(
                                                              fontSize: 15))
                                                ]))
                                        .pd(EdgeInsets.symmetric(
                                            horizontal: 30.w));
                                  }),
                              HelperFunc.sb(10.h),
                            ],
                          ),
                        )
                      ]))),
        ],
      )),
    );
  }
}
