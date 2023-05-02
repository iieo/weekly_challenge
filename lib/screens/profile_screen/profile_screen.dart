import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/firebase/firebase_auth_handler.dart';
import 'package:weekly_challenge/firebase/firestore_handler.dart';
import 'package:weekly_challenge/models/participant.dart';
import 'package:weekly_challenge/screens/homescreen/components/box.dart';
import 'package:weekly_challenge/screens/screen_container.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Participant participant = context.watch<FirestoreHandler>().participant ??
        Participant.loadingParticipant;
    return ScreenContainer(title: "Profil", children: [
      Box(
          headline: "Übersicht",
          child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
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
          ])),
    ]);
  }
}
