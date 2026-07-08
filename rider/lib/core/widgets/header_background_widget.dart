import 'package:flutter/material.dart';
import 'package:xtridelink_driver/core/helpers/app_helper.dart';
import 'package:xtridelink_driver/core/theme/app_colors.dart';

class HeaderBackgroundWidget extends StatelessWidget {
  const HeaderBackgroundWidget({
    Key? key,
    required this.heightPercent,
    this.child,
    this.backgroundColor,
  }) : super(key: key);

  ///Background height (in percentage)
  final double heightPercent;
  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    ///Compare the heightPercentage to screen height
    final collapsedHeight = AppHelper.getHeightPagePercentage(
      context,
      heightPercent / 100,
    );

    return Container(
      height: collapsedHeight,
      width: double.infinity,
      color: backgroundColor,
      decoration: backgroundColor == null
          ? const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.black]))
          : null,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (child != null)
              Align(alignment: Alignment.topLeft, child: child!)
          ],
        ),
      ),
    );
  }
}

class HeaderBackgroundStaticWidget extends StatelessWidget {
  const HeaderBackgroundStaticWidget({
    Key? key,
    this.child,
    this.backgroundColor,
  }) : super(key: key);

  final Widget? child;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: backgroundColor,
      decoration: backgroundColor == null
          ? const BoxDecoration(
              gradient: LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.black]))
          : null,
      child: SizedBox(
        width: double.infinity,
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (child != null)
              Align(alignment: Alignment.topLeft, child: child!)
          ],
        ),
      ),
    );
  }
}
