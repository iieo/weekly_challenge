import 'package:firebase_auth/firebase_auth.dart';
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
    String firebaseId = FirebaseAuth.instance.currentUser!.uid;
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
                      onPressed: () {
                        challenge.likedBy.add(firebaseId);
                        context
                            .read<FirestoreHandler>()
                            .updateChallenge(challenge);
                      },
                      icon: Icon(Icons.thumb_up,
                          color: challenge.likedBy.contains(firebaseId)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onPrimary)),
                  IconButton(
                      onPressed: () {
                        challenge.dislikedBy.add(firebaseId);
                        context
                            .read<FirestoreHandler>()
                            .updateChallenge(challenge);
                      },
                      icon: Icon(Icons.thumb_down,
                          color: challenge.dislikedBy.contains(firebaseId)
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.onPrimary)),
                  IconButton(
                      onPressed: () => showDialog(
                          context: context,
                          builder: (context) => AddChallengeDialog(
                                prefilledData: challenge,
                              )),
                      icon: Icon(Icons.edit,
                          color: Theme.of(context).colorScheme.onPrimary)),
                  IconButton(
                      onPressed: () => context
                          .read<FirestoreHandler>()
                          .deleteChallenge(challenge),
                      icon: Icon(Icons.delete,
                          color: Theme.of(context).colorScheme.onPrimary))
                ])));
  }
}
