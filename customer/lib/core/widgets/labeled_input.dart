import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:xtridelink/core/helpers/app_helper.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

class LabeledInputField extends StatefulWidget {
  const LabeledInputField({
    required this.label,
    required this.onChanged,
    this.errorText,
    this.counter,
    this.hintStyle,
    this.validator,
    this.keyboardType,
    this.obscureText = false,
    this.placeholder,
    this.labelColor,
    this.maxLength,
    this.height,
    this.autofillHints,
    this.style,
    this.inputFormatters,
    this.suffixIcon,
    this.labelWidget,
    this.minLines,
    this.maxLines,
    this.onInit,
    this.controller,
    this.enabled = true,
    this.prefixIcon,
    this.readOnly,
    this.hintText,
    this.formkey,
    this.onTap,
    this.focusNode,
    this.initialValue,
    this.floatingLabelBehavior,
    this.autoValidateMode,
  });

  final int? minLines;
  final GlobalKey<FormFieldState>? formkey;
  final int? maxLines;
  final int? maxLength;
  final String label;
  final String? Function(String?)? validator;
  final bool? readOnly;
  final String? hintText;
  final Widget? labelWidget;
  final Function()? onInit;
  final Function(String text) onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Text? placeholder;
  final Color? labelColor;
  final double? height;
  final List<String>? autofillHints;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;
  final String? initialValue;
  final Widget? counter;
  final bool enabled;
  final FocusNode? focusNode;
  final Function()? onTap;
  final FloatingLabelBehavior? floatingLabelBehavior;
  final AutovalidateMode? autoValidateMode;

  @override
  State<LabeledInputField> createState() => _LabeledInputFieldState();
}

class _LabeledInputFieldState extends State<LabeledInputField> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      ((time) {
        if (widget.onInit != null) {
          widget.onInit!();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelWidget ??
            Text(
              widget.label,
            ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          // height: widget.height,
          child: TextFormField(
            key: widget.formkey,
            // initialValue: widget.initialValue,
            controller: widget.controller,
            focusNode: widget.focusNode,
            minLines: widget.minLines ?? 1,
            onTap: widget.onTap,
            readOnly: widget.readOnly ?? false,
            maxLines: widget.maxLines ?? 1,
            validator: widget.validator,
            autofillHints: widget.autofillHints,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            maxLength: widget.maxLength,
            initialValue:
                widget.controller != null ? null : widget.initialValue,
            style: widget.style ?? const TextStyle(color: AppColors.grey4),
            autovalidateMode: widget.autoValidateMode,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              errorText: widget.errorText,
              hintText: widget.hintText,
              hintStyle: widget.hintStyle,
              label: widget.placeholder,
              enabled: widget.enabled,
              floatingLabelBehavior: widget.floatingLabelBehavior,
              disabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                  width: 1,
                  color: AppColors.grey2,
                ),
                borderRadius: BorderRadius.circular(
                  12,
                ),
              ),
              prefixIcon: widget.prefixIcon,
              suffixIcon: widget.suffixIcon,
              counter: widget.counter ?? const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledModalInputForm extends StatefulWidget {
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String label;
  final Widget? labelWidget;
  final Function()? onInit;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Text? placeholder;
  final Color? labelColor;
  final double? height;
  final List<String>? autofillHints;
  final TextStyle? style;
  final Widget? suffix;
  final TextEditingController? controller;

  const LabeledModalInputForm({
    Key? key,
    required this.label,
    this.keyboardType,
    this.obscureText = false,
    this.placeholder,
    this.labelColor,
    this.maxLength,
    this.height,
    this.autofillHints,
    this.style,
    this.suffix,
    this.labelWidget,
    this.minLines,
    this.maxLines,
    this.onInit,
    this.controller,
    this.validator,
  }) : super(key: key);

  @override
  State<LabeledModalInputForm> createState() => _LabeledModalInputFormState();
}

class _LabeledModalInputFormState extends State<LabeledModalInputForm> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      ((time) {
        if (widget.onInit != null) {
          widget.onInit!();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelWidget ??
            Text(
              widget.label,
            ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          // height: widget.height,
          child: TextFormField(
            // initialValue: widget.initialValue,
            controller: widget.controller,
            minLines: widget.minLines ?? 1,
            maxLines: widget.maxLines ?? 1,
            autofillHints: widget.autofillHints,
            keyboardType: widget.keyboardType,
            obscureText: widget.obscureText,

            validator: widget.validator,
            maxLength: widget.maxLength,
            style: widget.style ?? const TextStyle(color: AppColors.grey4),
            decoration: InputDecoration(
              label: widget.placeholder,
              suffix: widget.suffix,
              counter: const SizedBox(),
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledInputFieldPassword extends StatefulWidget {
  const LabeledInputFieldPassword({
    Key? key,
    required this.label,
    required this.onChanged,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.placeholder,
    this.labelColor,
    this.height,
    this.autofillHints,
    this.style,
  }) : super(key: key);

  final String label;
  final Function(String text) onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final Text? placeholder;
  final Color? labelColor;
  final double? height;
  final List<String>? autofillHints;
  final TextStyle? style;

  @override
  State<LabeledInputFieldPassword> createState() =>
      _LabeledInputFieldPasswordState();
}

class _LabeledInputFieldPasswordState extends State<LabeledInputFieldPassword> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: widget.labelColor ?? AppColors.grey4),
        ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          child: TextFormField(
            autofillHints: widget.autofillHints,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            style: widget.style ?? const TextStyle(color: AppColors.grey4),
            decoration: InputDecoration(
              errorText: widget.errorText,
              label: widget.placeholder,
              suffixIcon: widget.obscureText
                  ? const Icon(Icons.visibility)
                  : const Icon(Icons.visibility_off),
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledAmountInputField extends StatelessWidget {
  const LabeledAmountInputField({
    Key? key,
    required this.label,
    required this.onChanged,
    this.onTap,
    this.counter,
    this.errorText,
    this.style,
    this.counterText,
    this.enabled = true,
    this.placeholder,
    this.suffixIcon,
    this.validator,
    this.readOnly = false,
    this.inputFormatters,
    this.hintText,
    this.formKey,
    this.controller,
    this.decoration,
    this.initialValue,
    this.autoValidateMode,
    this.onFieldSubmitted,
  }) : super(key: key);

  final String label;
  final Function(String text) onChanged;
  final Function()? onTap;
  final String? errorText;
  final String? counterText;
  final bool enabled;
  final Widget? placeholder;
  final Widget? suffixIcon;
  final Widget? counter;
  final TextStyle? style;
  final String? Function(String?)? validator;
  final bool readOnly;
  final String? hintText;
  final List<TextInputFormatter>? inputFormatters;
  final Key? formKey;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final String? initialValue;
  final AutovalidateMode? autoValidateMode;
  final Function(String)? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
        ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          // height: 54,
          child: TextFormField(
            key: formKey,
            initialValue: initialValue,
            controller: controller,
            inputFormatters: inputFormatters ??
                [
                  CurrencyTextInputFormatter(
                    NumberFormat.currency(
                      locale: Platform.localeName,
                      decimalDigits: 2,
                      symbol: '',
                    ),
                  ),
                ],
            onChanged: (value) {
              onChanged.call(AppHelper.cleanAmountString(value));
            },
            onFieldSubmitted: onFieldSubmitted,
            onTap: onTap,
            validator: validator,
            autovalidateMode: autoValidateMode,
            readOnly: readOnly,
            decoration: decoration ??
                InputDecoration(
                  enabled: enabled,
                  errorText: errorText,
                  counterText: counterText,
                  label: placeholder,
                  suffixIcon: suffixIcon,
                  hintText: hintText,
                  hintStyle: Theme.of(context).textTheme.titleSmall,
                ),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
          ),
        ),
      ],
    );
  }
}

class LabeledModalInputField extends StatelessWidget {
  final String label;
  final bool enabled;
  final Text? placeholder;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final TextEditingController? controller;

  const LabeledModalInputField({
    Key? key,
    required this.label,
    this.enabled = true,
    this.placeholder,
    this.suffixIcon,
    this.controller,
    this.validator,
    this.keyboardType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          // height: 54,
          child: TextFormField(
            validator: validator,
            // inputFormatters: <TextInputFormatter>[
            //   CurrencyTextInputFormatter(
            //     locale: 'en',
            //     decimalDigits: 0,
            //     symbol: 'N',
            //   ),
            // ],
            controller: controller,
            decoration: InputDecoration(
              enabled: enabled,
              label: placeholder,
              suffixIcon: suffixIcon,
            ),
            keyboardType: keyboardType,
          ),
        ),
      ],
    );
  }
}

class AccountNumberInputField extends StatefulWidget {
  const AccountNumberInputField({
    Key? key,
    required this.label,
    required this.onChanged,
    required this.counter,
    this.errorText,
    this.keyboardType,
    this.obscureText = false,
    this.placeholder,
    this.labelColor,
    this.maxLength,
    this.height,
    this.autofillHints,
    this.enabled = true,
    this.readOnly = false,
    this.style,
    this.suffix,
    this.labelWidget,
    this.minLines,
    this.maxLines,
    this.onInit,
    this.controller,
    this.onTap,
    this.validator,
    this.formKey,
  }) : super(key: key);

  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final String label;
  final String? Function(String?)? validator;
  final Widget? labelWidget;
  final Function()? onInit;
  final Function(String text) onChanged;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final bool enabled;
  final bool readOnly;
  final Text? placeholder;
  final Color? labelColor;
  final Function()? onTap;
  final double? height;
  final List<String>? autofillHints;
  final TextStyle? style;
  final Widget? suffix;
  final Widget counter;
  final TextEditingController? controller;
  final Key? formKey;

  @override
  State<AccountNumberInputField> createState() =>
      _AccountNumberInputFieldState();
}

class _AccountNumberInputFieldState extends State<AccountNumberInputField> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      ((time) {
        if (widget.onInit != null) {
          widget.onInit!();
        }
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.labelWidget ??
            Text(
              widget.label,
            ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          // height: widget.height,
          child: TextFormField(
            key: widget.formKey,
            // initialValue: widget.initialValue,
            enabled: widget.enabled,
            onTap: widget.onTap,
            controller: widget.controller,
            validator: widget.validator,
            minLines: widget.minLines ?? 1,
            maxLines: widget.maxLines ?? 1,
            readOnly: widget.readOnly,
            autofillHints: widget.autofillHints,
            keyboardType: widget.keyboardType,
            onChanged: widget.onChanged,
            obscureText: widget.obscureText,
            maxLength: widget.maxLength,
            style: widget.style ?? const TextStyle(color: AppColors.grey4),
            decoration: InputDecoration(
              errorText: widget.errorText,
              label: widget.placeholder,
              suffix: widget.suffix,
              counter: widget.counter,
            ),
          ),
        ),
      ],
    );
  }
}

class LoadingAmountInputField extends StatelessWidget {
  const LoadingAmountInputField({
    Key? key,
    required this.label,
    this.message,
  }) : super(key: key);

  final String label;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          child: TextFormField(
            readOnly: true,
            initialValue: message ?? "Loading...",
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.pending_actions),
            ),
          ),
        ),
      ],
    );
  }
}

class LabeledDropdownField extends StatefulWidget {
  const LabeledDropdownField({
    Key? key,
    required this.label,
    required this.onChanged,
    this.errorText,
  }) : super(key: key);

  final String label;
  final Function(String text) onChanged;
  final String? errorText;

  @override
  State<LabeledDropdownField> createState() => _LabeledDropdownFieldState();
}

class _LabeledDropdownFieldState extends State<LabeledDropdownField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: Theme.of(context).textTheme.titleSmall,
        ),
        const SizedBox(
          height: 7,
        ),
        SizedBox(
          height: 54,
          child: Container(
            padding: const EdgeInsets.all(17),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [const Text('Cash')],
            ),
          ),
        ),
      ],
    );
  }
}
