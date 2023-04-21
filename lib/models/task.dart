//only saved locally

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/material.dart';

class Task {
  final String name;
  bool isCompleted;
  DateTime? dateCompleted;
  final String category;

  Task(
      {required this.name,
      this.category = "default",
      this.isCompleted = false,
      this.dateCompleted});

  @override
  String toString() {
    return 'Task{name: $name, category: $category}';
  }
}

class TaskManager extends ChangeNotifier {
  File? _taskFile;
  List<Task>? _tasks;

  Future<List<Task>> get tasks async {
    _tasks ??= await _readTasks();
    return _tasks!;
  }

  Future<List<Task>> _readTasks() async {
    final directory = await getApplicationDocumentsDirectory();
    _taskFile = File('${directory.path}/tasks.json');

    //create file if it doesn't exist
    if (!_taskFile!.existsSync()) {
      _taskFile!.createSync();
      _taskFile!.writeAsStringSync('[]');
    }

    String jsonData = _taskFile!.readAsStringSync();
    List<dynamic> jsonTasks = jsonDecode(jsonData);

    List<Task> tasks = [];
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
    return tasks;
  }

  void addTask(Task task) {
    _tasks!.add(task);
    _readTasks();
    _writeTasks();
    notifyListeners();
  }

  void toggleTask(Task task) {
    task.isCompleted = !task.isCompleted;
    if (task.isCompleted) {
      task.dateCompleted = DateTime.now();
    }
    _tasks!.remove(task);
    _tasks!.add(task);
    _writeTasks();
    notifyListeners();
  }

  void removeTask(Task task) {
    _tasks!.remove(task);
    _writeTasks();
    notifyListeners();
  }

  void deleteAllTasks() {
    _tasks!.clear();
    _writeTasks();
    notifyListeners();
  }

  void _writeTasks() {
    List<Map<String, String>> jsonTasks = [];
    for (var task in _tasks!) {
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
