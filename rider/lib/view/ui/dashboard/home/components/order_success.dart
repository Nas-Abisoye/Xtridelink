import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class OrderCompletedSuccessPage extends StatelessWidget {
  const OrderCompletedSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          AppBackButton(
            onTap: () => globalPopUntil(Routes.base),
          ).align(Alignment.topLeft),
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(Assets.success),
            HelperFunc.sb(25.h),
            Text('Order delivered',
                style: AppTextStyles.semiBold(fontSize: 25)),
            HelperFunc.sb(10.h),
            Text('Nice job! Package has been delivered to destination. On to the next one',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.regularText(
                        fontSize: 14, color: AppColors.grey))
                .pd(EdgeInsets.symmetric(horizontal: 50.w)),
            HelperFunc.sb(50.h),
          ]).pd(EdgeInsets.symmetric(horizontal: 20.w)).EXPANDED,
          AppButton(
                  // onTap: ()=> context.read<OrderFlowCubit>().completeOrder(trackingId: 'XT604960', distance: 100),
                  onTap: () => globalPopUntil(Routes.base),
                  btnText: 'Continue')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
