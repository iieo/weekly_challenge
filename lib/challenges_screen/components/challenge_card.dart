import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/challenges_screen/components/add_challenge_dialog.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';

class ChallengeCard extends StatelessWidget {
  final Challenge challenge;
  const ChallengeCard({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: ListTile(
            title: Text(challenge.title,
                style: Theme.of(context).textTheme.titleMedium),
            subtitle: Text(
              challenge.description,
              maxLines: null,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            trailing: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AddChallengeDialog(
                                prefilledData: challenge,
                              )),
                      icon:
                          const Icon(Icons.edit, color: App.whiteColorDarker)),
                  IconButton(
                      onPressed: () => context
                          .read<FirestoreHandler>()
                          .deleteChallenge(challenge),
                      icon:
                          const Icon(Icons.delete, color: App.whiteColorDarker))
                ])));
  }
}