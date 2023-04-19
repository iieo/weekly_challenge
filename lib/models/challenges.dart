import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:weekly_challenge/utils.dart';

class Challenge {
  String? id;
  String title;
  String description;
  bool isCompleted = false;
  Set<String> likedBy;
  Set<String> dislikedBy;
  DateTime? activeSince;
  String? createdBy;
  String? lastUpdatedBy;

  Challenge(
      {this.id,
      required this.title,
      this.createdBy,
      this.lastUpdatedBy,
      this.activeSince,
      this.likedBy = const {},
      this.dislikedBy = const {},
      required this.description}) {
    isCompleted =
        activeSince != null && activeSince!.isBefore(getMondayForWeek(0));
  }

  Challenge.fromMap(this.id, Map<String, dynamic> map)
      : title = map['title'] ?? "",
        createdBy = map['createdBy'] ?? "",
        lastUpdatedBy = map['lastUpdatedBy'] ?? "",
        likedBy = Set.from(map['likedBy'] ?? []),
        dislikedBy = Set.from(map['dislikedBy'] ?? []),
        activeSince = map['activeSince']?.toDate(),
        description = map['description'] ?? "" {
    isCompleted =
        activeSince != null && activeSince!.isBefore(getMondayForWeek(0));
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'createdBy': createdBy,
      'lastUpdatedBy': lastUpdatedBy,
      'likedBy': likedBy.toList(),
      'dislikedBy': dislikedBy.toList(),
      'activeSince':
          activeSince != null ? Timestamp.fromDate(activeSince!) : null,
    };
  }
}
