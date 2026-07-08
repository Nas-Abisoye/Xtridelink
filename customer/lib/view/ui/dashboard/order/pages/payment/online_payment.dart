import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/data/source/remote/model/order/payment_account_response/data.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../../core/constants/text_styles.dart';
import '../../../../../components/back_button.dart';
import '../../../../../components/button.dart';

class OnlinePaymentPage extends StatefulWidget {
  final PaymentAccount bank;
  const OnlinePaymentPage({super.key, required this.bank});

  @override
  State<OnlinePaymentPage> createState() => _OnlinePaymentPageState();
}

class _OnlinePaymentPageState extends State<OnlinePaymentPage> {
  late ValueNotifier<Duration> oneMin;
  Timer? timer;

  void setTimer() {
    oneMin.value = const Duration(minutes: 20);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      oneMin.value = Duration(seconds: oneMin.value.inSeconds - 1);
      if (oneMin.value.inSeconds <= 0) {
        timer.cancel();
      }
    });
  }

  @override
  void initState() {
    oneMin = ValueNotifier(const Duration(minutes: 0));
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
                        Text('Online payment',
                            style: AppTextStyles.mediumText(fontSize: 20)),
                        HelperFunc.sb(10.h),
                        Text('To complete order, you have to deposit total balance to the given account number',
                                style: AppTextStyles.regularText(
                                    fontSize: 13, color: AppColors.grey))
                            .pd(EdgeInsets.only(right: 50.w)),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                              horizontal: 15.w, vertical: 20.h),
                          margin: EdgeInsets.symmetric(vertical: 40.w),
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.grey.withOpacity(.2)),
                              borderRadius: BorderRadius.circular(20.r)),
                          child: Column(
                            children: [
                              Row(children: [
                                Text('Bank Name',
                                    style: AppTextStyles.mediumText(
                                        fontSize: 14,
                                        color: AppColors.grey.withOpacity(.8))),
                                HelperFunc.sb(5.w),
                                Text(widget.bank.bankName ?? 'N/A',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.mediumText(
                                            fontSize: 14,
                                            color: AppColors.grey))
                                    .EXPANDED,
                                HelperFunc.sb(10.w),
                                GestureDetector(
                                    onTap: () => HelperFunc.copyToClipboard(
                                        widget.bank.bankName ?? ''),
                                    child: SvgPicture.asset(Assets.copy,
                                        height: 16.h))
                              ]).pd(EdgeInsets.symmetric(vertical: 20.h)),
                              Row(children: [
                                Text('Account Name',
                                    style: AppTextStyles.mediumText(
                                        fontSize: 14,
                                        color: AppColors.grey.withOpacity(.8))),
                                HelperFunc.sb(5.w),
                                Text(widget.bank.accountName ?? 'N/A',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.mediumText(
                                            fontSize: 14,
                                            color: AppColors.grey))
                                    .EXPANDED,
                                HelperFunc.sb(10.w),
                                GestureDetector(
                                    onTap: () => HelperFunc.copyToClipboard(
                                        widget.bank.accountName ?? ''),
                                    child: SvgPicture.asset(Assets.copy,
                                        height: 16.h))
                              ]).pd(EdgeInsets.symmetric(vertical: 20.h)),
                              Row(children: [
                                Text('Account Number',
                                    style: AppTextStyles.mediumText(
                                        fontSize: 14,
                                        color: AppColors.grey.withOpacity(.8))),
                                HelperFunc.sb(5.w),
                                Text(widget.bank.accountNumber ?? 'N/A',
                                        textAlign: TextAlign.end,
                                        style: AppTextStyles.mediumText(
                                            fontSize: 14,
                                            color: AppColors.grey))
                                    .EXPANDED,
                                HelperFunc.sb(10.w),
                                GestureDetector(
                                    onTap: () =>
                                        widget.bank.accountNumber != null
                                            ? HelperFunc.copyToClipboard(
                                                widget.bank.accountNumber!)
                                            : null,
                                    child: SvgPicture.asset(Assets.copy,
                                        height: 16.h))
                              ]).pd(EdgeInsets.symmetric(vertical: 20.h)),
                              Row(children: [
                                Text('Amount',
                                    style: AppTextStyles.mediumText(
                                        fontSize: 14,
                                        color: AppColors.grey.withOpacity(.8))),
                                HelperFunc.sb(5.w),
                                Text(((widget.bank.amount) ?? 0).formatCurrency,
                                        textAlign: TextAlign.end,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.grey))
                                    .EXPANDED,
                                HelperFunc.sb(10.w),
                                GestureDetector(
                                    onTap: () => HelperFunc.copyToClipboard(
                                        ((widget.bank.amount) ?? 0).toString()),
                                    child: SvgPicture.asset(Assets.copy,
                                        height: 16.h))
                              ]).pd(EdgeInsets.symmetric(vertical: 20.h)),
                              Divider(
                                  height: 20.h,
                                  color: AppColors.grey.withOpacity(.4)),
                              HelperFunc.sb(20.h),
                              RichText(
                                  text: TextSpan(
                                      text: 'NB. ',
                                      style: AppTextStyles.mediumText(
                                          fontSize: 12,
                                          color: AppColors.materialColor),
                                      children: [
                                    TextSpan(
                                        text:
                                            'Send the exact amount stated above. Any amount below it will be reversed and order will not be completed.',
                                        style: AppTextStyles.regularText(
                                            fontSize: 12,
                                            color: AppColors.grey))
                                  ])),
                              HelperFunc.sb(10.h),
                            ],
                          ),
                        )
                      ]))),
          // AppButton(
          //   // onTap: () => globalNavigateTo(route: Routes.confirmPayment),
          //   onTap: () => context
          //       .read<OrdersCubit>()
          //       .verifyPayment(reference: widget.bank.metadata.reference),
          //   btnText: 'I’ve sent the money',
          // ).pd(EdgeInsets.symmetric(horizontal: 15.w)),
          ValueListenableBuilder(
                  valueListenable: oneMin,
                  builder: (context, value, _) {
                    return value.inSeconds <= 0
                        ? AppButton(
                            // onTap: () => globalNavigateTo(route: Routes.confirmPayment),
                            onTap: () {
                              context.read<OrdersCubit>().checkPaymentStatus();
                            },
                            btnText: 'I’ve sent the money',
                          )
                        : Column(
                            children: [
                              Text(
                                  'Please wait while we verify your payment${List.generate(4 - (value.inSeconds % 4), (index) => '.').join()}',
                                  textAlign: TextAlign.center,
                                  style:
                                      AppTextStyles.regularText(fontSize: 13)),
                              HelperFunc.sb(10.h),
                              Text(
                                  '${value.inMinutes.toString().padLeft(2, '0')}:${value.inSeconds.remainder(60).toString().padLeft(2, '0')}',
                                  textAlign: TextAlign.center,
                                  style: AppTextStyles.semiBold(fontSize: 15)),
                              HelperFunc.sb(20.h),
                            ],
                          );
                  })
              .pd(EdgeInsets.symmetric(horizontal: 15.w))
              .align(Alignment.center),
          // TextButton(
          //         onPressed: () {
          //           // context.read<OrdersCubit>().updatePayment(
          //           //     onSuccess: () {
          //           //       globalPop();
          //           //       globalNavigateTo(route: Routes.orderPlacedSuccess);
          //           //     },
          //           //     paymentMethod: 'CASH');
          //         },
          //         child: SizedBox(
          //             width: double.infinity,
          //             child: Text('Switch to Cash Payment',
          //                 textAlign: TextAlign.center,
          //                 style:
          //                     AppTextStyles.mediumText(color: Colors.black))))
          //     .pd(EdgeInsets.fromLTRB(15.w, 15.h, 15.w, 0)),
          // TextButton(
          //         onPressed: () => globalPop(),
          //         child: SizedBox(
          //             width: double.infinity,
          //             child: Text('Cancel',
          //                 textAlign: TextAlign.center,
          //                 style:
          //                     AppTextStyles.mediumText(color: Colors.black))))
          //     .pd(EdgeInsets.fromLTRB(15.w, 0.h, 15.w, 0)),
          HelperFunc.sb(15.h)
        ],
      )),
    );
  }
}
