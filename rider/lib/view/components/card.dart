import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';

import '../../core/constants/colors.dart';
import '../../core/constants/text_styles.dart';

class GlobalCard extends StatelessWidget {
  final VoidCallback onTap;
  final String? nullText, text;
  const GlobalCard(
      {super.key,
      required this.onTap,
      required this.nullText,
      required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
          decoration: BoxDecoration(
              // color: AppColors.grey.withOpacity(.1),
              border: Border.all(color: AppColors.secColor),
              borderRadius: BorderRadius.circular(10.r)),
          child: Row(children: [
            Text(text ?? nullText ?? '',
                    style: AppTextStyles.mediumText(fontSize: 12.5))
                .EXPANDED,
            const Icon(Icons.keyboard_arrow_down, color: AppColors.grey)
          ])),
    );
  }
}
