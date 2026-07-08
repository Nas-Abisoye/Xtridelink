import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class AppTextStyles {
  static TextStyle regularText(
      {double fontSize = 12.5,
        Color? color}) {
    return TextStyle(
        fontSize: fontSize.sp,
        fontFamily: 'LIGHT',
        color: color);
  }

  static TextStyle mediumText(
      {double fontSize = 14, Color? color}) {
    return TextStyle(
        // fontWeight: FontWeight.w600,
        fontFamily: 'MEDIUM',
        fontSize: fontSize.sp,
        color: color);
  }

  static TextStyle semiBold(
      {double fontSize = 18, Color? color}) {
    return TextStyle(
        // fontWeight: FontWeight.w700,
      fontFamily: 'BOLD',
        fontSize: fontSize.sp,
        color: color);
  }

  static TextStyle boldText(
      {double fontSize = 20, Color? color}) {
    return TextStyle(
        // fontWeight: FontWeight.bold,
        fontFamily: 'HEAVY',
        fontSize: fontSize.sp,
        color: color);
  }
}
