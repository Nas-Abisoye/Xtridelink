import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import '../../../../../core/constants/colors.dart';
import '../../../../../core/constants/helpers.dart';
import '../../../../../core/constants/text_styles.dart';
import '../../../../../core/services/navigation/index.dart';
import '../order_dispatch.dart';
import '../pages/order_details.dart';

class ChoosePackageType extends StatelessWidget {
  final ValueNotifier<OrderDetailsForm> isFormValid;
  const ChoosePackageType({super.key, required this.isFormValid});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Choose Package Type',
                style: AppTextStyles.mediumText(fontSize: 12))
            .pd(EdgeInsets.only(left: 20.w)),
        SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          scrollDirection: Axis.horizontal,
          child: ValueListenableBuilder(
              valueListenable: isFormValid,
              builder: (context, value, _) {
                return Row(
                    children: PackageType.values
                        .map((e) => OrderOptionsCard(
                                onTap: () {
                                  if (value.packageType == e &&
                                      e != PackageType.general) return;
                                  e == PackageType.general
                                      ? HelperFunc.showCustomBottomSheet(
                                          context: context,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.7,
                                          child: ListView(
                                              shrinkWrap: true,
                                              children: GeneralPackageTypes
                                                  .values
                                                  .map((e) => TextButton(
                                                        onPressed: () {
                                                          globalPop();
                                                          isFormValid.value =
                                                              value.copyWith(
                                                                  packageType:
                                                                      PackageType
                                                                          .general,
                                                                  generalPackageType:
                                                                      e);
                                                        },
                                                        child: SizedBox(
                                                          width:
                                                              double.infinity,
                                                          child: Text(
                                                            e.txt,
                                                            style: AppTextStyles
                                                                .mediumText(
                                                                    color: Colors
                                                                        .black),
                                                          ),
                                                        ),
                                                      ))
                                                  .toList()))
                                      : isFormValid.value =
                                          value.copyWith(packageType: e);
                                },
                                avatarColor: e.color,
                                avatarRadius: 20,
                                txtFont: 12,
                                isSelected: value.packageType == e,
                                fillColor: value.packageType == e
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
