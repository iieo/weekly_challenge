import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:weekly_challenge/models/task.dart';

class TaskManager extends ChangeNotifier {
  File? _taskFile;
  List<Task> tasks = [];

  Future<List<Task>> readTasks() async {
    final directory = await getApplicationDocumentsDirectory();
    _taskFile = File('${directory.path}/tasks.json');

    //create file if it doesn't exist
    if (!_taskFile!.existsSync()) {
      _taskFile!.createSync();
      _taskFile!.writeAsStringSync('[]');
    }

    String jsonData = _taskFile!.readAsStringSync();
    List<dynamic> jsonTasks = jsonDecode(jsonData);

    tasks.clear();
    for (var jsonTask in jsonTasks) {
      tasks.add(Task(
          name: jsonTask['name'],
          category: jsonTask['category'],
          isCompleted: jsonTask['isCompleted'] == 'true',
          dateCompleted: jsonTask['dateCompleted'] == 'null'
              ? null
              : DateTime.fromMillisecondsSinceEpoch(
                  int.parse(jsonTask['dateCompleted']))));
    }
    tasks = tasks
        .where((task) =>
            task.dateCompleted == null ||
            task.dateCompleted!.difference(DateTime.now()).inDays < 1)
        .toList();

    sortTasks();
    return tasks;
  }

  void sortTasks() {
    tasks.sort((a, b) {
      if (a.isCompleted && !b.isCompleted) {
        return 1;
      } else if (!a.isCompleted && b.isCompleted) {
        return -1;
      } else {
        return 0;
      }
    });
  }

  void addTask(Task task) {
    tasks.add(task);
    _writeTasks();
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      task.dateCompleted = DateTime.now();
    } else {
      task.dateCompleted = null;
    }
    sortTasks();
    _writeTasks();
    notifyListeners();
  }

  void removeTask(Task task) {
    tasks.remove(task);
    _writeTasks();
    notifyListeners();
  }

  void deleteAllTasks() {
    tasks.clear();
    _writeTasks();
    notifyListeners();
  }

  void deleteTask(Task task) {
    tasks.remove(task);
    _writeTasks();
    notifyListeners();
  }

  void _writeTasks() {
    List<Map<String, String>> jsonTasks = [];
    for (var task in tasks) {
      jsonTasks.add({
        'name': task.name,
        'category': task.category,
        'isCompleted': task.isCompleted.toString(),
        'dateCompleted':
            task.dateCompleted?.millisecondsSinceEpoch.toString() ?? "null"
      });
    }
    _taskFile!.writeAsStringSync(jsonEncode(jsonTasks));
  }
}
