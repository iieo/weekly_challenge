import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/homescreen/components/animated_done_button.dart';
import 'package:weekly_challenge/homescreen/components/box.dart';
import 'package:weekly_challenge/homescreen/components/challenge_fab.dart';
import 'package:weekly_challenge/homescreen/components/task_box.dart';
import 'package:weekly_challenge/homescreen/components/week_stepper.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/models/participant.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _done(BuildContext context) {
    Challenge? challengeThisWeek =
        context.read<FirestoreHandler>().getChallengeForWeek();
    String scaffoldMessage = "Challenge erledigt";
    if (challengeThisWeek == null) {
      scaffoldMessage =
          "Keine Challenge für diese Woche. Probier es später nochmal.";
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(scaffoldMessage),
      duration: const Duration(seconds: 1),
    ));
    if (challengeThisWeek != null) {
      context
          .read<FirestoreHandler>()
          .addChallengeParticipation(challengeThisWeek);
    }
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
    Challenge? challengeThisWeek =
        context.watch<FirestoreHandler>().getChallengeForWeek();
    Challenge? challengeNextWeek =
        context.watch<FirestoreHandler>().getChallengeForWeek(weeksSinceNow: 1);

    Participant participant = context.watch<FirestoreHandler>().participant ??
        Participant.loadingParticipant;

    return Scaffold(
        floatingActionButton: const ChallengeFloatingButton(),
        body: SizedBox.expand(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ListView(
                  children: [
                    const SizedBox(height: 35),
                    const TaskBox(),
                    const SizedBox(height: 35),
                    Box(
                      headline:
                          challengeThisWeek?.title ?? "Challenge loading...",
                      description: challengeThisWeek?.description ??
                          "Description loading...",
                      children: [
                        Visibility(
                            visible: challengeThisWeek == null,
                            child: CircularProgressIndicator(
                                color: Theme.of(context).colorScheme.onPrimary))
                      ],
                    ),
                    const SizedBox(height: 35),
                    Box(
                      headline: "Heute",
                      description: "Challenge erledigt?",
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
                      children: [
                        WeekStepper(),
                      ],
                    ),
                    const SizedBox(height: 35),
                    Box(
                      headline: "Nächste Challenge",
                      description: challengeNextWeek?.title ?? "Loading...",
                    ),
                    const SizedBox(height: 35),
                    Box(headline: "Übersicht", children: [
                      Text("Name: ${participant.name}",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Text("Email: ${participant.email}",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 10),
                      Text("Points: ${participant.points}",
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 35),
                      const Button(
                        text: "Abmelden",
                        onPressed: FirebaseAuthHandler.logout,
                      )
                    ]),
                    const SizedBox(height: 70)
                  ],
                ))));
  }
}
