import 'package:flutter/material.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/main.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
        widthFactor: 0.5,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Box(
              headline: "Esse jeden Tag einen Socken",
              description: "Challenge",
              color: Color.fromARGB(255, 208, 222, 255),
              children: [],
            ),
            const SizedBox(height: 35),
            Box(
              headline: "Heute",
              description: "Challenge erledigt?",
              color: const Color.fromARGB(255, 255, 172, 172),
              children: [
                SizedBox(
                    width: 80,
                    height: 80,
                    child: Button(
                      icon: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                      backgroundColor: Colors.green,
                      borderRadius: 100,
                      onPressed: () {},
                    ))
              ],
            ),
            const SizedBox(height: 35),
            const Box(
              headline: "Deine Erfolg",
              description: "Aktuelle Woche",
              color: Color.fromARGB(255, 186, 255, 195),
              children: [
                //übersicht der Woche
              ],
            )
          ],
        ));
  }
}

class Box extends StatelessWidget {
  final String headline;
  final String description;
  final Color color;
  final List<Widget> children;
  const Box(
      {super.key,
      required this.color,
      required this.children,
      required this.headline,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: App.defaultPadding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: color,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              headline,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(
              description,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: 35),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            )
          ],
        ));
  }
}
