import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/helpers.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';

class HomeRideOverview extends StatelessWidget {
  const HomeRideOverview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 115.h,
        margin: EdgeInsets.symmetric(horizontal: 20.w),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(30.r)),
        child: Stack(fit: StackFit.expand, children: [
          ClipRRect(
              borderRadius: BorderRadius.circular(30.r),
              child: SvgPicture.asset(Assets.cardBg, fit: BoxFit.cover)),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Orders Completed',
                      style: AppTextStyles.regularText(
                          color: Colors.white, fontSize: 10)),
                  HelperFunc.sb(2.h),
                  BlocBuilder<OrderFlowCubit, OrderFlowState>(
                      builder: (context, state) {
                    final completeCount = state.orderHistory
                            ?.where((element) =>
                                element.status!.toLowerCase() == 'completed')
                            .length ??
                        0;
                    return Text('$completeCount',
                        style: AppTextStyles.semiBold(
                            color: Colors.white, fontSize: 34));
                  })
                ]),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Distance Covered',
                      style: AppTextStyles.regularText(
                          color: Colors.white, fontSize: 10)),
                  HelperFunc.sb(2.h),
                  BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                    return RichText(
                        text: TextSpan(
                            text:
                                '${state.riderAnalytics?.distanceCovered.round() ?? 0}',
                            style: AppTextStyles.semiBold(
                                color: Colors.white, fontSize: 34),
                            children: [
                          TextSpan(
                              text: 'km',
                              style: AppTextStyles.mediumText(
                                  fontSize: 10, color: Colors.white)),
                        ]));
                  })
                ]),
          ]).pd(EdgeInsets.symmetric(horizontal: 40.w))
        ]));
  }
}
