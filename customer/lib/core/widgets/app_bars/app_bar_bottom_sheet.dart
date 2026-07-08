import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/theme/app_textstyle.dart';

class AppBarBottomSheet extends StatelessWidget {
  const AppBarBottomSheet({required this.title, super.key});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: 24,
          height: 24,
          margin: const EdgeInsets.all(8),
        ),
        Text(
          title,
          style: AppTextStyle.headline6
              .copyWith(color: AppColors.black, letterSpacing: -0.01),
        ),
        IconButton(
          padding:
              const EdgeInsets.only(top: 16, right: 0, bottom: 16, left: 16),
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.close,
            color: AppColors.black,
          ),
        ),
      ],
    );
  }
}
