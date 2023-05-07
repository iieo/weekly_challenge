import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weekly_challenge/components/dialog.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';

import '../firebase_options.dart';

const String channelUpdates = "Challenges Updates";

Future<void> initNotificationPermission() async {
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    // init on android
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.initialize(androidInitialize);

    var channel = const AndroidNotificationChannel(
      '1',
      'Challenges Updates',
      description: "Keeps you updated with your progress.",
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }
}

void checkChallengesAndShowNotification() async {
  print("in");
  try {
    print("Fehler\n");
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("Fehler1\n");
    if (!FirebaseAuthHandler.isUserLoggedIn()) {}
    print("Fehler2\n");
    if (await FirestoreHandler.isChallengeDoneForToday()) {}
    print("Success\n");
  } catch (e) {
    print("Fehler diesmal auf jeden fall\n");
    print(e);
    return;
  }

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  print("in2");

  if (Platform.isAndroid) {
    // init on android
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.initialize(androidInitialize);

    var channel = const AndroidNotificationChannel(
      '1',
      'Challenges Updates',
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    );

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    await flutterLocalNotificationsPlugin.show(
        1,
        "Check Your Challenges",
        "You have not completed the challenge yet",
        const NotificationDetails(
          android: AndroidNotificationDetails(
            "1",
            "Challanges Updates",
            icon: "launcher_icon",
            priority: Priority.max,
            importance: Importance.max,
            enableVibration: true,
          ),
        ));
  }
}
