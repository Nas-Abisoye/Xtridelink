import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/helpers/app_constants.dart';
import 'package:xtridelink/data/source/remote/model/order/create_order_response.dart';
import 'package:xtridelink/domain/model/api/order_det.dart';
import 'package:xtridelink/view/components/icon_avatar.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/chat/index.dart';
import '../../../../../../../core/constants/colors.dart';
import '../../../../../../../core/constants/enumerations.dart';
import '../../../../../../../core/constants/helpers.dart';
import '../../../../../../../core/constants/text_styles.dart';
import '../../../../../../components/button.dart';
import '../../../../../../components/profile_avatar.dart';
import '../../../../../../cubit/chat/index.dart';

class OrderTimelineDriverContactSheet extends StatelessWidget {
  final bool inProgress;
  final OrderDetails order;
  OrderTimelineDriverContactSheet(
      {super.key, required this.inProgress, required this.order});

  Widget _getColumn({required String header, required String subText}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(header,
            style: AppTextStyles.regularText(
                fontSize: 9.5, color: AppColors.grey)),
        HelperFunc.sb(3.h),
        Text(subText,
            style: AppTextStyles.mediumText(
                fontSize: 13, color: AppColors.secColor))
      ]);

  final ValueNotifier<Rating> stars = ValueNotifier(Rating.zero);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(40.r))),
      child: SafeArea(
        top: false,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
              width: double.infinity,
              decoration: BoxDecoration(
                  color: AppColors.lightSec,
                  borderRadius: BorderRadius.circular(20.r)),
              child: Row(children: [
                Expanded(
                    child: _getColumn(
                        header: 'Delivery Type',
                        subText: order.deliveryType!.capitalizeFirstLetter)),
                SizedBox(height: 50.h, width: 10.w),
                Expanded(
                    child: _getColumn(
                        header: 'Package Type',
                        subText: order.packageType!.capitalizeFirstLetter
                            .replaceAll('_', ' ')))
              ])),
          HelperFunc.sb(15.h),
          if (order.riderDetails != null)
            Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                    color: AppColors.secColor,
                    borderRadius: BorderRadius.circular(50.r)),
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  ProfileAvatar(radius: 25, avatar: AppConstants.riderAvatar),
                  HelperFunc.sb(8.w),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('${order.riderDetails!.name} ',
                              style: AppTextStyles.mediumText(
                                  fontSize: 14, color: Colors.white)),
                          HelperFunc.sb(2.h),
                          // Text(order.riderDetails?.vehicleName ?? 'N/A',
                          //     style: AppTextStyles.mediumText(
                          //         color: Colors.white, fontSize: 10)),
                          // HelperFunc.sb(2.h),
                          // Text(
                          //     'Vehicle ID: ${order.rider?.vehiclePlateNo ?? 'N/A'}',
                          //     style: AppTextStyles.mediumText(
                          //         color: Colors.white, fontSize: 9)),
                        ]),
                  ),
                  if (order.status!.toLowerCase() != 'cancelled')
                    inProgress
                        ? Row(children: [
                            SizedBox(
                              height: 35.h,
                              width: 35.h,
                              child: Stack(
                                children: [
                                  IconAvatar(
                                      onTap: () =>
                                          HelperFunc.showCustomBottomSheet(
                                              showBackButton: false,
                                              height:
                                                  MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      .9,
                                              context: context,
                                              child: TimelineChatSheet(
                                                  order: order)),
                                      radius: 17.r,
                                      circleColor: Colors.white,
                                      color: AppColors.materialColor,
                                      avatar: Assets.chat),
                                  // BlocBuilder<ChatCubit, ChatState>(
                                  //     builder: (context, state) {
                                  //   return state.newChat.contains(order.id)
                                  //       ? Positioned(
                                  //           top: 2.h,
                                  //           right: 2.w,
                                  //           child: CircleAvatar(
                                  //               radius: 4.r,
                                  //               backgroundColor:
                                  //                   AppColors.materialColor))
                                  //       : const SizedBox();
                                  // })
                                ],
                              ),
                            ),
                            HelperFunc.sb(10.w),
                            if ((order.riderDetails?.phoneNumber ?? '')
                                .isNotEmpty)
                              IconAvatar(
                                  onTap: () => HelperFunc.makePhoneCall(
                                      order.riderDetails?.phoneNumber ?? ''),
                                  radius: 17.r,
                                  circleColor: Colors.white,
                                  color: AppColors.materialColor,
                                  avatar: Assets.phone)
                          ])
                        : ValueListenableBuilder(
                            valueListenable: stars,
                            builder: (context, value, _) {
                              return value == Rating.zero
                                  ? TextButton(
                                      onPressed: () =>
                                          HelperFunc.showFittedBottomSheet(
                                              context: context,
                                              child: OrderTimelineRateDriver(
                                                  onRate: (value) =>
                                                      stars.value = value,
                                                  rider: order.riderDetails,
                                                  stars: stars)),
                                      child: Text('Rate Driver',
                                          style: AppTextStyles.mediumText(
                                              fontSize: 12,
                                              color: AppColors.yellow)))
                                  : Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                          Text('Rating',
                                              style: AppTextStyles.mediumText(
                                                  fontSize: 10,
                                                  color: Colors.white)),
                                          HelperFunc.sb(3.h),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: List.generate(
                                                  5,
                                                  (i) => GestureDetector(
                                                      onTap: () => stars.value =
                                                          Rating.values[i + 1],
                                                      child: Icon(Icons.star,
                                                          size: 15.h,
                                                          color: (i + 1) <=
                                                                  Rating.values
                                                                      .indexOf(
                                                                          value)
                                                              ? AppColors.yellow
                                                              : AppColors
                                                                  .ashBg))))
                                        ]);
                            }),
                  HelperFunc.sb(7.w)
                ])),
          if (!inProgress)
            Row(children: [
              Text('Payment Type',
                  style: AppTextStyles.regularText(
                      fontSize: 13.5, color: AppColors.grey.withOpacity(.8))),
              const Spacer(),
              Text(
                  order.paymentCompletedAt != null
                      ? 'Prepaid'
                      : 'Pay on Delivery',
                  style: AppTextStyles.mediumText(
                      fontSize: 14, color: AppColors.grey.withOpacity(.9))),
            ]).pd(EdgeInsets.only(top: 20.h)),
          if (!inProgress && order.finalPrice != null)
            Row(children: [
              Text('Total Amount',
                  style: AppTextStyles.regularText(
                      fontSize: 13.5, color: AppColors.grey.withOpacity(.8))),
              const Spacer(),
              Text(order.finalPrice!.toDouble().formatCurrency,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, fontSize: 16)),
            ]).pd(EdgeInsets.only(top: 10.h)),
          HelperFunc.sb(5.h)
        ]),
      ),
    );
  }
}

class OrderTimelineRateDriver extends StatelessWidget {
  final ValueNotifier<Rating> stars;
  final RiderDetails? rider;
  final void Function(Rating) onRate;
  const OrderTimelineRateDriver(
      {super.key,
      required this.stars,
      required this.rider,
      required this.onRate});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        top: false,
        child: Column(children: [
          HelperFunc.sb(30.h),
          Text('RATE YOUR DRIVER',
              style: AppTextStyles.regularText(
                      fontSize: 10, color: AppColors.secColor)
                  .copyWith(letterSpacing: 2.5)),
          HelperFunc.sb(20.h),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            ProfileAvatar(
              radius: 20.r,
              avatar: AppConstants.riderAvatar,
            ),
            HelperFunc.sb(10.w),
            Text('${rider?.name ?? ''}',
                textAlign: TextAlign.center,
                style: AppTextStyles.mediumText(fontSize: 18))
          ]),
          HelperFunc.sb(20.h),
          ValueListenableBuilder(
              valueListenable: stars,
              builder: (context, value, _) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        5,
                        (i) => GestureDetector(
                            onTap: () => stars.value = Rating.values[i + 1],
                            child: Icon(Icons.star,
                                size: 40.h,
                                color: (i + 1) <= Rating.values.indexOf(value)
                                    ? AppColors.yellow
                                    : AppColors.grey.withOpacity(.15)))));
              }),
          HelperFunc.sb(50.h),
          ValueListenableBuilder(
              valueListenable: stars,
              builder: (context, value, _) {
                return AppButton(
                    onTap: () => context
                        .read<OrdersCubit>()
                        .rateRider(riderId: rider?.id ?? '', rating: value),
                    color: value == Rating.zero
                        ? AppColors.grey.withOpacity(.5)
                        : null,
                    btnText: 'Rate Driver');
              })
        ]).pd(EdgeInsets.symmetric(horizontal: 20.w)));
  }
}
