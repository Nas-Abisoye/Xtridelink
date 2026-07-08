import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/order_det.dart';

import '../../../../../../../core/constants/old_assets.dart';
import '../../../../../../../core/constants/helpers.dart';

class OrderTimelineTrackingHistory extends StatelessWidget {
  final OrderDetails order;
  const OrderTimelineTrackingHistory({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tracking History', style: AppTextStyles.semiBold(fontSize: 14)),
        HelperFunc.sb(10.h),
        if (order.status?.toUpperCase() == 'PAYMENT_CONFIRMED')
          TrackSingleDetail(
              time: order.paymentCompletedAt?.toDateTime().toLocal(),
              header: 'Awaiting Pickup',
              subText:
                  'Your order has been accepted and driver is on the way to your location'),

        if (order.status?.toUpperCase() == 'PICKUP_READY') ...[
          TrackSingleDetail(
              time: order.paymentCompletedAt?.toDateTime().toLocal(),
              header: 'Awaiting Pickup',
              subText:
                  'Your order has been accepted and driver is on the way to your location'),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              header: 'Package picked up',
              subText: 'Driver has picked up your order'),
          // HelperFunc.sb(2.h),
        ],
        if (order.status?.toUpperCase() == 'IN_TRANSIT') ...[
          TrackSingleDetail(
              time: order.paymentCompletedAt?.toDateTime().toLocal(),
              header: 'Awaiting Pickup',
              subText:
                  'Your order has been accepted and driver is on the way to your location'),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              header: 'Package picked up',
              subText: 'Driver has picked up your order'),
          // HelperFunc.sb(2.h),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              header: 'Order in transit',
              showTrail: false,
              subText: 'Your package is in enroute to the delivery location'),
        ],
        if (order.status?.toUpperCase() == 'DELIVERED') ...[
          TrackSingleDetail(
              time: order.paymentCompletedAt?.toDateTime().toLocal(),
              header: 'Awaiting Pickup',
              subText:
                  'Your order has been accepted and driver is on the way to your location'),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              header: 'Package picked up',
              subText: 'Driver has picked up your order'),
          // HelperFunc.sb(2.h),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              header: 'Order in transit',
              subText: 'Your package is in enroute to the delivery location'),
          TrackSingleDetail(
              time: order.updatedAt?.toDateTime().toLocal(),
              showTrail: false,
              header: 'Order delivered',
              subText: 'Your package has been delivered to destination'),
        ],
        // HelperFunc.sb(2.h),
      ],
    );
  }
}

class TrackSingleDetail extends StatelessWidget {
  final bool showTrail;
  final DateTime? time;
  final String header, subText;
  const TrackSingleDetail(
      {super.key,
      this.showTrail = true,
      this.time,
      required this.header,
      required this.subText});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          SvgPicture.asset(Assets.doubleCircle,
              color: time != null
                  ? AppColors.materialColor
                  : AppColors.grey.withOpacity(.45)),
          HelperFunc.sb(3.h),
          if (showTrail)
            SizedBox(
                height: 42.h,
                child: Column(
                    children: List.generate(
                        5,
                        (index) => Expanded(
                            child: VerticalDivider(
                                    color: time != null
                                        ? AppColors.materialColor
                                        : AppColors.grey.withOpacity(0.45),
                                    thickness: 1.5)
                                .pd(EdgeInsets.symmetric(vertical: 2.h)))))),
          HelperFunc.sb(5.h)
        ]),
        HelperFunc.sb(10.w),
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(header,
              style: AppTextStyles.mediumText(
                  fontSize: 12, color: AppColors.grey)),
          HelperFunc.sb(3.h),
          Text(subText,
              style: AppTextStyles.regularText(
                  fontSize: 10, color: AppColors.grey))
        ])),
        HelperFunc.sb(20.w),
        Text(time != null ? HelperFunc.timeFormat.format(time!) : '      ',
            style: AppTextStyles.mediumText(
                fontSize: 12, color: AppColors.grey.withOpacity(.7))),
      ],
    );
  }
}
