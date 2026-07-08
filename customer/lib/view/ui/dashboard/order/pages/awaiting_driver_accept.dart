import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/socket/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../../../injector.dart';
import 'package:xtridelink/view/components/loader.dart';
import 'package:xtridelink/view/ui/dashboard/order/components/cancel_order.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/button.dart';

class CreateOfferReqData {
  final num amount;
  final String bidId;
  CreateOfferReqData({required this.amount, required this.bidId});
}

class AwaitingDriverAcceptPage extends StatefulWidget {
  final CreateOfferReqData createOfferReqData;
  const AwaitingDriverAcceptPage({super.key, required this.createOfferReqData});

  @override
  State<AwaitingDriverAcceptPage> createState() =>
      _AwaitingDriverAcceptPageState();
}

class _AwaitingDriverAcceptPageState extends State<AwaitingDriverAcceptPage> {
  @override
  void initState() {
    super.initState();
    getIt<SocketService>().selectRider(widget.createOfferReqData.bidId);
  }

  @override
  void deactivate() {
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      // const AppBackButton(),
      Expanded(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        SizedBox(
            height: 300.h,
            width: double.infinity,
            child: BlocBuilder<OrdersCubit, OrdersState>(
                builder: (context, state) {
              return CarLoader(
                  awaitFunction: () {
                    return context.read<OrdersCubit>().createOffer(
                          amount: widget.createOfferReqData.amount,
                        );
                  },
                  height: 100,
                  increment: 40,
                  onTimerCompleted: () {
                    // getIt<SocketService>()
                    //     .socket
                    //     .on('offerAccepted-${state.orderDet?.userId}', (data) {
                    //   HelperFunc.logger('offerAccepted: ${jsonEncode(data)}');
                    //   getIt<SocketService>()
                    //       .offEvent('offerAccepted-${state.orderDet?.userId}');
                    //   OfferAcceptedCheckData offer =
                    //       OfferAcceptedCheckData.fromJson(data);
                    //   if (offer.data.offer.status.toLowerCase() == 'accepted') {
                    //     buildContext.read<OrdersCubit>().setTrackingData(
                    //         trackingData: offer.data.orderTracking);
                    //     globalReplaceWith(route: Routes.offerPlacedAccepted);
                    //   } else {
                    //     globalReplaceWith(route: Routes.offerPlacedRejected);
                    //   }
                    // });
                  });
            })),
        Text('Waiting for driver', style: AppTextStyles.semiBold(fontSize: 25)),
        HelperFunc.sb(10.h),
        Text(
            'You order has been sent to driver. Now we wait for trip to be accepted. Ensure that recipient is available',
            textAlign: TextAlign.center,
            style:
                AppTextStyles.regularText(color: AppColors.grey, fontSize: 15))
      ]).pd(EdgeInsets.symmetric(horizontal: 40.w))),
      HelperFunc.sb(80.h),
      AppButton(
              btnText: 'Cancel Order',
              onTap: () => HelperFunc.showFittedBottomSheet(
                  context: context, child: const CancelOrderSheet()))
          .pd(EdgeInsets.symmetric(horizontal: 20.w)),
      HelperFunc.sb(10.h)
    ])));
  }
}
