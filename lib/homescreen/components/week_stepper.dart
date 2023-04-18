import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/challenges.dart';

class WeekStepper extends StatelessWidget {
  const WeekStepper({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> doneLastDays = [];
    Challenge? todaysChallenge =
        context.watch<FirestoreHandler>().getChallengeForToday();

    if (todaysChallenge == null) {
      return const Text("No challenge for today");
    }
    DateTime firstDate = todaysChallenge.activeSince!;
    for (int i = 0; i < 7; i++) {
      doneLastDays.add(context.watch<FirestoreHandler>().isChallengeDoneForDate(
          DateTime(firstDate.year, firstDate.month, firstDate.day + i)));
    }

    DateTime today = DateTime.now();
    int indexToday = today.difference(firstDate).inDays;

    List<Step> steps = List.generate(7, (index) {
      return Step(
        title: Text(
            DateTime(firstDate.year, firstDate.month, firstDate.day + index)
                .weekday
                .toString(),
            style: Theme.of(context).textTheme.labelSmall),
        content: Container(),
        isActive: indexToday == index,
        state: doneLastDays[index] ? StepState.complete : StepState.indexed,
      );
    });

    return Container(
        color: Colors.amber,
        child: Stepper(
          steps: steps,
          type: StepperType.vertical,
          controlsBuilder: (context, details) => Container(),
          currentStep: indexToday,
        ));
  }
}
