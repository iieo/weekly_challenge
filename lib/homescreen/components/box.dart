import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

class Box extends StatelessWidget {
  final String headline;
  final String description;
  final List<Widget>? children;
  final List<Widget>? sideChildren;
  const Box(
      {super.key,
      this.children,
      this.sideChildren,
      required this.headline,
      required this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: App.defaultPadding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.primary,
        ),
        child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    headline,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 35),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: children ?? [],
                  )
                ],
              )),
              ...sideChildren ?? [],
            ]));
  }
}
