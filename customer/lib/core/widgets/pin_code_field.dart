import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

/// PinCodeField
class PinCodeField extends StatelessWidget {
  const PinCodeField({
    required this.pin,
    required this.pinCodeFieldIndex,
    super.key,
  });

  /// The pin code
  final String pin;

  /// The index of the pin code field
  final int pinCodeFieldIndex;

  Color get getFillColorFromIndex {
    if (pin.length > pinCodeFieldIndex) {
      return AppColors.primaryColor;
    } else if (pin.length == pinCodeFieldIndex) {
      return Colors.blue;
    }
    return AppColors.grey4;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: 12,
      width: 12,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: getFillColorFromIndex,
        // borderRadius: BorderRadius.zero,
        shape: BoxShape.circle,
      ),
      duration: const Duration(microseconds: 40000),
      child: pin.length > pinCodeFieldIndex
          ? const Icon(
              Icons.circle,
              color: AppColors.primaryColor,
              size: 12,
            )
          : const SizedBox(),
    );
  }
}
