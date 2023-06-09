import 'package:easy_stepper/easy_stepper.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/loading_indicator.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/challenges.dart';
import 'package:weekly_challenge/utils.dart';

class WeekStepper extends StatelessWidget {
  const WeekStepper({super.key});

  @override
  Widget build(BuildContext context) {
    List<bool> doneLastDays = [];
    Challenge? todaysChallenge =
        context.watch<FirestoreHandler>().getChallengeForWeek();

    if (todaysChallenge == null) {
      return const LoadingIndicator();
    }
    DateTime firstDate = todaysChallenge.activeSince!;
    for (int i = 0; i < 7; i++) {
      doneLastDays.add(context.watch<FirestoreHandler>().isChallengeDoneForDate(
          DateTime(firstDate.year, firstDate.month, firstDate.day + i)));
    }

    int indexToday = DateTime.now().difference(firstDate).inDays;

    Widget getStepAvatar(int index) {
      if (index > indexToday) {
        return const SizedBox(
            width: 50,
            height: 50,
            child: CircleAvatar(
              child: Icon(Icons.border_color, color: Colors.white),
            ));
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
          customStep: getStepAvatar(index),
          title: getWeekdayNameByNumber(
              DateTime(firstDate.year, firstDate.month, firstDate.day + index)
                  .weekday));
    }, growable: false);

    return EasyStepper(
      finishedStepBorderColor: Colors.transparent,
      finishedStepBackgroundColor: Colors.transparent,
      unreachedStepBorderColor: Colors.transparent,
      unreachedStepBackgroundColor: Colors.transparent,
      activeStepBorderType: BorderType.normal,
      activeStepTextColor: Theme.of(context).colorScheme.onPrimary,
      finishedStepTextColor: Theme.of(context).colorScheme.onPrimary,
      unreachedStepTextColor: Theme.of(context).colorScheme.onPrimary,
      activeStepBorderColor: Theme.of(context).colorScheme.onPrimary,
      activeStep: indexToday,
      steps: steps,
      lineType: LineType.normal,
      direction: Axis.vertical,
      showLoadingAnimation: false,
      defaultLineColor: Theme.of(context).colorScheme.onPrimary,
      lineDotRadius: 2,
      borderThickness: 0,
      enableStepTapping: false,
      disableScroll: true,
    );
  }
}
