class Participant {
  String id;
  String name;
  String? profilePictureUrl;
  int points;

  Participant(
      {required this.id,
      required this.name,
      this.profilePictureUrl,
      this.points = 0});
}
