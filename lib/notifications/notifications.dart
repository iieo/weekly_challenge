import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workmanager/workmanager.dart';

const checkChallengesTask = "15minCheckTasks";

@pragma(
    'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    switch (task) {
      case checkChallengesTask:
        print("$simpleTaskKey was executed. inputData = $inputData");
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool("test", true);
        print("Bool from prefs: ${prefs.getBool("test")}");
        break;

      case Workmanager.iOSBackgroundTask:
        print("The iOS background fetch was triggered");
        Directory? tempDir = await getTemporaryDirectory();
        String? tempPath = tempDir.path;
        print(
            "You can access other plugins in the background, for example Directory.getTemporaryDirectory(): $tempPath");
        break;
    }

    return Future.value(true);
  });
}

void init() {
  Workmanager().initialize(callbackDispatcher);
  setUpTasks();
}

void setUpTasks() {
  // add tasks here
}

void addChallengeCheckTask() {
  Platform.isAndroid
      ? () {
          Workmanager().registerPeriodicTask(
            checkChallengesTask,
            checkChallengesTask,
            frequency: Duration(minutes: 15),
          );
        }
      : null;
}
