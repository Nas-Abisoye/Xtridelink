// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:get_it/get_it.dart';
// import 'package:http/http.dart' as http;
// import 'package:xtridelink/core/services/api/request_helper.dart';
// import 'package:xtridelink/core/services/biometrics/index.dart';
// import 'package:xtridelink/core/services/location/index.dart';
// import 'package:xtridelink/core/services/navigation/index.dart';
// import 'package:xtridelink/core/services/socket/index.dart';
// import 'package:xtridelink/core/services/storage/index.dart';
// import 'package:xtridelink/core/services/updates/index.dart';
// import 'package:xtridelink/view/cubit/auth/index.dart';
// import 'package:xtridelink/view/cubit/chat/index.dart';
// import 'package:xtridelink/view/cubit/notifications/index.dart';
// import 'package:xtridelink/view/cubit/order/index.dart';
// import 'package:xtridelink/view/cubit/profile/index.dart';
// import 'package:xtridelink/view/cubit/settings/index.dart';

// final getIt = GetIt.I;

// Future init() async {
//   FlutterSecureStorage storage = const FlutterSecureStorage();
//   final http.Client client = http.Client();

//   getIt.registerLazySingleton<http.Client>(() => client);

//   //Storage
//   getIt.registerSingleton<FlutterSecureStorage>(storage);
//   getIt.registerLazySingleton<StorageServiceImpl>(
//       () => StorageServiceImpl(storage: getIt()));

//   // BIOMETRICS
//   getIt.registerSingleton<BiometricsService>(BiometricsService());

//   // SOCKET IO
//   getIt.registerLazySingleton<SocketService>(
//       () => SocketService(storageServiceImpl: getIt()));

//   // NAVIGATION
//   getIt.registerLazySingleton<NavigationServiceImpl>(
//       () => NavigationServiceImpl());

//   getIt.registerFactory(() => SettingsCubit(storageServiceImpl: getIt()));

//   // GCP
//   getIt.registerLazySingleton<LocationMapService>(() => LocationMapService(
//       requestHelpersImpl: getIt(), navigationServiceImpl: getIt()));

//   //APi SERVICE
//   getIt.registerSingleton<RequestHelpersImpl>(RequestHelpersImpl(
//       httpClient: getIt(),
//       storageServiceImpl: getIt(),
//       navigationServiceImpl: getIt()));

//   // UPDATE
//   getIt.registerLazySingleton<UpdateServiceImpl>(() => UpdateServiceImpl());

//   getIt.registerFactory(() => ProfileCubit(
//       locationMapService: getIt(),
//       fileUploadServiceImpl: getIt(),
//       profileApiServiceImpl: getIt(),
//       storageServiceImpl: getIt(),
//       navigationServiceImpl: getIt()));

//   getIt.registerFactory(() => OrdersCubit(
//       storageServiceImpl: getIt(),
//       socketService: getIt(),
//       orderApiServiceImpl: getIt(),
//       navigationServiceImpl: getIt()));

//   getIt.registerFactory(() => ChatCubit(orderServiceImpl: getIt()));
// }
