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

  // Add cross-flavor configuration here
  await dotenv.load();

  Environment().initConfig(Environment.dev);
  await configureDependencies();
  // await init();

  PushNotificationService().createChannel();
  PushNotificationService().setNotifications();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const App());
  });
}
