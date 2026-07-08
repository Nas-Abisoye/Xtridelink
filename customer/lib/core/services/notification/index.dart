import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:xtridelink/domain/repository/authentication_repository.dart';
import '../../../../../../../injector.dart';

import '../../constants/old_assets.dart';
import '../../constants/helpers.dart';
import 'package:audioplayers/audioplayers.dart';

final audioPlayer = AudioPlayer();

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<AndroidNotificationChannel> channel() async {
  return const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', //Title
      description: 'This channel is used for notifications.',
      importance: Importance.max,
      playSound: true,
      enableVibration: true);
}

void showNotification({required RemoteNotification? notification}) async {
  if (notification != null) {
    AndroidNotificationChannel globalChannel = await channel();
    audioPlayer.play(AssetSource(Assets.audio));
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          globalChannel.id,
          globalChannel.name,
          channelDescription: globalChannel.description,
          importance: Importance.max,
          priority: Priority.max,
          icon: 'ic_launcher',
        ),
      ),
    );
  }
}

@pragma('vm:entry-point')
Future<void> onBackgroundMessage(RemoteMessage message) async {
  await Firebase.initializeApp();
  PushNotificationService().createChannel();
  showNotification(notification: message.notification);
  HelperFunc.logger('BackgroundTitle : ${message.notification!.title!}');
  HelperFunc.logger('BackgroundBody : ${message.notification!.body!}');
  HelperFunc.logger('BackgroundData : ${message.data}');
}

class PushNotificationService {
  final _firebaseMessaging = FirebaseMessaging.instance;

  void _addToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      HelperFunc.logger('DEVICE_TOKEN: $token');
      if (token != null) {
        getIt<AuthenticationRepository>().storeFCMDeviceToken(token);
      }
    } catch (e) {
      HelperFunc.logger('DEVICE_TOKEN_ERROR: ${e.toString()}');
    }
  }

  Future<void> setNotifications() async {
    _firebaseMessaging.requestPermission();
    _addToken();
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true, badge: true,
      // sound: true
    );

    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);

    FirebaseMessaging.onMessage.listen(
      (message) async {
        showNotification(notification: message.notification);
        HelperFunc.logger('Title : ${message.notification!.title!}');
        HelperFunc.logger('Body : ${message.notification!.body!}');
        HelperFunc.logger('Data : ${message.data}');
      },
    );

    FirebaseMessaging.instance.onTokenRefresh.listen((token) {
      HelperFunc.logger('DEVICE_TOKEN: $token');
      getIt<AuthenticationRepository>().storeFCMDeviceToken(token);
    });

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        HelperFunc.logger('MESSAGE OPENED APP: ${message.data}');
        // var payLoad = convertPayload(message.data.toString());
      },
    );
  }

  // Map<String, dynamic> convertPayload(String data) {
  //   final String payload = data.substring(1, data.length - 1);
  //   List<String> split = [];
  //
  //   payload.split(',').forEach((String s) => split.addAll(s.split(': ')));
  //   Map<String, dynamic> mapped = {};
  //   for (int i = 0; i < split.length; i++) {
  //     if (i % 2 == 1) {
  //       mapped.addAll({split[i - 1].trim().toString(): split[i].trim()});
  //     }
  //   }
  //   return mapped;
  // }

  Future<void> createChannel() async {
    AndroidInitializationSettings initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');

    DarwinInitializationSettings initializationSettingsIOS =
        const DarwinInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(await channel());

    /// Update the iOS foreground notification presentation options to allow
    /// heads up notifications.
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      // sound: true,
    );
  }
}
