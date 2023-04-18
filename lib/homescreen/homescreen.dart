import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/homescreen/components/animated_done_button.dart';
import 'package:weekly_challenge/homescreen/components/box.dart';
import 'package:weekly_challenge/homescreen/components/challenge_fab.dart';
import 'package:weekly_challenge/homescreen/components/week_stepper.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Challenge challenge;
  @override
  void initState() {
    super.initState();
    challenge = Challenge(
      id: "123",
      title: "Esse jeden Tag einen Socken",
      description: "Challenge",
    );
  }

  void _done(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Challenge erledigt"),
      duration: Duration(seconds: 1),
    ));
    context.read<FirestoreHandler>().addChallengeParticipation(challenge);
  }

  void _undoDone(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Challenge zurückgezogen"),
      duration: Duration(seconds: 1),
    ));
    context
        .read<FirestoreHandler>()
        .deleteChallengeParticipationOnDate(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: App.primaryColor,
        floatingActionButton: const ChallengeFloatingButton(),
        body: SizedBox.expand(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ListView(
                  children: [
                    const Box(
                      headline: "Esse jeden Tag einen Socken",
                      description: "Challenge",
                      color: App.primaryColorBrighter,
                      children: [],
                    ),
                    const SizedBox(height: 35),
                    Box(
                      headline: "Heute",
                      description: "Challenge erledigt?",
                      color: App.primaryColorBrighter,
                      children: [
                        AnimatedDoneButton(
                          onDone: () => _done(context),
                          onUndo: () => _undoDone(context),
                        )
                      ],
                    ),
                    const SizedBox(height: 35),
                    const Box(
                      headline: "Deine Erfolg",
                      description: "Aktuelle Woche",
                      color: App.primaryColorBrighter,
                      children: [
                        //übersicht der Woche
                        WeekStepper(),
                      ],
                    )
                  ],
                ))));
  }
}
