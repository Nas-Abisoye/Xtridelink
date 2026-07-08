import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/core/constants/text_styles.dart';
import 'package:xtridelink_driver/view/components/icon_avatar.dart';
import '../../../../../core/constants/helpers.dart';

class ProfileAction extends StatelessWidget {
  final String avatar, text;
  final Widget? suffixIcon;
  final void Function()? onTap;
  final Color? iconColor, fullColor;
  const ProfileAction(
      {super.key,
      required this.avatar,
      required this.text,
      this.suffixIcon,
      this.fullColor,
      this.onTap,
      this.iconColor});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 15.h),
            decoration: const BoxDecoration(
                color: Colors.transparent,
                border: Border.symmetric(
                    horizontal: BorderSide(color: AppColors.ashBg, width: .5))),
            child: Row(children: [
              IconAvatar(avatar: avatar, color: fullColor ?? iconColor),
              HelperFunc.sb(15.w),
              Text(text,
                      style: AppTextStyles.mediumText(
                          fontSize: 15, color: fullColor))
                  .EXPANDED,
              suffixIcon ??
                  Icon(Icons.keyboard_arrow_right_rounded, color: fullColor)
            ])));
  }
}
