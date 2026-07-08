import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:xtridelink/core/widgets/header_background_widget.dart';

const bigFlex = 14;

class SimpleHeaderWidget extends StatelessWidget {
  ///Background height (in percentage)
  final double? heightPercent;
  final String title;
  final bool showBackButton;
  final Widget? trailing;
  final Function()? onClose;
  final Color? closeIconColor;

  const SimpleHeaderWidget(
      {Key? key,
      this.heightPercent,
      required this.title,
      this.showBackButton = true,
      this.trailing,
      this.onClose,
      this.closeIconColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        HeaderBackgroundWidget(
          heightPercent: heightPercent ?? 19,
        ),
        Padding(
          padding: EdgeInsets.only(left: 24, top: 30),
          child: Row(
            children: [
              if (showBackButton) BackButton(),
              const Spacer(),
              Text(title),
              const Spacer(flex: bigFlex),
              if (trailing != null) trailing!,
              if (onClose != null)
                GestureDetector(onTap: onClose, child: CloseButton()),
              if (onClose != null) const SizedBox(width: 24)
            ],
          ),
        )
      ],
    );
  }
}
