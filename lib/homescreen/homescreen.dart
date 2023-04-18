import 'package:flutter/material.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/homescreen/components/box.dart';
import 'package:weekly_challenge/homescreen/components/challenge_fab.dart';
import 'package:weekly_challenge/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: const ChallengeFloatingButton(),
        body: SizedBox.expand(
            child: FractionallySizedBox(
                widthFactor: 0.8,
                child: ListView(
                  children: [
                    Box(
                      headline: "Esse jeden Tag einen Socken",
                      description: "Challenge",
                      color: Theme.of(context).colorScheme.primaryContainer,
                      children: [],
                    ),
                    const SizedBox(height: 35),
                    Box(
                      headline: "Heute",
                      description: "Challenge erledigt?",
                      color: Theme.of(context).colorScheme.primaryContainer,
                      children: [
                        SizedBox(
                            height: 70,
                            child: Button(
                              icon: const Icon(
                                Icons.check,
                                color: Colors.white,
                                size: 35,
                              ),
                              backgroundColor:
                                  Theme.of(context).colorScheme.secondary,
                              onPressed: () {},
                            ))
                      ],
                    ),
                    const SizedBox(height: 35),
                    Box(
                      headline: "Deine Erfolg",
                      description: "Aktuelle Woche",
                      color: Theme.of(context).colorScheme.primaryContainer,
                      children: [
                        //übersicht der Woche
                      ],
                    )
                  ],
                ))));
  }
}
