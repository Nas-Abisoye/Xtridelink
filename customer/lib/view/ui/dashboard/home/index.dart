import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/extensions.dart';
import 'package:xtridelink/core/constants/helpers.dart';
import 'package:xtridelink/view/cubit/profile/index.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';
import 'components/current_orders.dart';
import 'components/home_header.dart';
import 'components/send_now_options.dart';
import 'components/track_package.dart';

import '../../../cubit/order/index.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    context.read<OrdersCubit>().getOrders();
    // context.read<OrdersCubit>().listenToSocket();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        bottom: false,
        child: Column(
          children: [
            HelperFunc.sb(10.h),
            BlocBuilder<ProfileCubit, ProfileState>(builder: (context, state) {
              return HomePageHeader(
                  avatar: '',
                  currentLocation: state.currentUser()?.location ?? '');
            }),
            // OrderTimelineLiveTracking(),

            RefreshIndicator(
              onRefresh: () async => context.read<OrdersCubit>().getOrders(),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    HelperFunc.sb(25.h),
                    const HomeTrackPackage(),
                    HelperFunc.sb(25.h),
                    const HomeSendNowOptions(),
                    HelperFunc.sb(10.h),
                    const HomeCurrentOrders(),
                    HelperFunc.sb(150.h),
                  ],
                ),
              ),
            ).EXPANDED,
          ],
        ));
  }
}
