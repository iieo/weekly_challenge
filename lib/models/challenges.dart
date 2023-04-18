import 'package:cloud_firestore/cloud_firestore.dart';

class Challenge {
  String? id;
  bool isCompleted;
  String title;
  String description;
  DateTime? activeSince;

  Challenge(
      {this.id,
      this.isCompleted = false,
      required this.title,
      this.activeSince,
      required this.description});

  Challenge.fromMap(this.id, Map<String, dynamic> map)
      : isCompleted = map['isCompleted'] ?? false,
        title = map['title'] ?? "",
        activeSince = map['activeSince']?.toDate(),
        description = map['description'] ?? "";

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
      'title': title,
      'description': description,
      'activeSince':
          activeSince != null ? Timestamp.fromDate(activeSince!) : null,
    };
  }
}
