import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/ui/dashboard/order/components/payment_options.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../../core/services/navigation/index.dart';
import 'components/location_track.dart';
import 'components/driver_contact_sheet.dart';
import 'components/order_details.dart';
import 'components/tracking_history.dart';
import 'components/header.dart';
import 'components/live_tracking.dart';
import '../../../../../../core/constants/colors.dart';
import '../../../../../../core/constants/helpers.dart';
import '../../../../../components/back_button.dart';

class OrderTimelinePage extends StatefulWidget {
  final String orderId;
  const OrderTimelinePage({super.key, required this.orderId});

  @override
  State<OrderTimelinePage> createState() => _OrderTimelinePageState();
}

class _OrderTimelinePageState extends State<OrderTimelinePage> {
  String? riderId;

  @override
  void deactivate() {
    context.read<OrdersCubit>().setLiveTracking(false);
    // getIt<SocketService>().offEvent('riderLocation-$riderId');
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ashBg,
      body: SafeArea(
        child: BlocBuilder<OrdersCubit, OrdersState>(
            buildWhen: (previous, current) => previous.orders != current.orders,
            builder: (context, state) {
              riderId = state.trackingOrder.data?.riderDetails?.id;
              OrderDetails order = OrderDetails();
              if (state.orders.hasSuccess) {
                order = (state.orders.data ?? []).firstWhere(
                    (element) => element.trackingId == widget.orderId,
                    orElse: () {
                  globalPop();
                  return OrderDetails();
                });
                riderId = order.riderDetails?.id;
              }
              bool inProgress() => order.status?.toUpperCase() == 'IN_TRANSIT';

              if (order.id == null) {
                return Container();
              }

              if (order.paymentMethod == null) {
                HelperFunc.showFittedBottomSheet(
                    isDismissible: false,
                    showBackButton: false,
                    context: buildContext,
                    child: const PaymentOptionsSheet());
              }
              return Stack(
                children: [
                  state.liveTracking
                      ? OrderTimelineLiveTracking(order: order)
                      : SafeArea(
                          bottom: false,
                          child: Column(
                            children: [
                              Row(children: [
                                const AppBackButton(),
                                const Spacer(),
                                IconButton(
                                    onPressed: () => HelperFunc.showFittedPopUp(
                                        context: context,
                                        alignment: const Alignment(.8, -.9),
                                        padding: EdgeInsets.symmetric(
                                            vertical: 10.h, horizontal: 12.w),
                                        child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              TextButton(
                                                  onPressed: () =>
                                                      globalNavigateTo(
                                                          route:
                                                              Routes.support),
                                                  child: Text('Contact Support',
                                                      style: AppTextStyles
                                                          .mediumText(
                                                              color: Colors
                                                                  .black))),
                                              if (inProgress())
                                                Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      AppButton(
                                                          btnText:
                                                              'Report An Issue',
                                                          padding: EdgeInsets
                                                              .symmetric(
                                                                  vertical:
                                                                      10.h,
                                                                  horizontal:
                                                                      15.w),
                                                          color: AppColors
                                                              .materialColor
                                                              .withOpacity(.15),
                                                          txtColor: AppColors
                                                              .materialColor,
                                                          isPadding: true)
                                                    ])
                                            ])),
                                    icon: const Icon(Icons.more_vert))
                              ]),
                              Expanded(
                                  child: RefreshIndicator(
                                onRefresh: () async =>
                                    context.read<OrdersCubit>().getOrders(),
                                child: SingleChildScrollView(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 20.w),
                                    child: Column(children: [
                                      OrderTimelineHeader(order: order),
                                      if (inProgress()) HelperFunc.sb(15.h),
                                      if (inProgress())
                                        OrderTimelineLiveTracking(order: order),
                                      HelperFunc.sb(15.h),
                                      inProgress()
                                          ? OrderTimelineTrackingHistory(
                                              order: order)
                                          : OrderTimelineLocationTrack(
                                              order: order),
                                      HelperFunc.sb(25.h),
                                      OrderTimelineDetails(order: order),
                                      HelperFunc.sb(
                                          MediaQuery.of(context).size.height *
                                              .5),
                                    ])),
                              )),
                            ],
                          )),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: order.paymentCompletedAt != null
                        ? OrderTimelineDriverContactSheet(
                            inProgress: inProgress(),
                            order: order,
                          )
                        : AppButton(
                                onTap: () {
                                  context
                                      .read<OrdersCubit>()
                                      .resumePendingOrder(order);
                                  HelperFunc.showFittedBottomSheet(
                                      isDismissible: false,
                                      showBackButton: false,
                                      context: buildContext,
                                      child: const PaymentOptionsSheet());
                                },
                                btnText: 'Proceed to payment')
                            .pd(
                            EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 24.w),
                          ),
                  )
                ],
              );
            }),
      ),
    );
  }
}
