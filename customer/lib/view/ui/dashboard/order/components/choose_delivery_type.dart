import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../order_dispatch.dart';
import '../pages/order_details.dart';

class ChooseDeliveryType extends StatelessWidget {
  final ValueNotifier<OrderDetailsForm> isFormValid;
  const ChooseDeliveryType({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Delivery Type',
                style: AppTextStyles.mediumText(fontSize: 12))
            .pd(EdgeInsets.only(left: 20.w)),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, value, _) {
                return Row(
                  children: [
                    OrderOptionsCard(
                        onTap: () {
                          if (value.isNormalDelivery == false) return;
                          isFormValid.value =
                              value.copyWith(isNormalDelivery: false);
                        },
                        avatarColor: value.isNormalDelivery == false
                            ? Colors.white
                            : AppColors.ashBg,
                        avatarRadius: 20,
                        isSelected: value.isNormalDelivery == false,
                        fillColor: value.isNormalDelivery == false
                            ? AppColors.secColor
                            : Colors.white,
                        avatarSvg: Assets.expressDelivery,
                        headerTxt: 'Express Delivery  ',
                        subTxt: 'Priority given to you'),
                    HelperFunc.sb(10.h),
                    OrderOptionsCard(
                        onTap: () {
                          if (value.isNormalDelivery == true) return;
                          isFormValid.value =
                              value.copyWith(isNormalDelivery: true);
                        },
                        avatarColor: value.isNormalDelivery == true
                            ? Colors.white
                            : AppColors.ashBg,
                        avatarRadius: 20,
                        isSelected: value.isNormalDelivery == true,
                        fillColor: value.isNormalDelivery == true
                            ? AppColors.secColor
                            : Colors.white,
                        avatarSvg: Assets.order,
                        avatarIconColor: AppColors.grey.withValues(alpha: .9),
                        headerTxt: 'Normal Delivery  ',
                        subTxt: 'Basic delivery service'),
                  ],
                );
              }),
        )
      ],
    );
  }
}
