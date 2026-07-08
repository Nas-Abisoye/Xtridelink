import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';

class IconAvatar extends StatelessWidget {
  final String avatar;
  final double? radius, iconSize;
  final Color? color, fillColor;
  final void Function()? onTap;
  const IconAvatar(
      {super.key,
      required this.avatar,
      this.fillColor,
      this.color,
      this.radius,
      this.onTap,
      this.iconSize});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          backgroundColor:
              fillColor ?? color?.withOpacity(.08) ?? AppColors.lightSec,
          radius: (radius ?? 19).r,
          child: SvgPicture.asset(avatar,
              color: color ?? AppColors.secColor,
              height: iconSize,
              width: iconSize)),
    );
  }
}
