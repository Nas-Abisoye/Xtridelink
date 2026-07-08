import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:xtridelink/core/constants/colors.dart';
import 'package:xtridelink/core/services/navigation/index.dart';
import 'package:xtridelink/core/services/navigation/router.dart';
import 'package:xtridelink/core/services/navigation/routes.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/cubit/order/index.dart';
import 'package:xtridelink/view/cubit/settings/index.dart';
import 'package:xtridelink/view/ui/dashboard/notifications/cubit/notifications_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/order/cubit/orders_cubit.dart';
import 'package:xtridelink/view/ui/dashboard/profile/cubit/profile_cubit.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  late SettingsCubit _settingsCubit;
  late ProfileCubit _profileCubit;
  // late OrdersCubit _OrdersCubit;
  late NotificationsCubit _notificationsCubit;
  late OrdersCubit _orderCubit;

  @override
  void initState() {
    _settingsCubit = getIt<SettingsCubit>();
    _profileCubit = getIt<ProfileCubit>();
    // _OrdersCubit = getIt<OrdersCubit>();
    _orderCubit = getIt<OrdersCubit>();
    _notificationsCubit = getIt<NotificationsCubit>();
    super.initState();
  }

  @override
  void dispose() {
    _settingsCubit.close();
    _profileCubit.close();
    // _OrdersCubit.close();
    _orderCubit.close();
    _notificationsCubit.close();
    super.dispose();
  }

  Future<String> get getRoute async {
    final accessToken = getIt<AuthenticationRepository>().getAccessToken();
    if (accessToken != null) {
      return Routes.base;
    }
    return Routes.intro;
  }

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
                BlocProvider.value(value: _settingsCubit),
                BlocProvider.value(value: _profileCubit),
                // BlocProvider.value(value: _OrdersCubit),
                BlocProvider.value(value: _notificationsCubit),
                BlocProvider.value(value: _orderCubit),
              ],
              child: ScreenUtilInit(
                  designSize: const Size(375, 812),
                  minTextAdapt: true,
                  splitScreenMode: true,
                  builder: (context, _) {
                    return FutureBuilder(
                        future: getRoute,
                        builder: (context, snapShot) {
                          return snapShot.data == null
                              ? Container(color: Colors.white)
                              : MaterialApp(
                                  navigatorKey: getIt<NavigationServiceImpl>()
                                      .navigationKey,
                                  title: 'Xtridelink',
                                  debugShowCheckedModeBanner: false,
                                  theme: ThemeData(
                                      scaffoldBackgroundColor: Colors.white,
                                      brightness: Brightness.light,
                                      visualDensity:
                                          VisualDensity.adaptivePlatformDensity,
                                      // fontFamily: 'LIGHT',
                                      primarySwatch: AppColors.materialColor),
                                  initialRoute: snapShot.data ?? Routes.intro,
                                  onGenerateRoute: (settings) =>
                                      CustomRouter.generateRoutes(settings),
                                );
                        });
                  }),
            );
          });
        }));
  }
}
