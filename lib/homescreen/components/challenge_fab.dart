import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:weekly_challenge/main.dart';

class ChallengeFloatingButton extends StatelessWidget {
  const ChallengeFloatingButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "challenges",
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        onPressed: () => GoRouter.of(context).go('/challenges'),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label:
            Text("Challenges", style: Theme.of(context).textTheme.labelMedium),
        icon: const Icon(Icons.format_list_bulleted,
            size: 25, color: Colors.white));
  }
}
