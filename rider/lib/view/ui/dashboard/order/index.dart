import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/services/navigation/index.dart';
import 'package:xtridelink_driver/view/components/button.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import '../../../../core/constants/assets.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/constants/helpers.dart';
import '../../../../core/constants/text_styles.dart';

class OrderDispatch extends StatelessWidget {
  const OrderDispatch({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.user?.isAvailable != current.user?.isAvailable,
      listener: (context, state) {
        if (state.user?.isAvailable ?? false) {
          context.read<OrderFlowCubit>().listenForNewOrders();
        } else {
          context.read<OrderFlowCubit>().stopListeningForNewOrders();
        }
      },
      child: GestureDetector(
        onTap: () async {
          var riderAnalytics =
              context.read<ProfileCubit>().state.riderAnalytics;
          var user = context.read<ProfileCubit>().state.user;
          if (riderAnalytics?.kycVerified.toUpperCase() == 'PENDING') {
            riderAnalytics =
                await context.read<ProfileCubit>().reloadKycStatus();
          }
          if (!context.mounted) return;
          if (user?.isVerified == true) {
            HelperFunc.showFittedBottomSheet(
                context: context,
                child: Column(children: [
                  HelperFunc.sb(5.h),
                  CircleAvatar(
                      radius: 55.r,
                      backgroundColor: AppColors.green.withOpacity(.1),
                      child: SvgPicture.asset(Assets.online)),
                  HelperFunc.sb(25.h),
                  Text('Change your\nrider status',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.semiBold(fontSize: 22)),
                  HelperFunc.sb(10.h),
                  BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) => Text(
                          'Change your status from ${(state.user?.isAvailable ?? false) ? 'online to\noffline' : 'offline to\nonline'} to control your requests',
                          textAlign: TextAlign.center,
                          style: AppTextStyles.regularText(
                              color: AppColors.grey, fontSize: 13))),
                  HelperFunc.sb(50.h),
                  BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) => AppButton(
                          onTap: () {
                            final isAvailable =
                                !(state.user?.isAvailable ?? false);
                            context
                                .read<ProfileCubit>()
                                .updateAvailability(isAvailable);

                            context.read<OrderFlowCubit>().listenForNewOrders();
                          },
                          btnText:
                              'Go ${(state.user?.isAvailable ?? false) ? 'Offline' : 'Online'}',
                          color: (state.user?.isAvailable ?? false)
                              ? AppColors.green
                              : null)),
                  SafeArea(
                      top: false,
                      child: TextButton(
                          onPressed: () => globalPop(),
                          child: Text('Cancel',
                                  style: AppTextStyles.mediumText(
                                      color: Colors.black))
                              .pd(EdgeInsets.symmetric(vertical: 10.h))))
                ]).pd(EdgeInsets.symmetric(horizontal: 20.w)));
          } else if (riderAnalytics?.kycVerified.toUpperCase() == 'FAILED') {
            HelperFunc.toast(
                'KYC submission was rejected. Please reupload your correct documents.');
            return;
          } else if (riderAnalytics?.kycVerified.toUpperCase() == 'PENDING') {
            HelperFunc.toast(
                'KYC verification is still in review. Please wait until it is approved');
            return;
          } else if (riderAnalytics?.kycVerified.toUpperCase() == 'SKIPPED') {
            HelperFunc.toast(
                'KYC submission was skipped. Please upload your kyc documents.');
            return;
          } else {
            HelperFunc.toast('Cannot go online/offline at the moment');
            return;
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) => Container(
                height: 60.w,
                width: 60.w,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: (state.user?.isAvailable ?? false)
                        ? AppColors.green
                        : AppColors.grey.withOpacity(.5),
                    boxShadow: (state.user?.isAvailable ?? false)
                        ? const [
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
                          ]
                        : null),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.order),
                      HelperFunc.sb(3.h),
                      Text(
                          (state.user?.isAvailable ?? false)
                              ? 'Online'
                              : 'Offline',
                          style: AppTextStyles.mediumText(
                              color: Colors.white, fontSize: 10))
                    ]))),
      ),
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
            border: Border.all(
                color: isSelected ? Colors.transparent : AppColors.ashBg),
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
