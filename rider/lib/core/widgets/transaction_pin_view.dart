import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/app_extension.dart';
import 'package:xtridelink_driver/core/theme/app_textstyle.dart';
import 'package:xtridelink_driver/core/widgets/custom_keyboard.dart';
import 'package:xtridelink_driver/core/widgets/pin_code_field.dart';

class PinCodeView extends StatefulWidget {
  const PinCodeView({
    super.key,
    required this.onPinEntered,
    this.pinLength = 4,
    required this.title,
  });

  final String title;
  final void Function(String pin) onPinEntered;
  final int pinLength;

  @override
  State<PinCodeView> createState() => _PinCodeViewState();
}

class _PinCodeViewState extends State<PinCodeView> {
  String pin = '';
  int maxLength = 0;

  @override
  void initState() {
    maxLength = widget.pinLength;
    super.initState();
  }

  bool get pinComplete => pin.length == maxLength;

  void _onPinChanged(String value) {
    setState(() {
      pin = value;
      if (pinComplete) {
        widget.onPinEntered(pin);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          widget.title,
          style: AppTextStyle.body1,
        ),
        20.vSpaceBox,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < maxLength; i++)
              PinCodeField(
                key: Key('pinField$i'),
                pin: pin,
                pinCodeFieldIndex: i,
              ),
          ],
        ),
        20.vSpaceBox,
        CustomKeyBoard(
          maxLength: maxLength,
          onChanged: _onPinChanged,
        ),
      ],
    );
  }
}
