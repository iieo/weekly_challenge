import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:weekly_challenge/models/challenge_participation.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FirestoreHandler extends ChangeNotifier {
  List<Challenge> challenges = [];
  List<ChallengeParticipation> challengeParticipations = [];
  Participant? participant;

  Future<void> _fetchChallenges() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('challenges').get();

    challenges = querySnapshot.docs
        .map((e) => Challenge.fromMap(e.id, e.data()))
        .toList();
    notifyListeners();
  }

  Future<void> addChallenge(Challenge challenge) async {
    await FirebaseFirestore.instance
        .collection('challenges')
        .add(challenge.toMap());
    challenges.add(challenge);
    notifyListeners();
  }

  Future<void> updateChallenge(Challenge challenge) async {
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
    DocumentSnapshot<Map<String, dynamic>> documentSnapshot =
        await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

    participant =
        Participant.fromMap(documentSnapshot.id, documentSnapshot.data()!);
    notifyListeners();
  }

  Future<void> _fetchParticipantsProfilePicture() async {
    final file = FirebaseStorage.instance.ref().child(
        'users/${FirebaseAuth.instance.currentUser!.uid}/profilePicture');
    participant?.profilePicture = CachedNetworkImage(
      imageUrl: file.fullPath,
      placeholder: (context, url) => const CircularProgressIndicator(),
    );
    notifyListeners();
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
    notifyListeners();
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

  ///this method is called once the user has logged in
  void fetchData() async {
    print('fetching data');
    await _fetchChallenges();
    await _fetchChallengeParticipations();
    await _fetchParticipant();
    await _fetchParticipantsProfilePicture();
  }
}
