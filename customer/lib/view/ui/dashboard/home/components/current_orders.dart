import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
// import 'package:xtridelink/domain/model/api/order_det.dart';
import 'package:xtridelink/view/components/tag.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';

import '../../../../../core/services/navigation/index.dart';
import '../../../../../core/services/navigation/routes.dart';

class HomeCurrentOrders extends StatelessWidget {
  const HomeCurrentOrders({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
      return Column(
        children: [
          Row(children: [
            HelperFunc.sb(20.w),
            Text('Current Orders', style: AppTextStyles.semiBold(fontSize: 15))
                .pd(EdgeInsets.symmetric(vertical: 10.h)),
            const Spacer(),
            // TextButton(
            //     onPressed: () {},
            //     child: Text('See All',
            //         style: AppTextStyles.regularText()
            //             .copyWith(decoration: TextDecoration.underline))),
            HelperFunc.sb(20.w),
          ]),
          if (((state.orders.data ?? []).where((element) =>
              element.status!.toLowerCase() != 'cancelled' &&
              element.status!.toLowerCase() != 'completed' &&
              element.status!.toLowerCase() != 'delivered' &&
              element.trackingId != null)).isEmpty)
            Container(
              padding: EdgeInsets.symmetric(vertical: 50.h, horizontal: 15.w),
              margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.01),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 0)),
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 10,
                        offset: const Offset(0, 0))
                  ],
                  borderRadius: BorderRadius.circular(20.r)),
              child: Column(
                children: [
                  Image.asset(Assets.empty, height: 70.h),
                  HelperFunc.sb(10.h),
                  Text('No new orders',
                      style: AppTextStyles.semiBold(
                          fontSize: 14, color: AppColors.grey.withOpacity(.7))),
                  HelperFunc.sb(5.h),
                  Text('You currently don’t have any shipment enroute',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regularText(
                          fontSize: 10, color: AppColors.grey.withOpacity(.5))),
                ],
              ),
            ),
          ...(state.orders.data ?? [])
              .where((element) =>
                  element.status!.toLowerCase() != 'cancelled' &&
                  element.status!.toLowerCase() != 'delivered' &&
                  element.status!.toLowerCase() != 'completed' &&
                  element.trackingId != null)
              .map((e) => CurrentOrderCard(order: e)),
          // const CurrentOrderCard(),
        ],
      );
    });
  }
}

class CurrentOrderCard extends StatelessWidget {
  final OrderDetails order;
  const CurrentOrderCard({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(order.status);
        switch (order.status) {
          case 'pending':
          case 'searching_driver':
          case 'selecting_rider':
          case 'collecting_bids':
            globalNavigateTo(route: Routes.selectDriver);
            context.read<OrdersCubit>().resumePendingOrder(order);
            context.read<OrdersCubit>().researchRiders();
            break;
          case 'payment_pending':
            globalNavigateTo(
                route: Routes.timeline, arguments: order.trackingId);
            break;
          default:
            if (order.isPaymentCompleted ?? false) {
              globalNavigateTo(
                  route: Routes.timeline, arguments: order.trackingId);
            }
        }
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 5.h),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.01),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0)),
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(20.r)),
        child: Column(
          children: [
            Row(children: [
              CircleAvatar(
                  radius: 21.r,
                  backgroundColor: PackageType.general.color,
                  child: SvgPicture.asset(PackageType.general.asset)),
              HelperFunc.sb(8.w),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order.id!.toOrderIdTag(),
                    style: AppTextStyles.semiBold(fontSize: 15)),
                HelperFunc.sb(2.h),
                if (order.trackingId != null)
                  GestureDetector(
                    onTap: () => HelperFunc.copyToClipboard(
                        order.trackingId ?? '',
                        toastMsg: 'Copied Tracking ID'),
                    child: Text('Tracking ID: ${order.trackingId}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regularText(
                            color: AppColors.grey, fontSize: 11.5)),
                  ),
                HelperFunc.sb(1.5.h),
                // if (order.otp.isNotEmpty)
                //   Text('Delivery OTP: ${order.otp}',
                //       maxLines: 1,
                //       overflow: TextOverflow.ellipsis,
                //       style: AppTextStyles.regularText(
                //           color: AppColors.grey, fontSize: 12))
              ]).EXPANDED,
              Tag(
                  txt: order.status?.toUpperCase() == 'CANCELLED'
                      ? 'Cancelled'
                      : (order.status?.toUpperCase() == 'PAYMENT_PENDING' &&
                              order.trackingId != null)
                          ? 'Awaiting payment'
                          : order.status?.toUpperCase() == 'COMPLETED' ||
                                  order.status?.toUpperCase() == 'DELIVERED'
                              ? 'Delivered'
                              : order.status?.toUpperCase() == 'IN_TRANSIT'
                                  ? 'On Transit'
                                  : order.status?.toUpperCase() ==
                                          'PICKUP_READY'
                                      ? 'Awaiting Pickup'
                                      : order.status?.toUpperCase() ==
                                              'PAYMENT_CONFIRMED'
                                          ? 'Ready'
                                          : 'Pending',
                  txtColor: order.status?.toUpperCase() == 'CANCELLED'
                      ? AppColors.red
                      : (order.status?.toUpperCase() == 'PAYMENT_PENDING' &&
                              order.trackingId != null)
                          ? AppColors.grey
                          : order.status?.toUpperCase() == 'COMPLETED' ||
                                  order.status?.toUpperCase() == 'DELIVERED'
                              ? AppColors.green
                              : order.status?.toUpperCase() == 'IN_TRANSIT'
                                  ? AppColors.secColor
                                  : order.status?.toUpperCase() ==
                                          'PICKUP_READY'
                                      ? AppColors.secColor
                                      : order.status?.toUpperCase() ==
                                              'PAYMENT_CONFIRMED'
                                          ? AppColors.materialColor
                                          : AppColors.dullYellow)
            ]),
            HelperFunc.sb(25.h),
            Row(children: [
              SvgPicture.asset(Assets.doubleCircle),
              HelperFunc.sb(10.h),
              ...List.generate(
                  4,
                  (index) => Divider(
                          color: index <
                                  (order.status?.toUpperCase() == 'COMPLETED' ||
                                          order.status?.toUpperCase() ==
                                              'DELIVERED'
                                      ? 4
                                      : order.status?.toUpperCase() ==
                                              'IN_TRANSIT'
                                          ? 3
                                          : order.status?.toUpperCase() ==
                                                  'PICKUP_READY'
                                              ? 2
                                              : order.status?.toUpperCase() ==
                                                      'PAYMENT_CONFIRMED'
                                                  ? 1
                                                  : 0)
                              ? AppColors.materialColor
                              : AppColors.grey.withOpacity(0.2),
                          thickness: 2)
                      .pd(EdgeInsets.symmetric(horizontal: 3.w))
                      .EXPANDED),
              HelperFunc.sb(10.h),
              SvgPicture.asset(Assets.doubleCircle,
                  color: order.status == 'COMPLETED'
                      ? null
                      : AppColors.grey.withOpacity(.3))
            ]),
            HelperFunc.sb(20.h),
            Row(children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('From:',
                        style: AppTextStyles.regularText(
                            color: AppColors.grey, fontSize: 9.5)),
                    HelperFunc.sb(3.h),
                    Text(order.pickupAddress ?? '',
                        style: AppTextStyles.regularText(fontSize: 12))
                  ],
                ),
              ),
              SizedBox(width: MediaQuery.of(context).size.width / 5),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                    Text('To:',
                        style: AppTextStyles.regularText(
                            color: AppColors.grey, fontSize: 9.5)),
                    HelperFunc.sb(3.h),
                    Text(order.deliveryAddress ?? '',
                        textAlign: TextAlign.end,
                        style: AppTextStyles.regularText(fontSize: 12))
                  ]))
            ]),
            HelperFunc.sb(10.h)
          ],
        ),
      ),
    );
  }
}
