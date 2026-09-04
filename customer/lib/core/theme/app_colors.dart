// import 'dart:ui';

import 'package:flutter/material.dart';

class AppColors {
  const AppColors._();

  //Pyramid Green
  static const primaryColor = Color(0xff0a6e4f);

  //Icon lemon
  static const iconLemon = Color(0xff66b93b);

  //Background green
  static const backgroundGreen = Color(0xff0d2121);

  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);
  static const transparent = Color(0x00000000);

  //Neutral Colors
  static const grey1 = Color(0xffe8e8e8);
  static const grey2 = Color(0xffa8a8a8);
  static const grey3 = Color(0xff6a7276);
  static const grey4 = Color(0xff535353);

  static LinearGradient appgradient = LinearGradient(
      begin: FractionalOffset(0.03, 0),
      end: FractionalOffset(0.9, 0.2),
      tileMode: TileMode.mirror,
      colors: [Color.fromARGB(255, 9, 93, 52), AppColors.primaryColor]);

  static List<BoxShadow> defaultBoxShadow = [
    BoxShadow(
      color: Colors.grey.withValues(alpha: 0.2),
      spreadRadius: 0,
      blurRadius: 16,
      offset: const Offset(0, -4),
    ),
  ];
  static List<BoxShadow> yellowBoxShadow = [
    BoxShadow(
      color: Colors.amber.withValues(alpha: 0.8),
      spreadRadius: 0,
      blurRadius: 16,
      offset: const Offset(0, -4),
    ),
  ];

  static const Color contentColorBlack = Colors.black;
  static const Color contentColorWhite = Colors.white;
  static const Color contentColorBlue = Color(0xFF2196F3);
  static const Color contentColorYellow = Color(0xFFFFC300);
  static const Color contentColorOrange = Color(0xFFFF683B);
  static const Color contentColorGreen = Color(0xFF3BFF49);
  static const Color contentColorPurple = Color(0xFF6E1BFF);
  static const Color contentColorPink = Color(0xFFFF3AF2);
  static const Color contentColorRed = Color(0xFFE80054);
  static const Color contentColorCyan = Color(0xFF50E4FF);
}
