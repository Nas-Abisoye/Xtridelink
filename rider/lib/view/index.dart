import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink_driver/core/constants/colors.dart';
import 'package:xtridelink_driver/core/services/storage/index.dart';
import 'package:xtridelink_driver/view/cubit/chat/index.dart';
import 'package:xtridelink_driver/view/cubit/notifications/index.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/order/ongoing_timer.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/cubit/settings/index.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';

import '../core/services/navigation/index.dart';
import '../core/services/navigation/router.dart';
import '../core/services/navigation/routes.dart';
import '../di/get_it.dart';
import 'cubit/auth/index.dart';

class Index extends StatefulWidget {
  const Index({super.key});

  @override
  State<Index> createState() => _IndexState();
}

class _IndexState extends State<Index> {
  late AuthCubit _registerCubit;
  late SettingsCubit _settingsCubit;
  late ProfileCubit _profileCubit;
  late OrderFlowCubit _orderFlowCubit;
  late NotificationsCubit _notificationsCubit;
  late WalletCubit _walletCubit;
  late ChatCubit _chatCubit;
  late OngoingTimerCubit _ongoingTimerCubit;

  @override
  void initState() {
    _registerCubit = getItInst<AuthCubit>();
    _settingsCubit = getItInst<SettingsCubit>();
    _profileCubit = getItInst<ProfileCubit>();
    _orderFlowCubit = getItInst<OrderFlowCubit>();
    _notificationsCubit = getItInst<NotificationsCubit>();
    _walletCubit = getItInst<WalletCubit>();
    _chatCubit = getItInst<ChatCubit>();
    _ongoingTimerCubit = getItInst<OngoingTimerCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _registerCubit.close();
    _settingsCubit.close();
    _profileCubit.close();
    _orderFlowCubit.close();
    _notificationsCubit.close();
    _walletCubit.close();
    _chatCubit.close();
    _ongoingTimerCubit.close();
    super.dispose();
  }

  Future<String> get getRoute async => await getItInst<StorageServiceImpl>()
      .getToken()
      .then((value) => value.isEmpty ? Routes.intro : Routes.base);

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark),
        child: LayoutBuilder(builder: (context, constraints) {
          return OrientationBuilder(builder: (context, orientation) {
            return MultiBlocProvider(
              providers: [
                BlocProvider.value(value: _registerCubit),
                BlocProvider.value(value: _settingsCubit),
                BlocProvider.value(value: _profileCubit),
                BlocProvider.value(value: _orderFlowCubit),
                BlocProvider.value(value: _notificationsCubit),
                BlocProvider.value(value: _walletCubit),
                BlocProvider.value(value: _chatCubit),
                BlocProvider.value(value: _ongoingTimerCubit),
              ],
              child: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (context, _) {
                    return FutureBuilder(
                      builder: (context, snapShot) {
                        return snapShot.data == null
                            ? Container(color: Colors.white)
                            : MaterialApp(
                                navigatorKey: getItInst<NavigationServiceImpl>()
                                    .navigationKey,
                                title: 'Xtridelink Rider',
                                debugShowCheckedModeBanner: false,
                                theme: ThemeData(
                                    scaffoldBackgroundColor: Colors.white,
                                    brightness: Brightness.light,
                                    visualDensity:
                                        VisualDensity.adaptivePlatformDensity,
                                    primarySwatch: AppColors.materialColor),
                                initialRoute: snapShot.data ?? Routes.intro,
                                onGenerateRoute: (settings) =>
                                    CustomRouter.generateRoutes(settings),
                              );
                      },
                      future: getRoute,
                    );
                  }),
            );
          });
        }));
  }
}
