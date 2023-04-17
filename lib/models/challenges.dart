class Challenge {
  String? id;
  bool isCompleted;
  String title;
  String description;

  Challenge(
      {this.id,
      this.isCompleted = false,
      required this.title,
      required this.description});

  Challenge.fromMap(this.id, Map<String, dynamic> map)
      : isCompleted = map['isCompleted'] ?? false,
        title = map['title'] ?? "",
        description = map['description'] ?? "";

  Map<String, dynamic> toMap() {
    return {
      'isCompleted': isCompleted,
      'title': title,
      'description': description,
    };
  }
}
