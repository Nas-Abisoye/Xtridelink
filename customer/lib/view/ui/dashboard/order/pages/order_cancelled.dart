import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class OrderCancelledPage extends StatelessWidget {
  const OrderCancelledPage({super.key});

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
                SvgPicture.asset(Assets.fail),
                HelperFunc.sb(20.h),
                Text('Order cancelled',
                    style: AppTextStyles.semiBold(fontSize: 25)),
                HelperFunc.sb(10.h),
                Text('Heads up, your order was cancelled by the driver due to unresponsiveness of recipient. Yor package will be returned to you',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 50.w)),
                HelperFunc.sb(25.h),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 25.h),
                  margin: EdgeInsets.symmetric(horizontal: 30.h),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: AppColors.ashBg,
                      borderRadius: BorderRadius.circular(16.r)),
                  child: Column(
                    children: [
                      Text('RETURN FEE',
                          style: AppTextStyles.regularText(fontSize: 10)
                              .copyWith(letterSpacing: 2.5)),
                      HelperFunc.sb(10.h),
                      Text(1000.formatCurrency,
                          style: TextStyle(
                              fontSize: 22.sp, fontWeight: FontWeight.w800)),
                      HelperFunc.sb(10.h),
                      Text(
                          'This fee should be paid once\npackage is received by the sender',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regularText(
                              fontSize: 10, color: AppColors.grey)),
                    ],
                  ),
                ),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          AppButton(
                  color: Colors.black,
                  // onTap: () => globalReplaceWith(
                  //     route: Routes.timeline, arguments: OrderState.cancelled),
                  btnText: 'Continue')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
