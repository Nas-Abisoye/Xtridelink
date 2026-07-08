import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/routes.dart';
import '../../../../components/button.dart';
import '../../../../components/loader.dart';
import '../components/cancel_order.dart';

class SearchDriverSheet extends StatelessWidget {
  const SearchDriverSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HelperFunc.sb(10.h),
        Text('Searching for driver', style: AppTextStyles.semiBold()),
        HelperFunc.sb(10.h),
        Text('Relax while we look for the closest driver',
            style: AppTextStyles.regularText(color: AppColors.grey)),
        HelperFunc.sb(25.h),
        Expanded(child:
            BlocBuilder<OrdersCubit, OrdersState>(builder: (context, state) {
          return CarLoader(
              awaitFunction: () => Future.delayed(const Duration(seconds: 1)),
              height: 100,
              increment: 40,
              onTimerCompleted: () {
                globalPop();
                globalReplaceWith(route: Routes.selectDriver);
              });
        })),
        HelperFunc.sb(80.h),
        AppButton(btnText: 'Adjust Order', onTap: () => globalPop()),
        HelperFunc.sb(10.h),
        Align(
            child: TextButton(
                onPressed: () => HelperFunc.showFittedBottomSheet(
                    context: context, child: const CancelOrderSheet()),
                child: Text('Cancel Order',
                    style: AppTextStyles.mediumText(
                        fontSize: 12.5, color: Colors.black)))),
        HelperFunc.sb(30.h)
      ],
    );
  }
}
