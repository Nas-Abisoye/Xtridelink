import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'package:xtridelink/core/helpers/app_extension.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/theme/app_textstyle.dart';

// class UnderlinedBorderTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final Widget? suffixIcon;
//   final Widget? prefixIcon;
//   final bool? obscure;
//   final TextEditingController? textController;
//   final void Function(String)? onChanged;
//   final VoidCallback? onTap;
//   final String? Function(String?)? validation;
//   final TextInputType? inputType;
//   final String? initialText;
//   final String? descriptionText;
//   final bool readOnly;
//   final bool isError;
//   final bool isSuccess;
//   final TextCapitalization? textCapitalization;
//   final TextInputAction? textInputAction;

//   const UnderlinedBorderTextField({
//     Key? key,
//     required this.label,
//     this.suffixIcon,
//     this.prefixIcon,
//     this.onTap,
//     this.obscure,
//     this.validation,
//     this.onChanged,
//     this.textController,
//     this.inputType,
//     this.initialText,
//     this.descriptionText,
//     this.readOnly = false,
//     this.isError = false,
//     this.isSuccess = false,
//     this.textCapitalization,
//     this.textInputAction,
//     this.hint = 'Type here',
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null)
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label!,
//                 style: AppTextStyle.caption.copyWith(
//                   color: AppColors.black,
//                 ),
//               ),
//             ],
//           ),
//         8.vSpaceBox,
//         TextFormField(
//           onTap: onTap,
//           onChanged: onChanged,
//           obscureText: !(obscure ?? true),
//           obscuringCharacter: '*',
//           controller: textController,
//           validator: validation,
//           style: AppTextStyle.body1.copyWith(
//             fontSize: 15.sp,
//             color: AppColors.black,
//           ),
//           cursorWidth: 1,
//           cursorColor: AppColors.black,
//           keyboardType: inputType,
//           initialValue: initialText,
//           readOnly: readOnly,
//           textCapitalization:
//               textCapitalization ?? TextCapitalization.sentences,
//           textInputAction: textInputAction,
//           decoration: InputDecoration(
//             suffixIconConstraints:
//                 BoxConstraints(maxHeight: 30.h, maxWidth: 30.h),
//             suffixIcon: suffixIcon,
//             hintText: hint,
//             hintStyle: AppTextStyle.body1.copyWith(
//               fontSize: 13,
//               color: AppColors.hintColor,
//             ),
//             contentPadding: REdgeInsets.symmetric(horizontal: 0, vertical: 8),
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             fillColor: AppColors.black,
//             filled: false,
//             enabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             errorBorder: UnderlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             border: const UnderlineInputBorder(),
//             focusedErrorBorder: const UnderlineInputBorder(),
//             disabledBorder: UnderlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             focusedBorder: const UnderlineInputBorder(),
//             prefixIcon: prefixIcon,
//           ),
//         ),
//         if (descriptionText != null)
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               4.vSpaceBox,
//               Text(
//                 descriptionText!,
//                 style: AppTextStyle.caption.copyWith(
//                   letterSpacing: -0.3,
//                   color: isError
//                       ? AppColors.red
//                       : isSuccess
//                           ? AppColors.bgGrey
//                           : AppColors.black,
//                 ),
//               ),
//             ],
//           )
//       ],
//     );
//   }
// }

// class OutlinedBorderTextField extends StatelessWidget {
//   final String? label;
//   final String? hint;
//   final Widget? suffixIcon;
//   final bool? obscure;
//   final TextEditingController? textController;
//   final Function(String)? onChanged;
//   final VoidCallback? onTap;
//   final String? Function(String?)? validation;
//   final TextInputType? inputType;
//   final String? initialText;
//   final String? descriptionText;
//   final bool readOnly;
//   final bool isError;
//   final bool isSuccess;
//   final int? minLines;
//   final int? maxLines;
//   final TextCapitalization? textCapitalization;
//   final TextInputAction? textInputAction;

//   const OutlinedBorderTextField({
//     Key? key,
//     required this.label,
//     this.suffixIcon,
//     this.onTap,
//     this.obscure,
//     this.validation,
//     this.onChanged,
//     this.textController,
//     this.inputType,
//     this.initialText,
//     this.descriptionText,
//     this.readOnly = false,
//     this.isError = false,
//     this.isSuccess = false,
//     this.textCapitalization,
//     this.textInputAction,
//     this.hint = 'Type here',
//     this.minLines,
//     this.maxLines,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         if (label != null)
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 label!,
//                 style: AppTextStyle.body1.copyWith(
//                   fontSize: 12,
//                   color: AppColors.black,
//                 ),
//               ),
//               5.vSpaceBox,
//             ],
//           ),
//         TextFormField(
//           onTap: onTap,
//           onChanged: onChanged,
//           obscureText: !(obscure ?? true),
//           obscuringCharacter: '*',
//           controller: textController,
//           validator: validation,
//           style: AppTextStyle.body1.copyWith(
//             fontSize: 16.sp,
//             color: AppColors.black,
//           ),
//           cursorWidth: 1,
//           minLines: minLines,
//           maxLines: maxLines,
//           cursorColor: AppColors.black,
//           keyboardType: inputType,
//           initialValue: initialText,
//           readOnly: readOnly,
//           textCapitalization:
//               textCapitalization ?? TextCapitalization.sentences,
//           textInputAction: textInputAction,
//           decoration: InputDecoration(
//             suffixIconConstraints:
//                 BoxConstraints(maxHeight: 30.h, maxWidth: 30.h),
//             suffixIcon: suffixIcon,
//             hintText: hint,
//             hintStyle: AppTextStyle.body1.copyWith(
//               fontSize: 13,
//               color: AppColors.hintColor,
//             ),
//             contentPadding: REdgeInsets.symmetric(horizontal: 12, vertical: 12),
//             floatingLabelBehavior: FloatingLabelBehavior.always,
//             fillColor: AppColors.black,
//             filled: false,
//             enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             errorBorder: OutlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             border: const OutlineInputBorder(),
//             focusedErrorBorder: const OutlineInputBorder(),
//             disabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide.merge(
//                     const BorderSide(color: AppColors.differBorderColor),
//                     const BorderSide(color: AppColors.differBorderColor))),
//             focusedBorder: const OutlineInputBorder(),
//           ),
//         ),
//         if (descriptionText != null)
//           Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               4.vSpaceBox,
//               Text(
//                 descriptionText!,
//                 style: AppTextStyle.caption.copyWith(
//                   letterSpacing: -0.3,
//                   color: isError
//                       ? AppColors.red
//                       : isSuccess
//                           ? AppColors.bgGrey
//                           : AppColors.black,
//                 ),
//               ),
//             ],
//           )
//       ],
//     );
//   }
// }

class CustomTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool obscure;
  final TextEditingController? textController;
  final void Function(String)? onChanged;
  final VoidCallback? onTap;
  final String? Function(String?)? validation;
  final TextInputType? inputType;
  final String? initialText;
  final String? descriptionText;
  final bool readOnly;
  final bool isError;
  final bool isSuccess;
  final int? minLines;
  final int? maxLines;
  final TextCapitalization? textCapitalization;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextField({
    Key? key,
    this.label,
    this.suffixIcon,
    this.prefixIcon,
    this.onTap,
    this.obscure = false,
    this.validation,
    this.onChanged,
    this.textController,
    this.inputType,
    this.initialText,
    this.descriptionText,
    this.readOnly = false,
    this.isError = false,
    this.isSuccess = false,
    this.textCapitalization,
    this.textInputAction,
    this.hint = 'Type here',
    this.minLines,
    this.maxLines = 1,
    this.inputFormatters,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label!,
                style: AppTextStyle.body1.copyWith(
                  fontSize: 12,
                  color: AppColors.black,
                ),
              ),
              5.vSpaceBox,
            ],
          ),
        TextFormField(
          cursorColor: AppColors.primaryColor,
          onTap: onTap,
          onChanged: onChanged,
          obscureText: obscure,
          obscuringCharacter: '*',
          controller: textController,
          validator: validation,
          textAlignVertical: TextAlignVertical.center,
          style: AppTextStyle.body1.copyWith(
            fontSize: 14,
            color: AppColors.black,
            fontWeight: FontWeight.w600,
          ),
          cursorWidth: 1,
          minLines: minLines,
          maxLines: maxLines,
          keyboardType: inputType,
          initialValue: initialText,
          readOnly: readOnly,
          inputFormatters: inputFormatters,
          //autovalidateMode: AutovalidateMode.always,
          textCapitalization:
              textCapitalization ?? TextCapitalization.sentences,
          textInputAction: textInputAction,
          decoration: InputDecoration(
            prefixIcon: prefixIcon,
            suffixIconConstraints:
                const BoxConstraints(maxHeight: 30, maxWidth: 30),
            suffixIcon: Padding(
              padding: const EdgeInsets.only(right: 12),
              child: suffixIcon,
            ),
            hintText: hint,
            hintStyle: AppTextStyle.body1.copyWith(
              fontSize: 13,
              color: AppColors.grey3,
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            fillColor: AppColors.grey1.withOpacity(0.4),
            filled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.grey3)),
          ),
        ),
        if (descriptionText != null)
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              4.vSpaceBox,
              Text(
                descriptionText!,
                style: AppTextStyle.caption.copyWith(
                  letterSpacing: -0.3,
                  color: isError
                      ? Colors.red
                      : isSuccess
                          ? AppColors.grey3
                          : AppColors.black,
                ),
              ),
            ],
          )
      ],
    );
  }
}

class CustomDatePickerField extends StatefulWidget {
  const CustomDatePickerField({
    required this.onDateofBirthSet,
    super.key,
    this.label,
    this.descriptionText,
    this.isError,
  });

  final String? label;
  final String? descriptionText;
  final bool? isError;
  final ValueChanged<String> onDateofBirthSet;

  @override
  State<CustomDatePickerField> createState() => _CustomDatePickerFieldState();
}

class _CustomDatePickerFieldState extends State<CustomDatePickerField> {
  final _textController = TextEditingController();
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      label: widget.label,
      textController: _textController,
      prefixIcon: const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(child: Icon(Icons.calendar_month)),
      ),
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime.utc(1900),
          lastDate: DateTime.now(),
        );
        if (date != null) {
          _textController.text = _dateFormat.format(date);
          widget.onDateofBirthSet(_dateFormat.format(date));
        }
      },
      hint: 'DD-MM-YYYY',
      readOnly: true,
      descriptionText: widget.descriptionText,
      isError: widget.isError ?? false,
      // validation: (dob) {
      //   if (dob == null) {
      //     return 'Please pick a date';
      //   }
      //   return null;
      // },
    );
  }
}
