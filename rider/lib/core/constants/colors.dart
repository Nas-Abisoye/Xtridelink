import 'package:flutter/material.dart';

class AppColors{
  static const Color lightSec = Color(0xffE7F1F3);
  static const Color midSec = Color(0xffB5D4DB);
  static const Color lightPri = Color(0xffFEF0F0);
  static const Color secColor = Color(0xff076E87);
  static const Color grey = Color(0xff666666);
  static const Color ashBg = Color(0xffF8F8F8);
  static const Color green = Color(0xff3AC808);
  static const Color yellow = Color(0xffF9F368);
  static const Color red = Color(0xffCE0303);

  static const MaterialColor materialColor =  MaterialColor(
    0xffF1636A,
    <int, Color>{
      50: Color(0xfff7a1a6),//10%
      100: Color(0xfff59297),//20%
      200: Color(0xfff48288),//30%
      300: Color(0xfff27379),//40%
      400: Color(0xfff1636a),//50%
      500: Color(0xffd9595f),//60%
      600: Color(0xffc14f55),//70%
      700: Color(0xffa9454a),//80%
      800: Color(0xff913b40),//90%
      900: Color(0xff793235),//100%
    },
  );
}