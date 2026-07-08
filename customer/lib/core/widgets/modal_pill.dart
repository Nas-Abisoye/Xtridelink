import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

class ModalPill extends StatelessWidget {
  const ModalPill({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 38,
      height: 8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.grey4.withOpacity(0.3),
      ),
    );
  }
}
