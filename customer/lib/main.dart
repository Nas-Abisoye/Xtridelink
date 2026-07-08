import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:xtridelink/core/helpers/environment/environment.dart';
import 'package:xtridelink/injector.dart';
import 'package:xtridelink/view/ui/app/app.dart';
import 'core/services/notification/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Load .env if present; tolerate a missing file so a clean build still boots.
  try {
    await dotenv.load();
  } catch (_) {}

  // Select the environment at build time: `--dart-define=ENV=prod` (or staging);
  // defaults to dev. Prevents release builds from silently shipping dev config.
  const env = String.fromEnvironment('ENV', defaultValue: Environment.dev);
  Environment().initConfig(env);
  await configureDependencies();
  // await init();

  PushNotificationService().createChannel();
  PushNotificationService().setNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const App());
  });
}
