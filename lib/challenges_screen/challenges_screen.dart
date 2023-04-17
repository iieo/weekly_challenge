import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/challenges_screen/components/add_challenge_fab.dart';
import 'package:weekly_challenge/challenges_screen/components/challenge_card.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';

class ChallengesScreen extends StatelessWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Challenge> challenges =
        context.watch<FirestoreHandler>().challenges;

    return Scaffold(
        floatingActionButton: const AddChallengeFloatingButton(),
        backgroundColor: App.primaryColor,
        appBar: AppBar(
          title:
              Text('Challenges', style: Theme.of(context).textTheme.titleLarge),
          backgroundColor: App.primaryColor,
          foregroundColor: App.whiteColor,
        ),
        body: Hero(
            tag: 'challenges',
            child: Container(
                padding: App.defaultPadding,
                child: ListView.builder(
                    itemCount: challenges.length,
                    itemBuilder: (context, index) {
                      return ChallengeCard(challenge: challenges[index]);
                    }))));
  }
}
