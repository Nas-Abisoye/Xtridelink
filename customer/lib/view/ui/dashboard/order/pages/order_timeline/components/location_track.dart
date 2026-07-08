import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/order_det.dart';
import 'tracking_history.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/text_styles.dart';

class OrderTimelineLocationTrack extends StatelessWidget {
  final OrderDetails order;
  const OrderTimelineLocationTrack({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final index = (order.status?.toUpperCase() == 'COMPLETED' ||
            order.status?.toUpperCase() == 'DELIVERED'
        ? 4
        : order.status?.toUpperCase() == 'IN_TRANSIT'
            ? 3
            : order.status?.toUpperCase() == 'PICKUP_READY'
                ? 2
                : order.status?.toUpperCase() == 'PAYMENT_CONFIRMED'
                    ? 1
                    : 0);
    return Column(
      children: [
        Row(children: [
          Text('Tracking History', style: AppTextStyles.semiBold(fontSize: 14)),
          const Spacer(),
          TextButton(
              onPressed: () => HelperFunc.showFittedBottomSheet(
                  context: context,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Order Timeline',
                            style: AppTextStyles.semiBold(fontSize: 22)),
                        HelperFunc.sb(10.h),
                        TrackSingleDetail(
                            time: index >= 0
                                ? DateTime.parse(order.paymentCompletedAt!)
                                : null,
                            header: 'Awaiting Pickup',
                            subText:
                                'Your order has been accepted and driver is on the way to your location'),
                        TrackSingleDetail(
                            time: index >= 1
                                ? DateTime.parse(order.updatedAt!)
                                : null,
                            header: 'Package picked up',
                            subText: 'Driver has picked up your order'),
                        TrackSingleDetail(
                            time: index >= 2
                                ? DateTime.parse(order.updatedAt!)
                                : null,
                            header: 'Order in transit',
                            subText:
                                'Your package is in enroute to the delivery location'),
                        SafeArea(
                            child: TrackSingleDetail(
                                time: index >= 4
                                    ? DateTime.parse(order.updatedAt!).toLocal()
                                    : null,
                                showTrail: false,
                                header: 'Order delivered',
                                subText:
                                    'Your package has been delivered to destination'))
                      ]).pd(
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h))),
              child: Text('View Timeline',
                  style: AppTextStyles.mediumText(
                      fontSize: 12, color: AppColors.secColor)))
        ]),
        HelperFunc.sb(5.h),
        // TrackSingleLocation(
        //     showTrail: true,
        //     header: order.pickupAddress ?? '',
        //     time: HelperFunc.timeFormat.format(
        //         order.trackingId?.packagePicking?.toLocal() ?? order.createdAt),
        //     trailColor: order.status.toLowerCase() == 'canceled' ||
        //             order.status.toLowerCase() == 'cancelled'
        //         ? AppColors.red
        //         : null,
        //     svg: Assets.history),
        // TrackSingleLocation(
        //     showTrail: false,
        //     header: order.locationDelivery,
        //     time: order.status.toLowerCase() == 'canceled' ||
        //             order.status.toLowerCase() == 'cancelled'
        //         ? 'Not Delivered'
        //         : HelperFunc.timeFormat.format(
        //             order.trackingId?.packageDelivered ?? order.createdAt),
        //     svgColor: order.status.toLowerCase() == 'canceled' ||
        //             order.status.toLowerCase() == 'cancelled'
        //         ? AppColors.red
        //         : null,
        //     textColor: order.status.toLowerCase() == 'canceled' ||
        //             order.status.toLowerCase() == 'cancelled'
        //         ? AppColors.red
        //         : null,
        //     svg: Assets.locationSvg)
      ],
    );
  }
}

class TrackSingleLocation extends StatelessWidget {
  final bool showTrail;
  final String header, svg, time;
  final Color? trailColor, svgColor, textColor;
  const TrackSingleLocation(
      {super.key,
      required this.showTrail,
      required this.header,
      required this.svg,
      required this.time,
      this.trailColor,
      this.svgColor,
      this.textColor});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(children: [
          SvgPicture.asset(svg, color: svgColor ?? AppColors.secColor),
          HelperFunc.sb(3.h),
          if (showTrail)
            SizedBox(
                height: 40.h,
                child: VerticalDivider(
                        color: trailColor ?? AppColors.secColor, thickness: 1.5)
                    .pd(EdgeInsets.symmetric(vertical: 2.w))),
          HelperFunc.sb(3.h)
        ]),
        HelperFunc.sb(10.w),
        Expanded(
            child: Text(header,
                style: AppTextStyles.mediumText(
                    fontSize: 12, color: textColor ?? AppColors.grey))),
        HelperFunc.sb(20.w),
        Text(time,
            style: AppTextStyles.mediumText(
                fontSize: 12, color: AppColors.grey.withOpacity(.6))),
      ],
    );
  }
}
