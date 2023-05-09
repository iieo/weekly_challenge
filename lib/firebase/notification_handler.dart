// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:weekly_challenge/components/dialog.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/firebase_options.dart';
import 'package:weekly_challenge/models/challenge_participation.dart';

class NotificationHandler {
  static final FlutterLocalNotificationsPlugin plugin =
      FlutterLocalNotificationsPlugin();

  static void init() {
    FirebaseMessaging.onMessage.listen(_handleMessage);

    //print token
    FirebaseMessaging.instance.getToken().then((token) {
      print("FirebaseMessaging token: $token");
    });
  }

  static Future<void> _handleMessage(RemoteMessage message) async {
    print('Handling a background message ${message.messageId}');
    _handleChallengeNotification(message);
  }

  static Future<void> _handleChallengeNotification(
      RemoteMessage message) async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (!FirebaseAuthHandler.isUserLoggedIn()) {
      print("User not logged in: no notification sent");
      return;
    }
    if (await FirestoreHandler.isChallengeDoneForToday()) {
      print("Challenge done: no notification sent");
      return;
    }
    await _requestPermission();
    await _createChallengeChannel();
    await _showChallengeNotification(message);
  }

  static Future<void> _showChallengeNotification(RemoteMessage message) async {
    await plugin.show(
      0,
      message.notification!.title,
      message.notification!.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          "1",
          "Challenges Updates",
          icon: '@mipmap/ic_launcher',
          priority: Priority.high,
          importance: Importance.high,
          enableLights: true,
          enableVibration: true,
        ),
      ),
    );
  }

  static Future<void> _createChallengeChannel() async {
    const androidInitialize =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      '1',
      'Challenges Updates',
      description: "Keeps you updated with your progress.",
      importance: Importance.high,
      enableLights: true,
      enableVibration: true,
    );
    final resolvedImplementation = plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();

    if (resolvedImplementation == null) {
      print("couldn't resolve implementation");
      return;
    }

    await resolvedImplementation.initialize(androidInitialize);

    await resolvedImplementation.createNotificationChannel(channel);
  }

  static Future<void> _requestPermission() async {
    await Permission.notification.isDenied.then((value) async {
      if (value) {
        await Permission.notification.request();
      }
    });
  }
}
