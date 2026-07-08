import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/domain/model/api/ongoing_orders.dart';
import 'package:xtridelink_driver/core/services/location/index.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/di/get_it.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/order/ongoing_timer.dart';
import 'cannot_reach_customer.dart';
import 'provide_two_fa.dart';

class OrderCardButtons extends StatelessWidget {
  final OrderDetails orderDetails;
  final int index;
  const OrderCardButtons(
      {super.key, required this.index, required this.orderDetails});

  @override
  Widget build(BuildContext context) {
    return switch (orderDetails.status) {
      'payment_confirmed' => Column(children: [
          AppButton(
              onTap: () async {
                context.read<OrderFlowCubit>().updateOrderStatus(
                    trackingId: orderDetails.trackingId!,
                    status: 'pickup_ready');
              },
              btnText: 'Ready to Pick package')
        ]),
      'pickup_ready' => AppButton(
          onTap: () => context.read<OrderFlowCubit>().updateOrderStatus(
              trackingId: orderDetails.trackingId!, status: 'in_transit'),
          btnText: 'Package picked up'),
      'in_transit' => AppButton(
          onTap: () => context.read<OrderFlowCubit>().updateOrderStatus(
              trackingId: orderDetails.trackingId!, status: 'delivered'),
          btnText: 'I’ve delivered to the customer'),
      'delivered' => Column(
          children: [
            AppButton(
                onTap: () async {
                  bool success = true;
                  // await context
                  //     .read<OngoingTimerCubit>()
                  //     .setTimer(orderDetails.trackingId!);
                  if (success && context.mounted) {
                    HelperFunc.showFittedBottomSheet(
                        context: context,
                        child: Provide2FASheet(
                            orderId: orderDetails.trackingId!,
                            resendOtp: () => context
                                .read<OngoingTimerCubit>()
                                .setTimer(orderDetails.trackingId!),
                            senderPhoneNo: orderDetails.recipientPhone!,
                            onSubmit: (code) async {
                              bool success = await context
                                  .read<OrderFlowCubit>()
                                  .completeOrder(
                                    trackingId: orderDetails.trackingId!,
                                    deliveryCode: code,
                                  );
                              if (success && context.mounted) {
                                HelperFunc.toast('Order completed');
                                globalPop();
                              }
                            }));
                  }
                },
                btnText: 'Complete Order'),
            HelperFunc.sb(7.h),
            // CantReachTimerButton(orderId: orderDetails.id!)
          ],
        ),
      _ => SizedBox(),
    };
  }
}
