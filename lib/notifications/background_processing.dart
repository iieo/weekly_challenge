import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weekly_challenge/notifications/notification_handler.dart';
import 'package:workmanager/workmanager.dart';

const checkChallengesTask = "15minCheckTasks";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    bool worked = false;

    initNotificationPermission();

    try {
      checkChallengesAndShowNotification();
      worked = true;
      print("workes");
    } catch (e) {
      print("asjkldj: $e");
    }

    return Future.value(false);
  });
}

void init_background_checks() {
  Workmanager().initialize(callbackDispatcher, isInDebugMode: true);
  setUpTasks();
}

void setUpTasks() {
  // add tasks here
  addChallengeCheckTask();
}

void addChallengeCheckTask() {
  Workmanager().cancelAll();

  Workmanager().registerPeriodicTask(
    checkChallengesTask,
    checkChallengesTask,
    initialDelay: Duration(seconds: 1),
    frequency: Duration(minutes: 1),
  );

  //Workmanager().registerOneOffTask("uniqueName", "simpleTask");
}
