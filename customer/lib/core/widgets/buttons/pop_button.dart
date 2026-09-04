import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'animation_button_effect.dart';

class PopButton extends StatelessWidget {
  final VoidCallback? onTap;

  const PopButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ??
          () {
            Navigator.pop(context);
          },
      child: AnimationButtonEffect(
        child: Container(
          decoration: const BoxDecoration(
              color: AppColors.black,
              borderRadius: BorderRadius.all(Radius.circular(10))),
          padding: const EdgeInsets.all(14),
          child: const Icon(
            Icons.keyboard_arrow_left,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
