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
import 'data/repository/authentication_repository_impl.dart' as _i70;
import 'data/source/local/authentication_local_source.dart' as _i713;
import 'data/source/remote/authentication_remote_data_source.dart' as _i875;
import 'data/source/remote/model/mapper/error_response_mapper.dart' as _i1041;
import 'domain/repository/authentication_repository.dart' as _i158;
import 'register_module.dart' as _i291;

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
  gh.factory<_i1041.ErrorResponseMapper>(() => _i1041.ErrorResponseMapper());
  gh.factory<_i875.AuthenticationRemoteSource>(
      () => _i875.AuthenticationRemoteSource());
  await gh.factoryAsync<_i460.SharedPreferences>(
    () => registerModule.prefs,
    preResolve: true,
  );
  gh.singleton<_i558.FlutterSecureStorage>(() => registerModule.storage);
  gh.lazySingleton<_i519.Client>(() => registerModule.client);
  gh.factory<_i789.HttpRequestExceptionMapper>(
      () => _i789.HttpRequestExceptionMapper(gh<_i1041.ErrorResponseMapper>()));
  gh.factory<_i566.AppPreferences>(
      () => _i566.AppPreferences(gh<_i460.SharedPreferences>()));
  gh.factory<_i713.AuthenticationLocalSource>(
      () => _i713.AuthenticationLocalSource(gh<_i566.AppPreferences>()));
  gh.lazySingleton<_i158.AuthenticationRepository>(
      () => _i70.AuthenticationRepositoryImpl(
            gh<_i713.AuthenticationLocalSource>(),
            gh<_i875.AuthenticationRemoteSource>(),
          ));
  return getIt;
}

class _$RegisterModule extends _i291.RegisterModule {}
