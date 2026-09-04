import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/text_styles.dart';

class Tag extends StatelessWidget {
  final String txt;
  final Color? txtColor, color;
  final EdgeInsetsGeometry? padding;
  final double txtFont;
  final void Function()? onTap;
  const Tag(
      {super.key,
      this.padding,
      this.txtFont = 10.5,
      this.txtColor,
      this.color,
      this.onTap,
      this.txt = ''});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding:
              padding ?? EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: color ??
                  (txtColor ?? AppColors.secColor).withValues(alpha: 0.15)),
          child: Text(txt,
              style: AppTextStyles.mediumText(
                  fontSize: txtFont, color: txtColor ?? AppColors.secColor))),
    );
  }
}
