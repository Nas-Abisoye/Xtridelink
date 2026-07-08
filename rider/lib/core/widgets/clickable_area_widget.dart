import 'package:flutter/material.dart';

class ClickableAreaWidget extends StatelessWidget {
  const ClickableAreaWidget(
      {Key? key, required this.child, required this.onTap, this.borderRadius});

  final Widget child;
  final Function() onTap;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }
}
