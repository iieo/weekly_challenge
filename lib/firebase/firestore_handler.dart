import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weekly_challenge/models/challenge_participation.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:weekly_challenge/utils.dart';

class FirestoreHandler extends ChangeNotifier {
  String token = "";
  List<Challenge> challenges = [];
  List<ChallengeParticipation> challengeParticipations = [];
  List<Participant> participants = [];
  Participant participant = Participant.loadingParticipant;
  bool? isDoneForToday;

  Future<void> _fetchChallenges() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('challenges').get();
    challenges = querySnapshot.docs
        .map((e) => Challenge.fromMap(e.id, e.data()))
        .toList();
  }

  Future<void> addChallenge(Challenge challenge) async {
    challenge.createdBy = FirebaseAuth.instance.currentUser!.uid;
    challenge.lastUpdatedBy = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('challenges')
        .add(challenge.toMap());
    challenges.add(challenge);
    notifyListeners();
  }

  Future<void> updateChallenge(Challenge challenge) async {
    challenge.lastUpdatedBy = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challenge.id)
        .update(challenge.toMap());

    challenges =
        challenges.map((e) => e.id == challenge.id ? challenge : e).toList();

    notifyListeners();
  }

  Future<void> deleteChallenge(Challenge challenge) async {
    await FirebaseFirestore.instance
        .collection('challenges')
        .doc(challenge.id)
        .delete();
    challenges.removeWhere((element) => element.id == challenge.id);
    notifyListeners();
  }

  Future<void> _fetchParticipant(User user) async {
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      throw Exception('User not found');
    }

    participant =
        Participant.fromMap(documentSnapshot.id, documentSnapshot.data()!);
  }

  Future<void> _fetchToken() async {
    token = await FirebaseAuth.instance.currentUser!.getIdToken();
  }

  Future<void> uploadProfilePicture(Uint8List? data, String name) async {
    if (data == null) return;
    String extension = name.split('.').last;
    String userId = FirebaseAuth.instance.currentUser!.uid;
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child("users/$userId/profilePicture.$extension");
    UploadTask uploadTask = storageReference.putData(data);
    await uploadTask;
    String downloadUrl = await storageReference.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .update({'profilePicture': downloadUrl});
    participant.profilePictureUrl = downloadUrl;
    updateParticipant(participant);
  }

  Future<void> updateParticipant(Participant participant) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(participant.id)
        .update(participant.toMap());
    this.participant = participant;
    notifyListeners();
  }

  Future<void> addChallengeParticipation(Challenge challenge) async {
    await deleteChallengeParticipationOnDate(DateTime.now());
    ChallengeParticipation challengeParticipation = ChallengeParticipation(
      challengeId: challenge.id!,
      pariticipantId: participant.id,
      dateCompleted: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection('challengeParticipations')
        .add(challengeParticipation.toMap());
    challengeParticipations.add(challengeParticipation);
    notifyListeners();
  }

  Future<void> _fetchChallengeParticipations() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('challengeParticipations')
        .get();

    challengeParticipations = querySnapshot.docs
        .map((e) => ChallengeParticipation.fromMap(e.id, e.data()))
        .toList();
  }

  Future<void> _fetchAllParticipants() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();

    participants = querySnapshot.docs
        .map((e) => Participant.fromMap(e.id, e.data()))
        .toList();
  }

  Future<void> deleteChallengeParticipation(
      ChallengeParticipation challengeParticipation) async {
    await FirebaseFirestore.instance
        .collection('challengeParticipations')
        .doc(challengeParticipation.id)
        .delete();
    challengeParticipations
        .removeWhere((element) => element.id == challengeParticipation.id);
    notifyListeners();
  }

  Future<void> deleteChallengeParticipationOnDate(DateTime date) async {
    //delete in firebase
    QuerySnapshot<Map<String, dynamic>> querySnapshot = await FirebaseFirestore
        .instance
        .collection('challengeParticipations')
        .where('pariticipantId', isEqualTo: participant.id)
        .where('dateCompleted',
            isGreaterThanOrEqualTo:
                Timestamp.fromDate(DateTime(date.year, date.month, date.day)))
        .where('dateCompleted',
            isLessThan: Timestamp.fromDate(
                DateTime(date.year, date.month, date.day + 1)))
        .get();

    for (var doc in querySnapshot.docs) {
      await FirebaseFirestore.instance
          .collection('challengeParticipations')
          .doc(doc.id)
          .delete();
    }

    challengeParticipations.removeWhere((element) =>
        element.dateCompleted.day == date.day &&
        element.dateCompleted.month == date.month &&
        element.dateCompleted.year == date.year);
    notifyListeners();
  }

  bool isChallengeCompletedForToday() {
    DateTime today = DateTime.now();
    return challengeParticipations.any((element) =>
        element.dateCompleted.day == today.day &&
        element.dateCompleted.month == today.month &&
        element.dateCompleted.year == today.year);
  }

  Challenge? getChallengeForWeek({int weeksSinceNow = 0}) {
    if (challenges.isEmpty) {
      return null;
    }
    DateTime today = DateTime.now();
    today = today.add(Duration(days: weeksSinceNow * 7));
    //challenge.activeSince is max 7 days
    Challenge? challengeToday = challenges.cast().firstWhere(
      (element) =>
          element.activeSince != null &&
          element.activeSince!.day >= today.day - 7 &&
          element.activeSince!.day <= today.day &&
          element.activeSince!.month == today.month &&
          element.activeSince!.year == today.year,
      orElse: () {
        return null;
      },
    );
    return challengeToday;
  }

  static Future<bool> isChallengeDoneForToday() async {
    return false;
  }

  bool isChallengeDoneForDate(DateTime day) {
    return challengeParticipations.any((element) =>
        element.dateCompleted.day == day.day &&
        element.dateCompleted.month == day.month &&
        element.dateCompleted.year == day.year &&
        element.pariticipantId == participant.id);
  }

  void selectChallengeForWeek(int weeksSinceNow) {
    if (challenges.isEmpty ||
        getChallengeForWeek(weeksSinceNow: weeksSinceNow) != null) {
      return;
    }

    List<Challenge> allChallenges =
        challenges.where((element) => element.activeSince == null).toList();
    //sort by amount of likedBy and dislikedBy

    allChallenges.sort((a, b) {
      return b.likedBy.length -
          b.dislikedBy.length -
          (a.likedBy.length - a.dislikedBy.length);
    });

    //get next monday
    DateTime nextMonday = getMondayForWeek(weeksSinceNow);

    //set activeSince to next monday
    Challenge challenge = allChallenges.first;
    challenge.activeSince = nextMonday;
    print(
        'updating challenge: ${challenge.id} with activeSince: $nextMonday for week $weeksSinceNow');
    updateChallenge(challenge);
  }

  Map<Participant, List<ChallengeParticipation>>
      getChallengeParticipationsForWeek({int weeksSinceNow = 0}) {
    DateTime monday = getMondayForWeek(weeksSinceNow);
    DateTime sunday = getMondayForWeek(weeksSinceNow + 1);

    List<ChallengeParticipation> challengeParticipationsForWeek =
        challengeParticipations.where((element) {
      return element.dateCompleted.isAfter(monday) &&
          element.dateCompleted.isBefore(sunday);
    }).toList();

    Map<String, List<ChallengeParticipation>>
        challengeParticipationsForWeekMap = {};

    for (var challengeParticipation in challengeParticipationsForWeek) {
      if (challengeParticipationsForWeekMap
          .containsKey(challengeParticipation.pariticipantId)) {
        challengeParticipationsForWeekMap[challengeParticipation.pariticipantId]
            ?.add(challengeParticipation);
      } else {
        challengeParticipationsForWeekMap[
            challengeParticipation.pariticipantId] = [challengeParticipation];
      }
    }

    Map<Participant, List<ChallengeParticipation>>
        challengeParticipationsForWeekMap2 = {};

    for (var participant in participants) {
      if (challengeParticipationsForWeekMap.containsKey(participant.id)) {
        challengeParticipationsForWeekMap2[participant] =
            challengeParticipationsForWeekMap[participant.id]!;
      }
    }

    return challengeParticipationsForWeekMap2;
  }

  ///this method is called once the user has logged in
  void fetchData(User user) async {
    print('fetching data');
    await _fetchParticipant(user);
    await _fetchToken();
    await _fetchAllParticipants();
    await _fetchChallengeParticipations();
    isDoneForToday = isChallengeCompletedForToday();
    await _fetchChallenges();

    notifyListeners();

    selectChallengeForWeek(0);
    selectChallengeForWeek(1);
  }
}
