import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

class ActionButton extends StatelessWidget {
  const ActionButton({
    required this.text,
    required this.onPressed,
    this.icon,
    this.child,
    this.color,
    this.textColor,
    this.borderRadius,
    this.textStyle,
    this.borderSide,
    super.key,
  });

  final String text;
  final Widget? icon;
  final Widget? child;
  final Color? color;
  final Color? textColor;
  final double? borderRadius;
  final Function()? onPressed;
  final TextStyle? textStyle;
  final BorderSide? borderSide;

  @override
  Widget build(BuildContext context) {
    final subtitle1 = Theme.of(context)
        .textTheme
        .titleSmall
        ?.copyWith(color: AppColors.white);

    var decoration = BoxDecoration(
      color: color ?? AppColors.primaryColor,
      borderRadius: BorderRadius.circular(borderRadius ?? 0),
    );
    if (onPressed == null) {
      decoration = BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(8),
      );
    }

    return Material(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius ?? 8),
          side: borderSide ?? BorderSide.none),
      child: InkWell(
        key: key,
        onTap: onPressed,
        child: Ink(
          decoration: decoration,
          width: double.infinity,
          height: 48,
          child: child ??
              Row(
                mainAxisAlignment: icon == null
                    ? MainAxisAlignment.center
                    : MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: icon == null
                        ? EdgeInsets.zero
                        : const EdgeInsets.only(left: 36),
                    child: Text(
                      text,
                      style: textColor == null
                          ? textStyle ?? subtitle1
                          : textStyle ?? subtitle1?.copyWith(color: textColor),
                    ),
                  ),
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 23.29),
                      child: icon!,
                    ),
                ],
              ),
        ),
      ),
    );
  }
}
