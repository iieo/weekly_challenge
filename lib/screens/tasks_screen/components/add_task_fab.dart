import 'package:flutter/material.dart';
import 'package:weekly_challenge/main.dart';
import 'package:weekly_challenge/screens/tasks_screen/components/add_task_dialog.dart';

class AddTaskFab extends StatelessWidget {
  const AddTaskFab({super.key});
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
        heroTag: "addTask",
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(App.defaultRadius))),
        onPressed: () => showDialog(
            context: context, builder: (context) => const AddTaskDialog()),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        label: Text("Aufgabe", style: Theme.of(context).textTheme.labelMedium),
        icon: const Icon(Icons.add, size: 25, color: Colors.white));
  }
}
