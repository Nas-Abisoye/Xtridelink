import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../components/back_button.dart';
import '../../../../components/button.dart';
import '../components/cancel_order.dart';
import '../components/payment_options.dart';

class OfferPlacementRejectedPage extends StatelessWidget {
  const OfferPlacementRejectedPage({super.key});

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
                HelperFunc.sb(25.h),
                Text('Order rejected',
                    style: AppTextStyles.semiBold(fontSize: 25)),
                HelperFunc.sb(10.h),
                Text('Heads up, your order was cancelled by the rider',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 50.w)),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          AppButton(
                  color: Colors.black,
                  onTap: () => globalPopUntil(Routes.selectDriver),
                  btnText: 'Find Other Driver')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h),
          TextButton(
              onPressed: () => HelperFunc.showFittedBottomSheet(
                  context: context, child: const CancelOrderSheet()),
              child: Text('Cancel Order',
                  style: AppTextStyles.mediumText(
                      fontSize: 13, color: Colors.black))),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}

class OfferPlacementAcceptedPage extends StatelessWidget {
  const OfferPlacementAcceptedPage({super.key});

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
                CircleAvatar(
                    backgroundColor: AppColors.lightSec,
                    radius: 65.r,
                    child: SvgPicture.asset(Assets.thumbUp)),
                HelperFunc.sb(25.h),
                Text('Order accepted',
                    style: AppTextStyles.semiBold(fontSize: 25)),
                HelperFunc.sb(10.h),
                Text('Driver has accepted your price. Proceed to payment',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.regularText(
                            fontSize: 14, color: AppColors.grey))
                    .pd(EdgeInsets.symmetric(horizontal: 50.w)),
              ]).pd(EdgeInsets.symmetric(horizontal: 20.w))),
          AppButton(
                  onTap: () => HelperFunc.showFittedBottomSheet(
                      isDismissible: false,
                      showBackButton: false,
                      context: buildContext,
                      child: const PaymentOptionsSheet()),
                  btnText: 'Proceed to payment')
              .pd(EdgeInsets.symmetric(horizontal: 20.w)),
          HelperFunc.sb(10.h)
        ],
      )),
    );
  }
}
