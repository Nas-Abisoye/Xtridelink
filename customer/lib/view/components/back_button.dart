import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../core/constants/old_assets.dart';
import '../../core/services/navigation/index.dart';

class AppBackButton extends StatelessWidget {
  final Color? color;
  final void Function()? onTap;
  const AppBackButton({Key? key, this.color, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onTap ?? () => globalPop(),
        child: SvgPicture.asset(Assets.backArrow,
            semanticsLabel: 'Back Button', color: color));
  }
}
