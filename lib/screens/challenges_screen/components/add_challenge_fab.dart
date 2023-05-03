import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/screens/challenges_screen/components/add_challenge_dialog.dart';

class AddChallengeFab extends StatelessWidget {
  const AddChallengeFab({super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "Hinzufügen",
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(App.defaultRadius))),
        onPressed: () => showDialog(
            context: context, builder: (context) => const AddChallengeDialog()),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label:
            Text("Challenges", style: Theme.of(context).textTheme.labelMedium),
        icon: const Icon(Icons.add, size: 25, color: Colors.white));
  }
}
