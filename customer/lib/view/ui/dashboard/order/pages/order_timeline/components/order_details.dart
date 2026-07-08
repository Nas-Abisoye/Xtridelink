import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../../domain/model/api/order_det.dart';
import 'enable_2FA.dart';

class OrderTimelineDetails extends StatelessWidget {
  final OrderDetails order;
  const OrderTimelineDetails({super.key, required this.order});

  Widget _getColumn(
          {required String header,
          bool makeBold = false,
          required String subText,
          Color? subColor}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(header,
            style: makeBold
                ? AppTextStyles.mediumText(fontSize: 12, color: AppColors.grey)
                : AppTextStyles.regularText(
                    fontSize: 10, color: AppColors.grey)),
        HelperFunc.sb(3.h),
        Text(subText,
            style: makeBold
                ? AppTextStyles.semiBold(
                    fontSize: 14, color: subColor ?? AppColors.secColor)
                : AppTextStyles.mediumText(
                    fontSize: 12, color: subColor ?? AppColors.secColor))
      ]);
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Order Details', style: AppTextStyles.semiBold(fontSize: 14)),
        HelperFunc.sb(15.h),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 25.h),
          decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _getColumn(
                          header: 'From', subText: order.pickupAddress ?? '')),
                  HelperFunc.sb(30.h),
                  Expanded(
                      child: _getColumn(
                          header: 'To', subText: order.deliveryAddress ?? '')),
                ],
              ),
              HelperFunc.sb(25.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _getColumn(
                          header: 'Recipient Name',
                          subText: order.recipientName ?? '')),
                  HelperFunc.sb(30.h),
                  Expanded(
                      child: _getColumn(
                          header: 'Phone Number',
                          subText: order.recipientPhone ?? '')),
                ],
              ),
              HelperFunc.sb(25.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                      child: _getColumn(
                          header: 'Payment Method',
                          subText: order.paymentMethod!.capitalizeFirstLetter)),
                  HelperFunc.sb(30.h),
                  // if (order.otp.isNotEmpty)
                  //   Expanded(
                  //       child: _getColumn(
                  //           makeBold: true,
                  //           header: 'Delivery OTP',
                  //           subText: order.otp)),
                ],
              ),
            ],
          ),
        ),
        if ((order.deliveryNotes ?? '').isNotEmpty) HelperFunc.sb(15.h),
        if ((order.deliveryNotes ?? '').isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.r)),
            child: _getColumn(
                subColor: Colors.black,
                header: 'Comment',
                subText: order.deliveryNotes ?? ''),
          ),
        HelperFunc.sb(15.h),
        // Container(
        //   padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 20.h),
        //   width: double.infinity,
        //   decoration: BoxDecoration(
        //       color: AppColors.lightSec,
        //       borderRadius: BorderRadius.circular(20.r)),
        //   child: Row(
        //     children: [
        //       Expanded(
        //           child: Column(
        //             crossAxisAlignment: CrossAxisAlignment.start,
        //             children: [
        //               Text('2FA delivery code',
        //                   style: AppTextStyles.mediumText(fontSize: 14)),
        //               HelperFunc.sb(5.h),
        //               Text(
        //                   '2FA delivery verification will activate once the driver ends the trip.',
        //                   style: AppTextStyles.regularText(
        //                       fontSize: 10, color: AppColors.grey))
        //             ],
        //           )),
        //       HelperFunc.sb(30.w),
        //       TextButton(
        //         onPressed: ()=> HelperFunc.showFittedBottomSheet(
        //             context: context,
        //             child: const TimelineCopy2FACode()),
        //           child: Text('View Code',style: AppTextStyles.regularText(color: AppColors.secColor, fontSize: 12)))
        //     ],
        //   ),
        // )
      ],
    );
  }
}
