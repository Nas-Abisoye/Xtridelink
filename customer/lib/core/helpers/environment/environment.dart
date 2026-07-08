import 'package:xtridelink/core/helpers/environment/base_config.dart';
import 'package:xtridelink/core/helpers/environment/environment_configs.dart';

class Environment {
  factory Environment() {
    return _singleton;
  }

  Environment._internal();
  static final Environment _singleton = Environment._internal();

  static const String dev = 'dev';
  static const String staging = 'staging';
  static const String prod = 'prod';

  late BaseConfig config;

  void initConfig(String environment) {
    config = _getConfig(environment);
  }

  BaseConfig _getConfig(String environment) {
    switch (environment) {
      case Environment.prod:
        return ProdConfig();
      case Environment.staging:
        return StagingConfig();
      default:
        return DevConfig();
    }
  }
}
