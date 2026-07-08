import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/enumerations.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import '../../../../../core/constants/helpers.dart';

class HomeOrderTabs extends StatelessWidget {
  const HomeOrderTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
      padding: EdgeInsets.all(7.r),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(27.r)),
      child: BlocBuilder<OrderFlowCubit, OrderFlowState>(
          builder: (context, state) {
        return Row(
            children: RiderOrderTab.values
                .map((e) => GestureDetector(
                    onTap: () => context.read<OrderFlowCubit>().setOrderTab(e),
                    child: Container(
                        padding: EdgeInsets.symmetric(vertical: 9.h),
                        decoration: BoxDecoration(
                            color: state.orderTab == e
                                ? Colors.black
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(20.r)),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${e.name.capitalizeFirstLetter} Orders',
                                  style: AppTextStyles.mediumText(
                                      fontSize: 12,
                                      color: state.orderTab == e
                                          ? Colors.white
                                          : AppColors.grey.withOpacity(.7))),
                              if (state.orderTab == e) HelperFunc.sb(5.w),
                              if (state.orderTab == e)
                                Container(
                                    padding: EdgeInsets.all(5.r),
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border:
                                            Border.all(color: Colors.white)),
                                    child: Text(
                                        (e == RiderOrderTab.pending
                                                ? (state.allOffers ?? []).length
                                                : (state.ongoingOrders ?? [])
                                                    .length)
                                            .toString(),
                                        style: AppTextStyles.mediumText(
                                            fontSize: 7, color: Colors.white)))
                            ]))).EXPANDED)
                .toList());
      }),
    );
  }
}
