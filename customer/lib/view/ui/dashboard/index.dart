import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/core/constants/old_assets.dart';
import 'package:xtridelink/core/constants/text_styles.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/home/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/order_dispatch.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/track/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';

import '../../../../../../../injector.dart';
import '../../../core/services/updates/index.dart';
import '../../cubit/settings/index.dart';
import 'order/pages/order_history/order_history_page.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late ValueNotifier<int> tabIdx;

  @override
  void initState() {
    context.read<SettingsCubit>().loadSettings();
    tabIdx = ValueNotifier(0);
    context.read<ProfileCubit>().getUserDetails();
    context.read<ProfileCubit>().updateDeviceToken();
    context.read<OrdersCubit>().getOrders();
    _checkForUpdate();
    super.initState();
  }

  @override
  void dispose() {
    tabIdx.dispose();
    super.dispose();
  }

  void _checkForUpdate() async {
    await getIt<UpdateServiceImpl>().updateIfAny();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              ValueListenableBuilder(
                  valueListenable: tabIdx,
                  builder: (context, value, _) {
                    return IndexedStack(index: value, children: [
                      HomePage(),
                      OrderHistoryPage(),
                      TrackPage(),
                      ProfilePage()
                    ]);
                  }),
              // ValueListenableBuilder(
              //     valueListenable: tabIdx,
              //     builder: (context, value, _) {
              //       return tabs[value];
              //     }),
              Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: ClipRRect(
                      child: BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                          child: SafeArea(
                              top: false,
                              child: SizedBox(
                                  width: double.infinity, height: 45.h))))),
              Positioned(
                  left: 20.w,
                  right: 20.w,
                  bottom: 5.h,
                  child: BottomNavigationBar(tabIdx: tabIdx))
            ],
          ),
        ));
  }
}

/// Bottom navigation widget
class BottomNavigationBar extends StatelessWidget {
  final ValueNotifier<int> tabIdx;
  const BottomNavigationBar({super.key, required this.tabIdx});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 5.w),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.01),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0)),
              BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 10,
                  offset: const Offset(0, 0))
            ],
            borderRadius: BorderRadius.circular(100.r)),
        child: ValueListenableBuilder(
            valueListenable: tabIdx,
            builder: (context, int value, _) {
              return Row(
                children: [
                  BottomNavItem(
                      svg: Assets.home,
                      txt: 'Home',
                      color: value == 0
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      // onTap: () => HelperFunc.showCustomBottomSheet(
                      //   showBackButton: false,
                      //   height: MediaQuery.of(context).size.height * .9,
                      //   context: context,
                      //   child: const TimelineChatSheet()),
                      onTap: () => tabIdx.value = 0
                      // onTap: ()=> context.read<OrdersCubit>().setPaymentVerification(reference: 'reference'),
                      ),
                  BottomNavItem(
                      svg: Assets.history,
                      txt: 'History',
                      color: value == 1
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 1),
                  OrderDispatch(),
                  BottomNavItem(
                      svg: Assets.track,
                      txt: 'Track',
                      color: value == 2
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 2),
                  BottomNavItem(
                      svg: Assets.profile,
                      txt: 'Profile',
                      color: value == 3
                          ? AppColors.secColor
                          : AppColors.grey.withOpacity(0.5),
                      onTap: () => tabIdx.value = 3),
                ],
              );
            }),
      ),
    );
  }
}

/// Single bottom navigation item widget
class BottomNavItem extends StatelessWidget {
  final String svg, txt;
  final Color color;
  final void Function() onTap;
  const BottomNavItem(
      {super.key,
      required this.svg,
      required this.txt,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          color: Colors.transparent,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(svg, color: color),
              HelperFunc.sb(3.h),
              Text(txt,
                  style: AppTextStyles.mediumText(color: color, fontSize: 10))
            ],
          ),
        ),
      ),
    );
  }
}
