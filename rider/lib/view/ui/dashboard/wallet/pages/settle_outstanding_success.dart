import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink_driver/core/constants/assets.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/core/services/navigation/routes.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';

class SettleOutstandingSuccess extends StatelessWidget {
  final num amount;
  const SettleOutstandingSuccess({super.key, required this.amount});

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
            Text('Outstanding settled',
                style: AppTextStyles.semiBold(fontSize: 25)),
            HelperFunc.sb(10.h),
            RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                    text:
                        'You have successfully settled your outstanding balance and a total of ',
                    style: TextStyle(
                        fontSize: 14.sp,
                        color: AppColors.grey,
                        fontWeight: FontWeight.w300),
                    children: [
                      TextSpan(
                          text: amount.formatCurrency,
                          style: TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14.sp,
                              color: AppColors.grey)),
                      TextSpan(text: ' was deducted from your wallet.'),
                    ])).pd(EdgeInsets.symmetric(horizontal: 50.w)),
            HelperFunc.sb(50.h),
          ]).pd(EdgeInsets.symmetric(horizontal: 20.w)).EXPANDED,
          AppButton(
                  onTap: () => globalPopUntil(Routes.base), btnText: 'Continue')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
