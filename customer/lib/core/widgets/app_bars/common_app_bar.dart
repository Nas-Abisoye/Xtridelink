import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';

class CommonAppBar extends StatelessWidget {
  final Widget child;
  final double height;
  final bool isSearchPage;

  const CommonAppBar({
    Key? key,
    required this.child,
    this.height = 76,
    this.isSearchPage = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height +
          ((MediaQuery.of(context).padding.top > 34)
              ? 34
              : MediaQuery.of(context).padding.top),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryColor,
            AppColors.primaryColor,
            AppColors.iconLemon,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: isSearchPage ? 10 : 20,
          ),
          child: DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .titleSmall!
                .copyWith(color: Colors.white),
            child: child,
          ),
        ),
      ),
    );
  }
}
