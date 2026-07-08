import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';

import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/enumerations.dart';
import '../../../../../../../core/constants/helpers.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../components/tag.dart';

class OrderTimelineHeader extends StatelessWidget {
  final OrderDetails order;
  const OrderTimelineHeader({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      CircleAvatar(
          radius: 21.r,
          backgroundColor: PackageType.general.color,
          child: SvgPicture.asset(PackageType.parcel.asset)),
      HelperFunc.sb(8.w),
      Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(order.id!.toOrderIdTag(),
            style: AppTextStyles.semiBold(fontSize: 14)),
        HelperFunc.sb(5.h),
        if (order.trackingId != null)
          GestureDetector(
            onTap: () => HelperFunc.copyToClipboard(order.trackingId ?? '',
                toastMsg: 'Copied Tracking ID'),
            child: Text('Tracking ID: ${order.trackingId}',
                style: AppTextStyles.regularText(
                    color: AppColors.grey, fontSize: 10)),
          )
      ])),
      Tag(
          txt: order.status?.toUpperCase() == 'CANCELLED'
              ? 'Cancelled'
              : (order.status?.toUpperCase() == 'PAYMENT_PENDING' &&
                      order.trackingId != null)
                  ? 'Awaiting Payment'
                  : order.status?.toUpperCase() == 'COMPLETED' ||
                          order.status?.toUpperCase() == 'DELIVERED'
                      ? 'Delivered'
                      : order.status?.toUpperCase() == 'IN_TRANSIT'
                          ? 'On Transit'
                          : order.status?.toUpperCase() == 'PICKUP_READY'
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
                          : order.status?.toUpperCase() == 'PICKUP_READY'
                              ? AppColors.secColor
                              : order.status?.toUpperCase() ==
                                      'PAYMENT_CONFIRMED'
                                  ? AppColors.materialColor
                                  : AppColors.dullYellow,
          txtFont: 8.5,
          padding: EdgeInsets.symmetric(vertical: 3.h, horizontal: 8.w))
    ]);
  }
}
