import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:xtridelink/core/helpers/app_extension.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/widgets/app_text.dart';

class ActionItemTileWidget extends StatelessWidget {
  const ActionItemTileWidget({
    super.key,
    required this.label,
    required this.onPressed,
    required this.icon,
  });

  final String label;
  final VoidCallback onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
            color: AppColors.iconLemon.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primaryColor,
                child: icon,
              ),
              16.hSpaceBox,
              Expanded(
                child: AppText(
                  text: label,
                  fontWeight: FontWeight.bold,
                ),
              ),
              16.hSpaceBox,
              const Icon(
                Iconsax.arrow_right,
                color: AppColors.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
