import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/screens/homescreen/components/animated_done_button.dart';
import 'package:weekly_challenge/screens/homescreen/components/box.dart';
import 'package:weekly_challenge/screens/homescreen/components/friends_comparison.dart';
import 'package:weekly_challenge/screens/homescreen/components/week_stepper.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/screens/screen_container.dart';

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
    context
        .read<FirestoreHandler>()
        .deleteChallengeParticipationOnDate(DateTime.now());
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Challenge zurückgezogen"),
      duration: Duration(seconds: 1),
    ));
  }

  @override
  Widget build(BuildContext context) {
    Challenge? challengeThisWeek =
        context.watch<FirestoreHandler>().getChallengeForWeek();
    Challenge? challengeNextWeek =
        context.watch<FirestoreHandler>().getChallengeForWeek(weeksSinceNow: 1);

    return ScreenContainer(
      children: [
        const SizedBox(height: 20),
        Box(
          headline: challengeThisWeek?.title ?? "Challenge loading...",
          description:
              challengeThisWeek?.description ?? "Description loading...",
        ),
        const SizedBox(height: 35),
        Box(
          headline: "Heute",
          description: "Challenge erledigt?",
          child: AnimatedDoneButton(
            onDone: () => _done(context),
            onUndo: () => _undoDone(context),
          ),
        ),
        const SizedBox(height: 35),
        const Box(
          headline: "Deine Freunde",
          child: SizedBox(
            height: 250,
            child: FriendsComparison(),
          ),
        ),
        const SizedBox(height: 35),
        const Box(
          headline: "Deine Erfolg",
          description: "Aktuelle Woche",
          child: WeekStepper(),
        ),
        const SizedBox(height: 35),
        Box(
          headline: "Nächste Challenge",
          description: challengeNextWeek?.title ?? "Loading...",
        ),
        const SizedBox(height: 70)
      ],
    );
  }
}
