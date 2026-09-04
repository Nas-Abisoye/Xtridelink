import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppText extends StatelessWidget {
  final double size;
  final FontWeight? fontWeight;
  final String text;
  final Color? color;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final TextTheme? textTheme;
  final double? letterSpacing;

  const AppText(
      {super.key,
      this.size = 16,
      this.fontWeight = FontWeight.w400,
      this.textAlign = TextAlign.left,
      required this.text,
      this.textTheme,
      this.overflow,
      this.letterSpacing = 1,
      this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overflow,
      textAlign: textAlign,
      style: GoogleFonts.roboto(
        color: color,
        fontSize: size,
        fontWeight: fontWeight,
        // letterSpacing: letterSpacing,
        textStyle: Theme.of(context).textTheme.bodyLarge,
      ),
    );
  }
}
