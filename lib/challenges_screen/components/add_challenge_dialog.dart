import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/models/challenges.dart';

class AddChallengeDialog extends StatefulWidget {
  final Challenge? prefilledData;
  const AddChallengeDialog({super.key, this.prefilledData});

  @override
  State<AddChallengeDialog> createState() => AddChallengeDialogState();
}

class AddChallengeDialogState extends State<AddChallengeDialog> {
  late String description;
  late String title;

  @override
  void initState() {
    super.initState();
    description = widget.prefilledData?.description ?? "";
    title = widget.prefilledData?.title ?? "";
  }

  void _submitChallenge(BuildContext context) {
    if (widget.prefilledData != null) {
      Challenge challenge = widget.prefilledData!;
      challenge.title = title;
      challenge.description = description;

      context.read<FirestoreHandler>().updateChallenge(challenge);
    } else {
      Challenge challenge = Challenge(
        title: title,
        description: description,
      );

      context.read<FirestoreHandler>().addChallenge(challenge);
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        backgroundColor: App.primaryColorBrighter,
        title: const Text("Challenge hinzufügen"),
        content: Form(
            child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
                initialValue: title,
                decoration: const InputDecoration(
                    labelStyle: TextStyle(color: App.whiteColor),
                    hintStyle: TextStyle(color: App.whiteColorDarker),
                    labelText: "Titel",
                    hintText: "z.B. 10km laufen"),
                onChanged: (value) => setState(() => title = value)),
            TextFormField(
                initialValue: description,
                maxLines: null,
                decoration: const InputDecoration(
                    labelText: "Beschreibung",
                    labelStyle: TextStyle(color: App.whiteColor),
                    hintStyle: TextStyle(color: App.whiteColorDarker),
                    hintText:
                        "z.B. 10km laufen und dabei 10x anhalten und 10 Liegestütze machen"),
                onChanged: (value) => setState(() => description = value)),
          ],
        )),
        actions: [
          TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("Abbrechen",
                  style: Theme.of(context).textTheme.labelSmall)),
          TextButton(
              onPressed: () => _submitChallenge(context),
              child: Text(
                  widget.prefilledData == null ? "Hinzufügen" : "Speichern",
                  style: Theme.of(context).textTheme.labelSmall))
        ]);
  }
}