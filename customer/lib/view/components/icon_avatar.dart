import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/colors.dart';

class IconAvatar extends StatelessWidget {
  final String avatar;
  final double? radius, iconSize;
  final Color? color, circleColor;
  final VoidCallback? onTap;
  const IconAvatar(
      {super.key,
      this.onTap,
      required this.avatar,
      this.circleColor,
      this.iconSize,
      this.color,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(
          backgroundColor:
              circleColor ?? color?.withOpacity(.08) ?? AppColors.lightSec,
          radius: (radius ?? 19).r,
          child: SvgPicture.asset(avatar,
              color: color ?? AppColors.secColor,
              height: iconSize,
              width: iconSize)),
    );
  }
}
