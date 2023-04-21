import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';

class Box extends StatelessWidget {
  final String headline;
  final String? description;
  final List<Widget>? children;
  final List<Widget>? sideChildren;
  const Box(
      {super.key,
      this.children,
      this.sideChildren,
      required this.headline,
      this.description});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: App.defaultPadding,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          color: Theme.of(context).colorScheme.primaryContainer,
          /*gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).colorScheme.primaryContainer,
                  Theme.of(context).colorScheme.primaryContainer
                ])*/
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
                  description != null
                      ? Text(
                          description!,
                          style: Theme.of(context).textTheme.titleSmall,
                        )
                      : const SizedBox.shrink(),
                  const SizedBox(height: 35),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: children ?? [],
                  )
                ],
              )),
              ...sideChildren ?? [],
            ]));
  }
}
