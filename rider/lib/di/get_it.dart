import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:xtridelink_driver/core/services/api/auth/index.dart';
import 'package:xtridelink_driver/core/services/api/file_upload/index.dart';
import 'package:xtridelink_driver/core/services/api/notification/index.dart';
import 'package:xtridelink_driver/core/services/api/order/index.dart';
import 'package:xtridelink_driver/core/services/api/profile/index.dart';
import 'package:xtridelink_driver/core/services/biometrics/index.dart';
import 'package:xtridelink_driver/view/cubit/chat/index.dart';
import 'package:xtridelink_driver/view/cubit/notifications/index.dart';
import 'package:xtridelink_driver/view/cubit/order/index.dart';
import 'package:xtridelink_driver/view/cubit/order/ongoing_timer.dart';
import 'package:xtridelink_driver/view/cubit/profile/index.dart';
import 'package:xtridelink_driver/view/cubit/settings/index.dart';
import 'package:xtridelink_driver/view/cubit/wallet/index.dart';
import '../core/services/api/profile/bank.dart';
import '../core/services/api/request_helper.dart';
import '../core/services/api/wallet/index.dart';
import '../core/services/location/index.dart';
import '../core/services/navigation/index.dart';
import '../core/services/socket/index.dart';
import '../core/services/storage/index.dart';
import '../core/services/updates/index.dart';
import '../view/cubit/auth/index.dart';

final getItInst = GetIt.I;

Future init() async {
  FlutterSecureStorage storage = const FlutterSecureStorage();
  final http.Client client = http.Client();
  getItInst.registerLazySingleton<http.Client>(() => client);

  //Storage
  getItInst.registerSingleton<FlutterSecureStorage>(storage);
  getItInst.registerLazySingleton<StorageServiceImpl>(
      () => StorageServiceImpl(storage: getItInst()));

  // BIOMETRICS
  getItInst.registerSingleton<BiometricsService>(BiometricsService());

  // NAVIGATION
  getItInst.registerLazySingleton<NavigationServiceImpl>(
      () => NavigationServiceImpl());

  //APi SERVICE
  getItInst.registerSingleton<RequestHelpersImpl>(RequestHelpersImpl(
      navigationServiceImpl: getItInst(),
      httpClient: getItInst(),
      storageServiceImpl: getItInst()));

  // UPDATE
  getItInst.registerLazySingleton<UpdateServiceImpl>(() => UpdateServiceImpl());

  // SOCKET IO
  getItInst
      .registerLazySingleton<SocketService>(() => SocketService(getItInst()));

  // GCP
  getItInst.registerLazySingleton<LocationMapService>(() => LocationMapService(
      requestHelpersImpl: getItInst(),
      socketService: getItInst(),
      storageServiceImpl: getItInst()));

  // API SERVICE
  getItInst.registerLazySingleton<BankServiceImpl>(() =>
      BankServiceImpl(httpClient: getItInst(), requestHelpers: getItInst()));

  getItInst.registerLazySingleton<AuthApiServiceImpl>(() => AuthApiServiceImpl(
      requestHelpers: getItInst(), storageServiceImpl: getItInst()));

  getItInst.registerLazySingleton<ProfileApiServiceImpl>(
      () => ProfileApiServiceImpl(requestHelpers: getItInst()));

  getItInst.registerLazySingleton<OrderApiServiceImpl>(
      () => OrderApiServiceImpl(requestHelpers: getItInst()));

  getItInst.registerLazySingleton<NotificationApiServiceImpl>(
      () => NotificationApiServiceImpl(requestHelpers: getItInst()));

  getItInst.registerLazySingleton<FileUploadServiceImpl>(
      () => FileUploadServiceImpl(storageServiceImpl: getItInst()));

  getItInst.registerLazySingleton<WalletServiceImpl>(
      () => WalletServiceImpl(requestHelpers: getItInst()));

  // CUBIT
  getItInst.registerFactory(() => AuthCubit(
      authApiServiceImpl: getItInst(), navigationServiceImpl: getItInst()));

  getItInst
      .registerFactory(() => SettingsCubit(storageServiceImpl: getItInst()));

  getItInst.registerFactory(() => ProfileCubit(
      profileApiServiceImpl: getItInst(),
      locationMapService: getItInst(),
      navigationServiceImpl: getItInst(),
      fileUploadServiceImpl: getItInst(),
      authApiServiceImpl: getItInst(),
      storageServiceImpl: getItInst(),
      bankAccountServiceImpl: getItInst()));

  getItInst.registerFactory(() => ChatCubit(
        orderServiceImpl: getItInst(),
      ));

  getItInst.registerFactory(() => OrderFlowCubit(
      locationMapService: getItInst(),
      storageServiceImpl: getItInst(),
      socketService: getItInst(),
      orderApiServiceImpl: getItInst(),
      navigationServiceImpl: getItInst()));

  getItInst.registerFactory(() => OngoingTimerCubit(
      orderApiServiceImpl: getItInst(), navigationServiceImpl: getItInst()));

  getItInst.registerFactory(() => WalletCubit(
      walletServiceImpl: getItInst(), navigationServiceImpl: getItInst()));

  getItInst.registerFactory(() => NotificationsCubit(
      notificationApiServiceImpl: getItInst(),
      navigationServiceImpl: getItInst()));
}
