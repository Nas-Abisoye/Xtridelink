import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/domain/model/api/riders.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/awaiting_driver_accept.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';
import '../../../../components/form_field.dart';
import '../../../../components/loader.dart';
import '../pages/select_driver.dart';

class NegotiatePriceSheet extends StatefulWidget {
  final RiderData rider;
  const NegotiatePriceSheet({super.key, required this.rider});

  @override
  State<NegotiatePriceSheet> createState() => _NegotiatePriceSheetState();
}

class _NegotiatePriceSheetState extends State<NegotiatePriceSheet> {
  late FocusNode focusNode;
  late TextEditingController amountController;

  @override
  void initState() {
    focusNode = FocusNode();
    amountController = TextEditingController();

    focusNode.addListener(() => setState(() {}));
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final negotiatingOrder = context.read<OrdersCubit>().state.negotiatingOrder;
    final basePrice = double.parse(negotiatingOrder?.basePrice ?? '0.0');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          HelperFunc.sb(10.h),
          Text('Negotiate Offer', style: AppTextStyles.semiBold()),
          HelperFunc.sb(10.h),
          Text('Enter a price that suites you',
              style: AppTextStyles.regularText(color: AppColors.grey)),
          HelperFunc.sb(25.h),
          SelectDriverCard(isSelected: true, rider: widget.rider),
        ]).pd(EdgeInsets.symmetric(horizontal: 15.w)),
        HelperFunc.sb(10.h),
        Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            decoration: BoxDecoration(
                color: AppColors.ashBg,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(40.r))),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HelperFunc.sb(20.h),
                Text('Enter Suitable Price',
                        style: AppTextStyles.mediumText(fontSize: 12))
                    .pd(EdgeInsets.symmetric(horizontal: 20.w)),
                HelperFunc.sb(20.h),
                AppFormField(
                    hintText: 'Amount',
                    controller: amountController,
                    focusNode: focusNode,
                    keyBoardType: TextInputType.number,
                    validator: (v) {
                      num amount =
                          num.tryParse(v?.replaceAll(',', '') ?? '') ?? 0;
                      if (amount == 0) {
                        return 'Not a valid amount';
                      }
                      if (amount <
                          (double.parse(widget.rider.proposedPrice!) *
                              (100 - basePrice) /
                              100)) {
                        return 'Amount cannot be less than ${(double.parse(widget.rider.proposedPrice!) * (100 - basePrice) / 100).formatCurrency}';
                      }
                      // if (amount >
                      //     (widget.rider.amount *
                      //         widget.rider.negotiationUpperLimit /
                      //         100)) {
                      //   return 'Amount cannot be greater than ${(widget.rider.amount * widget.rider.negotiationUpperLimit / 100).formatCurrency}';
                      // }
                      return null;
                    }),
                HelperFunc.sb(50.h),
                SafeArea(
                    child: Row(children: [
                  HelperFunc.sb(5.w),
                  Expanded(
                      child: AppButton(
                          onTap: () => globalPop(),
                          color: Colors.black,
                          btnText: 'Select Other Driver')),
                  HelperFunc.sb(10.w),
                  Expanded(
                      child: ValueListenableBuilder(
                          valueListenable: amountController,
                          builder: (context, value, _) {
                            bool isFormValid =
                                (num.tryParse(value.text.replaceAll(',', '')) ??
                                        0) >=
                                    (double.parse(widget.rider.proposedPrice!) *
                                        (100 - basePrice) /
                                        100);
                            return AppButton(
                                color: isFormValid
                                    ? null
                                    : AppColors.grey.withOpacity(.5),
                                onTap: isFormValid
                                    ? () {
                                        globalPop();
                                        globalNavigateTo(
                                            route: Routes.awaitingDriverAccept,
                                            arguments: CreateOfferReqData(
                                                amount: num.tryParse(value.text
                                                        .replaceAll(',', '')) ??
                                                    0,
                                                bidId: widget.rider.bidId!));
                                      }
                                    : null,
                                btnText: 'Send Offer');
                          })),
                  HelperFunc.sb(5.w)
                ])),
                SizedBox(height: focusNode.hasFocus ? 200.h : 0)
              ],
            ))
      ],
    );
  }
}

class SendNegotiatedOfferLoader extends StatelessWidget {
  final void Function() onTimerCompleted;
  final Future<void> Function() awaitFunction;
  const SendNegotiatedOfferLoader(
      {super.key, required this.onTimerCompleted, required this.awaitFunction});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Column(children: [
          HelperFunc.sb(10.h),
          SizedBox(
              height: 120.h,
              width: 120.w,
              child: CarLoader(
                  awaitFunction: awaitFunction,
                  height: 50,
                  increment: 15,
                  onTimerCompleted: onTimerCompleted)),
          HelperFunc.sb(5.h),
          Text('Waiting for driver',
              style: AppTextStyles.semiBold(fontSize: 18)),
          HelperFunc.sb(10.h),
          Text('Your price has been sent to the driver. While we wait you can start packing your parcel.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.regularText(color: AppColors.grey))
              .pd(EdgeInsets.symmetric(horizontal: 30.w)),
          HelperFunc.sb(30.h)
        ]));
  }
}
