import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weekly_challenge/models/challenge_participation.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:weekly_challenge/utils.dart';

class FirestoreHandler extends ChangeNotifier {
  List<Challenge> challenges = [];
  List<ChallengeParticipation> challengeParticipations = [];
  Participant? participant;
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

  Future<void> _fetchParticipant() async {
    if (FirebaseAuth.instance.currentUser == null) return;

    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    if (!documentSnapshot.exists || documentSnapshot.data() == null) {
      return;
    }

    participant =
        Participant.fromMap(documentSnapshot.id, documentSnapshot.data()!);
  }

  Future<void> _fetchParticipantsProfilePicture() async {
    if (FirebaseAuth.instance.currentUser == null) return;
    final file = FirebaseStorage.instance.ref().child(
        'users/${FirebaseAuth.instance.currentUser!.uid}/profilePicture');
    participant?.profilePicture = CachedNetworkImage(
      imageUrl: file.fullPath,
      placeholder: (context, url) => CircularProgressIndicator(
          color: Theme.of(context).colorScheme.onPrimary),
    );
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
      pariticipantId: participant!.id,
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
        .where('pariticipantId', isEqualTo: participant!.id)
        .get();

    challengeParticipations = querySnapshot.docs
        .map((e) => ChallengeParticipation.fromMap(e.id, e.data()))
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
        .where('pariticipantId', isEqualTo: participant!.id)
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

  bool isChallengeDoneForDate(DateTime day) {
    return challengeParticipations.any((element) =>
        element.dateCompleted.day == day.day &&
        element.dateCompleted.month == day.month &&
        element.dateCompleted.year == day.year &&
        element.pariticipantId == participant!.id);
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

  Map<String, List<ChallengeParticipation>> getChallengeParticipationsForWeek(
      {int weeksSinceNow = 0}) {
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

    return challengeParticipationsForWeekMap;
  }

  ///this method is called once the user has logged in
  void fetchData() async {
    print('fetching data');
    await _fetchParticipant();
    await _fetchChallengeParticipations();
    isDoneForToday = isChallengeCompletedForToday();
    await _fetchChallenges();
    await _fetchParticipantsProfilePicture();
    notifyListeners();

    selectChallengeForWeek(0);
    selectChallengeForWeek(1);
  }
}
