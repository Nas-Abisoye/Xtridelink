import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../components/button.dart';

class CancelOrderSheet extends StatelessWidget {
  const CancelOrderSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor: AppColors.materialColor,
            radius: 50.r,
            child: Icon(Icons.warning_amber_rounded,
                color: Colors.white, size: 50.sp)),
        HelperFunc.sb(20.h),
        Text('Cancel Order', style: AppTextStyles.semiBold(fontSize: 18)),
        HelperFunc.sb(10.h),
        Text('Are you sure you want to cancel this order? This action cannot be undone',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(color: AppColors.grey))
            .pd(EdgeInsets.symmetric(horizontal: 60.w)),
        HelperFunc.sb(50.h),
        SafeArea(
            child: Row(children: [
          HelperFunc.sb(25.w),
          // Expanded(
          //     child: AppButton(
          //         onTap: () => context.read<OrdersCubit>().saveDraft(),
          //         color: Colors.black,
          //         textFont: 12.5,
          //         btnText: 'Save Draft')),
          // HelperFunc.sb(10.w),
          Expanded(
              child: AppButton(
                  onTap: () {
                    globalPop();
                    globalPop();
                    context.read<OrdersCubit>().cancelOrder();
                  },
                  btnText: 'Cancel Order')),
          HelperFunc.sb(25.w)
        ])),
        HelperFunc.sb(10.h)
      ],
    );
  }
}
