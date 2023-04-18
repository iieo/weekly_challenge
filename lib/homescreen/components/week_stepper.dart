import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/utils.dart';

class WeekStepper extends StatelessWidget {
  const WeekStepper({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> doneLastDays = [];
    Challenge? todaysChallenge =
        context.watch<FirestoreHandler>().getChallengeForToday();

    if (todaysChallenge == null) {
      return const CircularProgressIndicator();
    }
    DateTime firstDate = todaysChallenge.activeSince!;
    for (int i = 0; i < 7; i++) {
      doneLastDays.add(context.watch<FirestoreHandler>().isChallengeDoneForDate(
          DateTime(firstDate.year, firstDate.month, firstDate.day + i)));
    }

    DateTime today = DateTime.now();
    int indexToday = today.difference(firstDate).inDays;

    Widget _getStepAvatar(int index) {
      if (index > indexToday) {
        return const CircleAvatar(
          child: Icon(Icons.border_color, color: Colors.white),
        );
      }
      return doneLastDays[index]
          ? const CircleAvatar(
              backgroundColor: Colors.green,
              child: Icon(Icons.check, color: Colors.white),
            )
          : const CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.close_outlined, color: Colors.white),
            );
    }

    List<EasyStep> steps = List.generate(7, (index) {
      return EasyStep(
          customStep: _getStepAvatar(index),
          title: getWeekdayNameByNumber(
              DateTime(firstDate.year, firstDate.month, firstDate.day + index)
                  .weekday));
    });

    return EasyStepper(
      activeStep: indexToday,
      steps: steps,
      lineType: LineType.normal,
      direction: Axis.vertical,
      showLoadingAnimation: false,
    );
  }
}
