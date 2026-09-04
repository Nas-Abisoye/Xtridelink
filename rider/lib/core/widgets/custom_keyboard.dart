import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/theme/app_colors.dart';
import 'package:xtridelink_driver/core/theme/app_textstyle.dart';

/// Custom keyboard
class CustomKeyBoard extends StatefulWidget {
  /// special key to be displayed on the widget. Default is '.'
  final Widget? specialKey;

  /// on changed function to be called when the amount is changed.
  final void Function(String)? onChanged;

  /// on competed function to be called when the pin code is complete.
  final void Function(String)? onCompleted;

  /// function to be called when special keys are pressed.
  final void Function()? specialKeyOnTap;

  /// maximum length of the amount.
  final int maxLength;

  const CustomKeyBoard({
    super.key,
    required this.maxLength,
    this.specialKey,
    this.onChanged,
    this.specialKeyOnTap,
    this.onCompleted,
  }) : assert(maxLength > 0);
  @override
  _CustomKeyBoardState createState() => _CustomKeyBoardState();
}

class _CustomKeyBoardState extends State<CustomKeyBoard> {
  String value = '';
  Widget buildNumberButton({int? number, Widget? icon, Function()? onPressed}) {
    Widget getChild() {
      if (icon != null) {
        return icon;
      } else {
        return Text(
          number?.toString() ?? '',
          style: AppTextStyle.headline4,
        );
      }
    }

    return Expanded(
      child: CupertinoButton(
        key: icon?.key ?? Key('btn$number'),
        onPressed: onPressed,
        child: getChild(),
      ),
    );
  }

  Widget buildNumberRow(List<int> numbers) {
    final buttonList = numbers
        .map(
          (buttonNumber) => buildNumberButton(
            number: buttonNumber,
            onPressed: () {
              if (value.length < widget.maxLength) {
                setState(() {
                  value = value + buttonNumber.toString();
                });
              }
              widget.onChanged!(value);
              if (value.length >= widget.maxLength &&
                  widget.onCompleted != null) {
                widget.onCompleted!(value);
              }
            },
          ),
        )
        .toList();
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: buttonList,
      ),
    );
  }

  Widget buildSpecialRow() {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildNumberButton(
            icon: widget.specialKey ?? const SizedBox(),
            onPressed: widget.specialKeyOnTap ??
                () {
                  if (value.length < widget.maxLength) {
                    if (!value.contains('.')) {
                      setState(() {
                        value = '$value.';
                      });
                    }
                  }
                  widget.onChanged!(value);
                  if (value.length >= widget.maxLength &&
                      widget.onCompleted != null) {
                    widget.onCompleted!(value);
                  }
                },
          ),
          buildNumberButton(
            number: 0,
            onPressed: () {
              if (value.length < widget.maxLength) {
                setState(() {
                  value = value + 0.toString();
                });
              }
              widget.onChanged!(value);
              if (value.length >= widget.maxLength &&
                  widget.onCompleted != null) {
                widget.onCompleted!(value);
              }
            },
          ),
          buildNumberButton(
            icon: const Icon(
              Icons.backspace,
              key: Key('backspace'),
              color: AppColors.black,
            ),
            onPressed: () {
              if (value.isNotEmpty) {
                setState(() {
                  value = value.substring(0, value.length - 1);
                });
              }
              widget.onChanged!(value);
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Column(
          children: [
            buildNumberRow([1, 2, 3]),
            buildNumberRow([4, 5, 6]),
            buildNumberRow([7, 8, 9]),
            buildSpecialRow(),
          ],
        ),
      ),
    );
  }
}
