import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/text_styles.dart';
import '../order_dispatch.dart';
import '../pages/order_details.dart';

class ChooseVehicleType extends StatelessWidget {
  final ValueNotifier<OrderDetailsForm> isFormValid;
  const ChooseVehicleType({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Vehicle Type',
                style: AppTextStyles.mediumText(fontSize: 12))
            .pd(EdgeInsets.only(left: 20.w)),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, value, _) {
                return Row(
                    children: VehicleType.values
                        .map((e) => OrderOptionsCard(
                                onTap: () {
                                  if (value.vehicleType == e) return;
                                  isFormValid.value =
                                      value.copyWith(vehicleType: e);
                                },
                                avatarColor: value.vehicleType == e
                                    ? Colors.white
                                    : AppColors.ashBg,
                                avatarRadius: 20,
                                txtFont: 12,
                                isSelected: value.vehicleType == e,
                                fillColor: value.vehicleType == e
                                    ? AppColors.secColor
                                    : Colors.white,
                                avatarSvg: e.asset,
                                headerTxt: '${e.name.capitalizeFirstLetter}  ')
                            .pd(EdgeInsets.only(right: 10.w)))
                        .toList());
              }),
        )
      ],
    );
  }
}
