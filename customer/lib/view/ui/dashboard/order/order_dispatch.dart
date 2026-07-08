import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/enumerations.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/view/components/button.dart';
import 'package:xtridelink/view/ui/dashboard/order/pages/order_details.dart';
import '../../../../core/constants/old_assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';

class OrderDispatch extends StatelessWidget {
  OrderDispatch({super.key});

  final ValueNotifier<OrderType?> orderType = ValueNotifier(null);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => HelperFunc.showFittedBottomSheet(
          context: context,
          child: ValueListenableBuilder(
              valueListenable: orderType,
              builder: (context, value, _) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      HelperFunc.sb(10.h),
                      Text('Choose order type',
                          style: AppTextStyles.semiBold()),
                      HelperFunc.sb(10.h),
                      Text('Select what type of order you want',
                          style:
                              AppTextStyles.regularText(color: AppColors.grey)),
                      HelperFunc.sb(25.h),
                      OrderOptionsCard(
                          width: double.infinity,
                          onTap: () => orderType.value = OrderType.send,
                          avatarColor: AppColors.lightSec,
                          avatarRadius: 29,
                          isSelected: value == OrderType.send,
                          fillColor: value == OrderType.send
                              ? AppColors.secColor
                              : AppColors.ashBg,
                          avatarSvg: Assets.sendPackage,
                          headerTxt: 'Send Package',
                          subTxt: 'Have a driver deliver a package for you'),
                      HelperFunc.sb(10.h),
                      OrderOptionsCard(
                          width: double.infinity,
                          onTap: () => orderType.value = OrderType.recieve,
                          avatarColor: AppColors.lightPri,
                          avatarRadius: 29,
                          isSelected: value == OrderType.recieve,
                          fillColor: value == OrderType.recieve
                              ? AppColors.secColor
                              : AppColors.ashBg,
                          avatarSvg: Assets.receivePackage,
                          headerTxt: 'Receive Package',
                          subTxt: 'Have a driver deliver a package for you'),
                      HelperFunc.sb(100.h),
                      SafeArea(
                        top: false,
                        child: AppButton(
                            onTap: value == null
                                ? null
                                : () {
                                    globalPop();
                                    globalNavigateTo(
                                        route: Routes.provideOrderDet,
                                        arguments: PackageOrderParam(
                                            packageType: null,
                                            orderType: value,
                                            generalPackageType: null,
                                            orderDet: null));
                                  },
                            btnText: 'Continue',
                            color: value == null
                                ? AppColors.grey.withOpacity(.5)
                                : null),
                      )
                    ]).pd(EdgeInsets.symmetric(horizontal: 20.w));
              })),
      child: Container(
          height: 60.w,
          width: 60.w,
          decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.materialColor.withAlpha(240),
              boxShadow: const [
                BoxShadow(
                    color: AppColors.lightPri,
                    spreadRadius: 3,
                    blurRadius: 23,
                    offset: Offset(0, 4)),
                BoxShadow(
                    color: AppColors.lightPri,
                    spreadRadius: 3,
                    blurRadius: 23,
                    offset: Offset(0, -4))
              ]),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            SvgPicture.asset(Assets.order),
            HelperFunc.sb(3.h),
            Text('Order',
                style:
                    AppTextStyles.mediumText(color: Colors.white, fontSize: 10))
          ])),
    );
  }
}

class OrderOptionsCard extends StatelessWidget {
  final double avatarRadius;
  final double? width, txtFont, iconSize;
  final String headerTxt, avatarSvg;
  final Color avatarColor, fillColor;
  final Color? avatarIconColor;
  final String? subTxt;
  final bool isSelected;
  final void Function()? onTap;
  final List<BoxShadow>? boxShadow;
  final TextStyle? style;
  const OrderOptionsCard(
      {super.key,
      required this.avatarColor,
      required this.avatarRadius,
      required this.fillColor,
      required this.avatarSvg,
      required this.headerTxt,
      this.isSelected = false,
      this.onTap,
      this.width,
      this.txtFont,
      this.avatarIconColor,
      this.style,
      this.iconSize,
      this.boxShadow,
      this.subTxt});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: width,
        padding: EdgeInsets.all((avatarRadius * 1 / 3).h),
        decoration: BoxDecoration(
            color: fillColor,
            boxShadow: boxShadow,
            borderRadius: BorderRadius.circular((avatarRadius * 5 / 3).r)),
        child: Row(mainAxisSize: MainAxisSize.min, children: [
          CircleAvatar(
              radius: avatarRadius.r,
              backgroundColor: avatarColor,
              child: SvgPicture.asset(avatarSvg,
                  color: avatarIconColor, height: iconSize, width: iconSize)),
          HelperFunc.sb(8.w),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(headerTxt,
                style: style ??
                    AppTextStyles.mediumText(
                        fontSize: txtFont ?? 14,
                        color: isSelected ? Colors.white : AppColors.grey)),
            if (subTxt != null) HelperFunc.sb(5.h),
            if (subTxt != null)
              Text(subTxt!,
                  style: AppTextStyles.regularText(
                      color: isSelected ? Colors.white : AppColors.grey,
                      fontSize: 10))
          ]),
          HelperFunc.sb((avatarRadius * 1 / 3).w)
        ]),
      ),
    );
  }
}
