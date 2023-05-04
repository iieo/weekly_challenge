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
