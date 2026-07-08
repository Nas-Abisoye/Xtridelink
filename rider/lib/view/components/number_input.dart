import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/extensions.dart';
import 'package:xtridelink_driver/view/components/form_field.dart';
import '../../core/constants/colors.dart';

class NumberInput extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final double? width;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;
  const NumberInput(
      {Key? key,
      required this.controller,
      this.width,
      this.focusNode,
      this.validator,
      required this.hintText,
      this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      child: AppFormField(
        hintText: hintText,
        controller: controller,
        onChanged: onChanged,
        keyBoardType: TextInputType.number,
        fillColor: Colors.white,
        focusNode: focusNode,
        validator: validator,
        borderColor: AppColors.secColor,
        suffixWidget: Container(
          height: 42.h,
          width: 22.w,
          margin: EdgeInsets.fromLTRB(5.w, 7.h, 10.w, 7.h),
          child: Column(
            children: [
              GestureDetector(
                      onTap: () {
                        controller.text =
                            '${(int.tryParse(controller.text) ?? 0) + 1}';
                        if (onChanged != null) onChanged!(controller.text);
                      },
                      child: const Icon(Icons.keyboard_arrow_up_rounded))
                  .EXPANDED,
              GestureDetector(
                      onTap: () {
                        if ((int.tryParse(controller.text) ?? 0) > 0) {
                          controller.text =
                              '${(int.tryParse(controller.text) ?? 0) - 1}';
                        }
                        if (onChanged != null) onChanged!(controller.text);
                      },
                      child: const Icon(Icons.keyboard_arrow_down_rounded))
                  .EXPANDED
            ],
          ),
        ),
      ),
    );
  }
}
