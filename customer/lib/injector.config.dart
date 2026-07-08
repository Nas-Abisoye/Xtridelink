// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter_secure_storage/flutter_secure_storage.dart' as _i558;
import 'package:get_it/get_it.dart' as _i174;
import 'package:http/http.dart' as _i519;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import 'core/helpers/exception/mapper/http_request_exception_mapper.dart'
    as _i789;
import 'core/helpers/preferences/app_preferences.dart' as _i566;
import 'core/network/http_service.dart' as _i720;
import 'core/services/api/file_upload.dart' as _i864;
import 'core/services/api/profile/index.dart' as _i804;
import 'core/services/api/request_helper.dart' as _i672;
import 'core/services/biometrics/index.dart' as _i409;
import 'core/services/location/index.dart' as _i537;
import 'core/services/navigation/index.dart' as _i381;
import 'core/services/socket/index.dart' as _i367;
import 'core/services/storage/index.dart' as _i296;
import 'core/services/updates/index.dart' as _i191;
import 'data/repository/authentication_repository_impl.dart' as _i70;
import 'data/repository/order_repository_impl.dart' as _i547;
import 'data/source/local/authentication_local_source.dart' as _i713;
import 'data/source/remote/authentication_remote_data_source.dart' as _i875;
import 'data/source/remote/model/mapper/error_response_mapper.dart' as _i1041;
import 'data/source/remote/order_remote_datasource.dart' as _i612;
import 'domain/repository/authentication_repository.dart' as _i158;
import 'domain/repository/order_repository.dart' as _i326;
import 'register_module.dart' as _i291;
import 'view/cubit/chat/index.dart' as _i640;
import 'view/cubit/settings/index.dart' as _i302;
import 'view/ui/auth/login/cubit/login_cubit.dart' as _i493;
import 'view/ui/auth/signup/cubit/signup_cubit.dart' as _i444;
import 'view/ui/dashboard/notifications/cubit/notifications_cubit.dart'
    as _i434;
import 'view/ui/dashboard/order/cubit/orders_cubit.dart' as _i383;
import 'view/ui/dashboard/profile/cubit/profile_cubit.dart' as _i543;

// initializes the registration of main-scope dependencies inside of GetIt
Future<_i174.GetIt> $initGetIt(
  _i174.GetIt getIt, {
  String? environment,
  _i526.EnvironmentFilter? environmentFilter,
}) async {
  final gh = _i526.GetItHelper(
    getIt,
    environment,
    environmentFilter,
  );
  final registerModule = _$RegisterModule();
  gh.factory<_i720.HttpService>(() => _i720.HttpService());
  gh.factory<_i409.BiometricsService>(() => _i409.BiometricsService());
  gh.factory<_i191.UpdateServiceImpl>(() => _i191.UpdateServiceImpl());
  gh.factory<_i640.ChatCubit>(() => _i640.ChatCubit());
  gh.factory<_i612.OrderRemoteDatasource>(() => _i612.OrderRemoteDatasource());
  gh.factory<_i1041.ErrorResponseMapper>(() => _i1041.ErrorResponseMapper());
  gh.factory<_i875.AuthenticationRemoteSource>(
      () => _i875.AuthenticationRemoteSource());
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.singleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
  gh.lazySingleton<_i381.NavigationServiceImpl>(
      () => _i381.NavigationServiceImpl());
  gh.lazySingleton<_i519.Client>(() => registerModule.client);
  gh.factory<_i789.HttpRequestExceptionMapper>(
      () => _i789.HttpRequestExceptionMapper(gh<_i1041.ErrorResponseMapper>()));
  gh.lazySingleton<_i326.OrderRepository>(
      () => _i547.OrderRepositoryImpl(gh<_i612.OrderRemoteDatasource>()));
  gh.factory<_i383.OrdersCubit>(
      () => _i383.OrdersCubit(gh<_i326.OrderRepository>()));
  gh.factory<_i566.AppPreferences>(
      () => _i566.AppPreferences(gh<_i460.SharedPreferences>()));
  gh.factory<_i296.StorageServiceImpl>(() =>
      _i296.StorageServiceImpl(storage: gh<_i558.FlutterSecureStorage>()));
  gh.factory<_i864.FileUploadServiceImpl>(() => _i864.FileUploadServiceImpl(
      storageServiceImpl: gh<_i296.StorageServiceImpl>()));
  gh.factory<_i302.SettingsCubit>(() =>
      _i302.SettingsCubit(storageServiceImpl: gh<_i296.StorageServiceImpl>()));
  gh.factory<_i713.AuthenticationLocalSource>(
      () => _i713.AuthenticationLocalSource(gh<_i566.AppPreferences>()));
  gh.factory<_i672.RequestHelpersImpl>(() => _i672.RequestHelpersImpl(
        storageServiceImpl: gh<_i296.StorageServiceImpl>(),
        httpClient: gh<_i519.Client>(),
        navigationServiceImpl: gh<_i381.NavigationServiceImpl>(),
      ));
  gh.lazySingleton<_i158.AuthenticationRepository>(
      () => _i70.AuthenticationRepositoryImpl(
            gh<_i713.AuthenticationLocalSource>(),
            gh<_i875.AuthenticationRemoteSource>(),
          ));
  gh.lazySingleton<_i367.SocketService>(
      () => _i367.SocketService(gh<_i158.AuthenticationRepository>()));
  gh.factory<_i493.LoginCubit>(
      () => _i493.LoginCubit(gh<_i158.AuthenticationRepository>()));
  gh.factory<_i543.ProfileCubit>(
      () => _i543.ProfileCubit(gh<_i158.AuthenticationRepository>()));
  gh.factory<_i434.NotificationsCubit>(
      () => _i434.NotificationsCubit(gh<_i158.AuthenticationRepository>()));
  gh.factory<_i444.SignupCubit>(
      () => _i444.SignupCubit(gh<_i158.AuthenticationRepository>()));
  gh.factory<_i537.LocationMapService>(() => _i537.LocationMapService(
        requestHelpersImpl: gh<_i672.RequestHelpersImpl>(),
        navigationServiceImpl: gh<_i381.NavigationServiceImpl>(),
      ));
  gh.factory<_i804.ProfileApiServiceImpl>(() => _i804.ProfileApiServiceImpl(
      requestHelpers: gh<_i672.RequestHelpersImpl>()));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
