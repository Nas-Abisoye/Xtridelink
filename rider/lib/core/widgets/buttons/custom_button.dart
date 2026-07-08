import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/app_extension.dart';
import 'package:xtridelink_driver/core/theme/app_colors.dart';
import 'package:xtridelink_driver/core/theme/app_textstyle.dart';

import 'animation_button_effect.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    required this.title,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.background = AppColors.primaryColor,
    this.textColor = AppColors.white,
    this.weight = double.infinity,
    this.radius = 8,
    this.icon,
    this.borderColor = AppColors.transparent,
    this.iconIsTrailing = false,
  });
  final Icon? icon;
  final String title;
  final bool isLoading;
  final void Function()? onPressed;
  final Color background;
  final Color borderColor;
  final Color textColor;
  final double weight;
  final double radius;
  final bool iconIsTrailing;

  @override
  Widget build(BuildContext context) {
    return AnimationButtonEffect(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          disabledBackgroundColor: background.withOpacity(0.2),
          disabledForegroundColor: textColor.withOpacity(0.2),
          side: BorderSide(
              color: borderColor == AppColors.transparent
                  ? background
                  : borderColor,
              width: 2),
          elevation: 0,
          shadowColor: AppColors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
          minimumSize: Size(weight, 50),
          backgroundColor: background,
        ),
        onPressed: onPressed,
        child: isLoading
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  color: textColor,
                  strokeWidth: 2,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon == null || iconIsTrailing)
                    const SizedBox()
                  else
                    Row(
                      children: [
                        icon!,
                        10.hSpaceBox,
                      ],
                    ),
                  Text(
                    title,
                    style: AppTextStyle.body1.copyWith(
                      fontSize: 15,
                      color: textColor,
                      letterSpacing: -14 * 0.01,
                    ),
                  ),
                  if (icon == null || !iconIsTrailing)
                    const SizedBox()
                  else
                    Row(
                      children: [
                        10.hSpaceBox,
                        icon!,
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
