import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/text_styles.dart';

import '../../core/constants/strings.dart';

class CustomPhoneInput extends StatelessWidget {
  final TextEditingController? controller;
  final Widget? suffixWidget;
  final String? suffixIcon, dialCode;
  final EdgeInsetsGeometry? contentPadding;
  final void Function(PhoneNumber)? onInputChanged;
  const CustomPhoneInput(
      {Key? key,
      this.controller,
      this.suffixIcon,
      this.suffixWidget,
      this.dialCode,
      this.contentPadding,
      this.onInputChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      initialValue: PhoneNumber(isoCode: 'NG', dialCode: dialCode),
      maxLength: 12,
      locale: GlobalStrings.naira,
      textFieldController: controller,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      keyboardType: TextInputType.phone,
      textStyle: AppTextStyles.regularText(fontSize: 13),
      inputBorder: InputBorder.none,
      validator: (value) =>
          (value ?? '').isNotEmpty ? null : 'Invalid phone number',
      inputDecoration: InputDecoration(
        suffixIcon: suffixWidget ??
            (suffixIcon == null
                ? null
                : Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
                    child: SvgPicture.asset(suffixIcon!))),
        // labelText: 'Phone Number',
        hintText: 'Phone, Number',
        hintStyle:
            AppTextStyles.regularText(color: Colors.black.withOpacity(0.5)),
        // labelStyle:
        //     AppTextStyles.regularText(color: Colors.black.withOpacity(0.5)),
        contentPadding: contentPadding ??
            EdgeInsets.symmetric(vertical: 15.h, horizontal: 15.w),
        border: InputBorder.none,
        fillColor: AppColors.grey.withOpacity(0.1),
        filled: true,
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: BorderSide.none),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: AppColors.secColor)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.r),
            borderSide: const BorderSide(color: Colors.red)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: AppColors.secColor),
        ),
      ),
      selectorConfig: SelectorConfig(
          showFlags: true,
          leadingPadding: 12.w,
          setSelectorButtonAsPrefixIcon: true,
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET),
      onInputChanged: onInputChanged,
    );
  }
}
