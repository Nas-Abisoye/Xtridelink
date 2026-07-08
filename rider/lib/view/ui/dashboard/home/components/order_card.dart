import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/view/components/icon_avatar.dart';
import 'package:xtridelink_driver/view/cubit/chat/index.dart';
import '../chat/index.dart';

class TrackOrderCard extends StatelessWidget {
  final Widget buttons;
  final bool isPending;
  final int orderLevel;
  final String title,
      amount,
      id,
      pickupLocation,
      deliveryLocation,
      recipientName,
      recipientPhone,
      packageType,
      deliveryType,
      receiverImg,
      receiverName,
      receiverPhone,
      comment,
      orderId,
      paymentMethod,
      riderId,
      customerId;
  final bool hasTwoFA;
  final DateTime createdAt;
  const TrackOrderCard(
      {super.key,
      required this.isPending,
      required this.orderLevel,
      required this.buttons,
      required this.title,
      required this.amount,
      required this.id,
      required this.pickupLocation,
      required this.deliveryLocation,
      required this.recipientName,
      required this.recipientPhone,
      required this.packageType,
      required this.deliveryType,
      required this.comment,
      required this.receiverImg,
      required this.receiverName,
      required this.receiverPhone,
      required this.paymentMethod,
      required this.orderId,
      required this.riderId,
      required this.customerId,
      required this.hasTwoFA,
      required this.createdAt});

  Widget _getColumn(
          {required String header,
          required String subText,
          double? subTextFont,
          double? headerFont,
          Color? subTextColor,
          Widget? subWidget}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(header,
            style: AppTextStyles.regularText(
                fontSize: headerFont ?? 8.5, color: AppColors.grey)),
        HelperFunc.sb(7.h),
        Row(mainAxisSize: MainAxisSize.min, children: [
          if (subWidget != null) subWidget,
          Text(subText,
                  style: AppTextStyles.mediumText(
                      fontSize: subTextFont ?? 12, color: subTextColor))
              .EXPANDED,
        ])
      ]);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
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
        child: Column(children: [
          Row(children: [
            CircleAvatar(
                radius: 21.r,
                backgroundColor: PackageType.general.color,
                child: SvgPicture.asset(PackageType.general.asset)),
            HelperFunc.sb(8.w),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title, style: AppTextStyles.semiBold(fontSize: 14)),
              HelperFunc.sb(2.h),
              GestureDetector(
                  onTap: () => HelperFunc.copyToClipboard(id,
                      toastMsg: 'Copied Tracking ID'),
                  child: Text('Tracking ID: $id',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regularText(
                          color: AppColors.grey, fontSize: 10)))
            ]).EXPANDED,
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0,
                        color: AppColors.secColor)),
                HelperFunc.sb(2.h),
                Text(
                    '${HelperFunc.dateFormat.format(createdAt)} ${HelperFunc.timeFormat.format(createdAt)}',
                    style: AppTextStyles.regularText(
                        color: AppColors.grey, fontSize: 8.5))
              ],
            )
          ]),
          HelperFunc.sb(25.h),
          Row(children: [
            SvgPicture.asset(Assets.history, color: AppColors.secColor),
            HelperFunc.sb(12.h),
            (isPending
                    ? const Divider(color: AppColors.secColor, thickness: 2)
                    : Row(
                        children: List.generate(
                            4,
                            (index) => Divider(
                                    color: index <= orderLevel
                                        ? AppColors.materialColor
                                        : AppColors.grey.withOpacity(0.2),
                                    thickness: 2.5)
                                .pd(EdgeInsets.symmetric(horizontal: 5.w))
                                .EXPANDED)))
                .EXPANDED,
            HelperFunc.sb(12.h),
            SvgPicture.asset(Assets.locationSvg2, color: AppColors.secColor)
          ]),
          HelperFunc.sb(20.h),
          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('From:',
                  style: AppTextStyles.regularText(
                      color: AppColors.grey, fontSize: 9.5)),
              HelperFunc.sb(3.h),
              Text(pickupLocation,
                  style: AppTextStyles.regularText(fontSize: 11))
            ]).EXPANDED,
            SizedBox(width: MediaQuery.of(context).size.width / 5),
            Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text('To:',
                  style: AppTextStyles.regularText(
                      color: AppColors.grey, fontSize: 9.5)),
              HelperFunc.sb(3.h),
              Text(deliveryLocation,
                  textAlign: TextAlign.end,
                  style: AppTextStyles.regularText(fontSize: 11))
            ]).EXPANDED
          ]),
          // HelperFunc.sb(20.h),
          Divider(height: 40.h),
          if (!isPending)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.ashBg,
                    borderRadius: BorderRadius.circular(20.r)),
                child: Row(children: [
                  HelperFunc.sb(5.w),
                  if (paymentMethod.isNotEmpty)
                    Expanded(
                        flex: 2,
                        child: _getColumn(
                            subTextColor: AppColors.secColor,
                            header: 'Payment\nMethod',
                            headerFont: 8,
                            subTextFont: 11.5,
                            subText: paymentMethod.capitalizeFirstLetter)),
                  if (paymentMethod.isNotEmpty) HelperFunc.sb(10.w),
                  Expanded(
                      flex: 3,
                      child: _getColumn(
                          subTextColor: AppColors.secColor,
                          header: 'Recipient Name',
                          headerFont: 8,
                          subTextFont: 11.5,
                          subText: recipientName)),
                  HelperFunc.sb(10.w),
                  Expanded(
                      flex: 3,
                      child: _getColumn(
                          subTextColor: AppColors.secColor,
                          header: 'Phone Number',
                          headerFont: 8,
                          subTextFont: 11.5,
                          subText: recipientPhone))
                ]))
          else
            Text('Awaiting payment',
                style: AppTextStyles.mediumText(
                    fontSize: 12, color: AppColors.materialColor)),
          HelperFunc.sb(10.h),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 16.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.lightSec,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(children: [
                HelperFunc.sb(5.w),
                _getColumn(
                        header: 'Package Type',
                        subText: packageType.capitalizeFirstLetter
                            .replaceAll('_', ' '))
                    .EXPANDED,
                HelperFunc.sb(20.w),
                _getColumn(
                        subWidget: SvgPicture.asset(
                                deliveryType.toUpperCase() == 'EXPRESS'
                                    ? Assets.expressDelivery
                                    : Assets.order,
                                color: Colors.black,
                                height: 12.h)
                            .pd(EdgeInsets.only(right: 5.w)),
                        header: 'Delivery Type',
                        subText: deliveryType.capitalizeFirstLetter)
                    .EXPANDED,
                HelperFunc.sb(7.w),
                if (!isPending)
                  SizedBox(
                    height: 25.h,
                    width: 25.h,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        IconAvatar(
                            onTap: () => HelperFunc.showCustomBottomSheet(
                                showBackButton: false,
                                height: MediaQuery.of(context).size.height * .9,
                                context: context,
                                child: TimelineChatSheet(
                                    receiverImg: receiverImg,
                                    orderId: orderId,
                                    customerId: customerId,
                                    riderId: riderId,
                                    receiverName: receiverName,
                                    receiverPhone: receiverPhone)),
                            avatar: Assets.chat,
                            fillColor: AppColors.secColor,
                            color: Colors.white,
                            iconSize: 10.h,
                            radius: 12.r),
                        BlocBuilder<ChatCubit, ChatState>(
                            builder: (context, state) {
                          return state.newChat.contains(orderId)
                              ? CircleAvatar(
                                      radius: 3.r,
                                      backgroundColor: AppColors.materialColor)
                                  .align(Alignment.topRight)
                              : const SizedBox();
                        })
                      ],
                    ),
                  ),
                if (!isPending) HelperFunc.sb(5.w),
                IconAvatar(
                    onTap: () => HelperFunc.makePhoneCall(receiverPhone),
                    avatar: Assets.phone,
                    fillColor: AppColors.secColor,
                    color: Colors.white,
                    iconSize: 10.h,
                    radius: 12.r)
              ])),
          HelperFunc.sb(10.h),
          if (comment.isNotEmpty)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 20.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    border: Border.all(color: AppColors.ashBg),
                    borderRadius: BorderRadius.circular(20.r)),
                child: _getColumn(header: 'Comment', subText: comment)),
          if (hasTwoFA) HelperFunc.sb(10.h),
          if (hasTwoFA)
            Container(
                padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 14.h),
                width: double.infinity,
                decoration: BoxDecoration(
                    color: AppColors.lightPri,
                    borderRadius: BorderRadius.circular(12.r)),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Trip has 2FA delivery code enabled',
                          style: AppTextStyles.mediumText(
                              fontSize: 11, color: AppColors.materialColor)),
                      HelperFunc.sb(3.h),
                      Text(
                          '2FA delivery verification will activate once the package is delivered.',
                          style: AppTextStyles.regularText(
                              fontSize: 8.5, color: AppColors.grey))
                    ])),
          HelperFunc.sb(10.h),
          buttons
        ]));
  }
}
