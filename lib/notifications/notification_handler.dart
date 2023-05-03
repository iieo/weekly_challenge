import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> hasNotificationPermission() async {
  // Obtain shared preferences.
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? hasPermission = prefs.getBool('hasNotificationPermission');
  if (bool == null) {
    return false;
  } else {
    return hasPermission!;
  }
}

Future<void> setNotificationPermission() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.setBool('hasNotificationPermission', true);
}

Future<void> initNotificationPermission() async {
  /*if (await hasNotificationPermission()) {
    return;
  }*/

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  if (Platform.isAndroid) {
    await Permission.notification.isDenied.then((value) {
      if (value) {
        Permission.notification.request();
      }
    });

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();

    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        importance: Importance.high, priority: Priority.high);
    const platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
  } else if (Platform.isLinux) {
    const linuxInitialize =
        LinuxInitializationSettings(defaultActionName: "test");

    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            LinuxFlutterLocalNotificationsPlugin>()
        ?.initialize(linuxInitialize);
  } else {
    return;
  }

  flutterLocalNotificationsPlugin.show(1, "test", "body", null);
}
