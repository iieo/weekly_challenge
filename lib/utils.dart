import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

extension BrighterDarkerColor on Color {
  Color brighter() {
    return Color.fromARGB(
      alpha,
      (red + 255) ~/ 2,
      (green + 255) ~/ 2,
      (blue + 255) ~/ 2,
    );
  }

  Color darker() {
    return Color.fromARGB(
      alpha,
      red ~/ 2,
      green ~/ 2,
      blue ~/ 2,
    );
  }
}

extension ToDateString on DateTime {
  String toDateString() {
    return '$day.$month.$year';
  }
}

enum DataType { account, member, orchestraMEmber, bill }

bool isValidDate(String date) {
  return RegExp(r"[0-2]{0,1}[0-9]{1}\.[0-1]?[0-9]{1}\.[0-9]{2,4}")
          .hasMatch(date.trim()) ||
      RegExp(r"[0-2]{0,1}[0-9]{1}-[0-1]?[0-9]{1}-[0-9]{2,4}")
          .hasMatch(date.trim()) ||
      RegExp(r"[0-2]{0,1}[0-9]{1}/[0-1]?[0-9]{1}/[0-9]{2,4}")
          .hasMatch(date.trim());
}

DateTime? parseDate(String date) {
  if (isValidDate(date)) {
    date = date.trim().replaceAll("/", ".").replaceAll("-", ".");
    List<String> parts = date.split(".");
    return DateTime(
        int.parse(parts[2]), int.parse(parts[1]), int.parse(parts[0]));
  } else {
    //assert(false, "Invalid date: $date");
    return null;
  }
}

int parseInt(dynamic value) {
  if (value is int) {
    return value;
  } else if (value is String) {
    return int.parse(value);
  } else if (value is Timestamp) {
    return value.seconds;
  } else {
    throw Exception("Invalid type: $value");
  }
}

DateTime? parseDateTime(dynamic value) {
  if (value is Timestamp) {
    return DateTime.fromMillisecondsSinceEpoch(value.millisecondsSinceEpoch);
  } else if (value is String) {
    return parseDate(value) ??
        DateTime.fromMillisecondsSinceEpoch(parseInt(value));
  } else if (value is int) {
    return DateTime.fromMillisecondsSinceEpoch(value);
  } else if (value is DateTime) {
    return value;
  } else {
    return null;
  }
}

DateTime getMondayForWeek(int weeksSinceNow) {
  DateTime nextMonday = DateTime.now();
  nextMonday = DateTime(nextMonday.year, nextMonday.month, nextMonday.day);

  while (nextMonday.weekday != 1) {
    nextMonday = nextMonday.subtract(const Duration(days: 1));
  }
  nextMonday = nextMonday.add(Duration(days: 7 * weeksSinceNow));
  return nextMonday;
}

String getWeekdayNameByNumber(int weekday) {
  switch (weekday) {
    case 1:
      return "Montag";
    case 2:
      return "Dienstag";
    case 3:
      return "Mittwoch";
    case 4:
      return "Donnerstag";
    case 5:
      return "Freitag";
    case 6:
      return "Samstag";
    case 7:
      return "Sonntag";
    default:
      return "Fehler";
  }
}

List<Color> colorPalette = [
  Colors.amber,
  const Color(0xffaa4cfc),
  const Color(0xff27b6fc),
  const Color(0xff888888),
  const Color(0xffb74093),
  const Color(0xff2c3e50),
  const Color(0xffe74c3c),
  const Color(0xff2ecc71),
  const Color(0xff3498db),
  const Color(0xff9b59b6),
  const Color(0xff1abc9c),
];
