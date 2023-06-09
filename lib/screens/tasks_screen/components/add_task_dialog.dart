import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/models/task.dart';
import 'package:weekly_challenge/models/task_manager.dart';

class AddTaskDialog extends StatelessWidget {
  const AddTaskDialog({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController taskNameController = TextEditingController();
    return AlertDialog(
        title: Text("Aufgabe Hinzufügen",
            style: Theme.of(context).textTheme.labelMedium),
        content: TextField(
            controller: taskNameController,
            decoration: InputDecoration(
                labelStyle: Theme.of(context).textTheme.labelMedium,
                hintStyle: Theme.of(context).textTheme.labelMedium,
                labelText: "Aufgabe",
                hintText: "Wäsche waschen")),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("Abbrechen",
                  style: Theme.of(context).textTheme.labelMedium)),
          TextButton(
              onPressed: () {
                context
                    .read<TaskManager>()
                    .addTask(Task(name: taskNameController.text));
                Navigator.of(context).pop();
              },
              child: Text("Hinzufügen",
                  style: Theme.of(context).textTheme.labelSmall))
        ]);
  }
}
