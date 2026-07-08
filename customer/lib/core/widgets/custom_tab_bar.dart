import 'package:flutter/material.dart';
import 'package:xtridelink/core/theme/app_colors.dart';
import 'package:xtridelink/core/theme/app_textstyle.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar({
    required this.tabs,
    required this.onTap,
    super.key,
    this.tabController,
    this.isScrollable = false,
  });
  final bool isScrollable;
  final TabController? tabController;
  final List<Tab> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      height: 50,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primaryColor,
        ),
      ),
      child: TabBar(
        isScrollable: isScrollable,
        controller: tabController,
        indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: AppColors.primaryColor),
        labelColor: Colors.white,
        unselectedLabelColor: AppColors.black,
        unselectedLabelStyle: AppTextStyle.body2,
        labelStyle: AppTextStyle.body2,
        tabs: tabs,
        onTap: onTap,
      ),
    );
  }
}
