import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/ui/dashboard/order/components/payment_options.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../../../../components/button.dart';

class AcceptOrRejectPrice extends StatelessWidget {
  final bool isAccepted;
  const AcceptOrRejectPrice({super.key, required this.isAccepted});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
            backgroundColor:
                isAccepted ? AppColors.lightSec : AppColors.lightPri,
            radius: 56.r,
            child: SvgPicture.asset(
                isAccepted ? Assets.thumbUp : Assets.thumbDown)),
        HelperFunc.sb(20.h),
        Text('Price ${isAccepted ? 'accepted' : 'rejected'}',
            style: AppTextStyles.semiBold(fontSize: 18)),
        HelperFunc.sb(10.h),
        Text(
                isAccepted
                    ? 'Driver has accepted your price. Proceed to payment'
                    : 'Driver has rejected your price. You can renegotiate or try another driver',
                textAlign: TextAlign.center,
                style: AppTextStyles.regularText(color: AppColors.grey))
            .pd(EdgeInsets.symmetric(horizontal: 60.w)),
        HelperFunc.sb(50.h),
        SafeArea(
            child: Row(children: [
          HelperFunc.sb(25.w),
          if (!isAccepted)
            Expanded(
                child: AppButton(
                    onTap: () => globalPopUntil(Routes.selectDriver),
                    color: Colors.black,
                    btnText: 'Find Other Driver')),
          if (!isAccepted) HelperFunc.sb(10.w),
          Expanded(
              child: AppButton(
                  onTap: () {
                    // if (isAccepted) {
                    //   globalPopUntil(Routes.selectDriver);
                    //   HelperFunc.showFittedBottomSheet(
                    //       context: context, child: const PaymentOptionsSheet());
                    // } else {
                    //   globalPop();
                    // }
                  },
                  btnText: isAccepted ? 'Proceed To Payment' : 'Re-negotiate')),
          HelperFunc.sb(25.w)
        ])),
        HelperFunc.sb(10.h)
      ],
    );
  }
}
