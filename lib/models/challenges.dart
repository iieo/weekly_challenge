class Challenge {
  String id;
  bool isCompleted;
  String title;
  String description;

  Challenge(
      {required this.id,
      this.isCompleted = false,
      required this.title,
      required this.description});
}
