// ignore_for_file: prefer_const_constructors

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyle extends Equatable {
  /// Headline 1 text style
  static TextStyle get headline1 {
    return GoogleFonts.inter(
      fontSize: 64,
      fontWeight: FontWeight.w700,
    );
  }

  /// Headline 2 text style
  static TextStyle get headline2 {
    return GoogleFonts.inter(
      fontSize: 48,
      fontWeight: FontWeight.w700,
    );
  }

  /// Headline 3 text style
  static TextStyle get headline3 {
    return GoogleFonts.inter(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: AppColors.black,
    );
  }

  /// Headline 4 text style
  static TextStyle get headline4 {
    return GoogleFonts.inter(
      fontSize: 24,
      fontWeight: FontWeight.w700,
    );
  }

  /// Headline 5 text style
  static TextStyle get headline5 {
    return GoogleFonts.inter(
      fontSize: 20,
      fontWeight: FontWeight.w700,
    );
  }

  /// Headline 6 text style
  static TextStyle get headline6 {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w700,
    );
  }

  /// Body 1 text style
  static TextStyle get body1 {
    return GoogleFonts.inter(
      fontSize: 16,
    );
  }

  /// Body 2 text style
  static TextStyle get body2 {
    return GoogleFonts.poppins(
      fontSize: 14,
    );
  }

  /// Subtitle 1 text style
  static TextStyle get subTitle1 {
    return GoogleFonts.inter(
      fontSize: 18,
      fontWeight: FontWeight.w600,
    );
  }

  /// Subtitle 2 text style
  static TextStyle get subTitle2 {
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.w400,
    );
  }

  /// Caption text style
  static TextStyle get caption {
    return GoogleFonts.inter(fontSize: 12);
  }

  static TextStyle get splashText {
    return GoogleFonts.inter(
      fontSize: 14,
      letterSpacing: 8,
      fontWeight: FontWeight.w700,
    );
  }

  @override
  List<Object?> get props => [];
}
