class ChallengeParticipation {
  String? id;
  String challengeId;
  String pariticipantId;
  DateTime dateCompleted;

  ChallengeParticipation(
      {this.id,
      required this.challengeId,
      required this.pariticipantId,
      required this.dateCompleted});

  ChallengeParticipation.fromMap(String id, Map<String, dynamic> map)
      : this(
          id: id,
          challengeId: map['challengeId'],
          pariticipantId: map['pariticipantId'],
          dateCompleted: map['dateCompleted'].toDate(),
        );

  Map<String, dynamic> toMap() {
    return {
      'challengeId': challengeId,
      'pariticipantId': pariticipantId,
      'dateCompleted': dateCompleted,
    };
  }
}
