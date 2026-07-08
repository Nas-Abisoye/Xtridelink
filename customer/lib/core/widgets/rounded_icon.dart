import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

class RoundedIcon extends StatelessWidget {
  const RoundedIcon({
    Key? key,
    this.elevation = 0,
    this.backgroundColor = AppColors.white,
    this.icon,
    this.width,
    this.height,
    this.padding,
  }) : super(key: key);

  final double elevation;
  final Color? backgroundColor;
  final Widget? icon;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Material(
      shape: const CircleBorder(),
      elevation: elevation,
      color: backgroundColor,
      child: Padding(
        padding: padding ?? const EdgeInsets.all(8),
        child: SizedBox(
          width: width ?? 30,
          height: height ?? 30,
          child: icon,
        ),
      ),
    );
  }
}
