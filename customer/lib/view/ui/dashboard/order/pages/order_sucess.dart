import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class OrderPlacementSuccessPage extends StatelessWidget {
  const OrderPlacementSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          const Align(alignment: Alignment.topLeft, child: AppBackButton()),
          Expanded(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                SvgPicture.asset(Assets.success),
                HelperFunc.sb(25.h),
                Text('Order placed',
                    style: AppTextStyles.semiBold(fontSize: 25)),
                HelperFunc.sb(10.h),
                Text('Yay! Your order has been successfully booked & driver is on the way',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 35.w)),
                HelperFunc.sb(30.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  margin: EdgeInsets.symmetric(horizontal: 20.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.lightSec,
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    children: [
                      Text('TRACKING ID',
                          style: AppTextStyles.regularText(fontSize: 10)
                              .copyWith(letterSpacing: 2.5)),
                      HelperFunc.sb(10.h),
                      BlocBuilder<OrdersCubit, OrdersState>(
                          builder: (context, state) {
                        return Text(state.negotiatingOrder?.trackingId ?? '',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.mediumText(fontSize: 18));
                      })
                    ],
                  ),
                )
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
            return AppButton(
                    onTap: () {
                      globalPopUntil(Routes.base);
                      if (state.negotiatingOrder != null) {
                        globalNavigateTo(
                            route: Routes.timeline,
                            arguments: state.negotiatingOrder!.trackingId);
                      }
                    },
                    btnText: 'View Timeline')
                .pd(EdgeInsets.symmetric(horizontal: 20.w));
          }),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
