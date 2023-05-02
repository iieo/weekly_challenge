import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/button.dart';
import 'package:weekly_challenge/homescreen/components/box.dart';
import 'package:weekly_challenge/homescreen/components/task_item.dart';
import 'package:weekly_challenge/models/task.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class TaskBox extends StatelessWidget {
  const TaskBox({super.key});

  void showAddTaskDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          TextEditingController taskNameController = TextEditingController();
          return AlertDialog(
              title: Text("Add Task",
                  style: Theme.of(context).textTheme.labelMedium),
              content: TextField(
                  controller: taskNameController,
                  decoration: const InputDecoration(hintText: "Task Name")),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel",
                        style: Theme.of(context).textTheme.labelSmall)),
                TextButton(
                    onPressed: () {
                      context
                          .read<TaskManager>()
                          .addTask(Task(name: taskNameController.text));
                      Navigator.of(context).pop();
                    },
                    child: Text("Add",
                        style: Theme.of(context).textTheme.labelSmall))
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const SizedBox.shrink();
    }

    Future<List<Task>> tasks = context.watch<TaskManager>().tasks;

    return Box(
        headline: "Meine Aufgaben",
        child: Container(
            constraints: const BoxConstraints(maxHeight: 500),
            child: Column(children: [
              Expanded(
                  child: FutureBuilder(
                      future: tasks,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<Task> tasks = snapshot.data as List<Task>;
                          //sort by completedDate (null first)
                          tasks.sort((a, b) {
                            if (a.dateCompleted == null &&
                                b.dateCompleted == null) {
                              return 0;
                            } else if (a.dateCompleted == null) {
                              return -1;
                            } else if (b.dateCompleted == null) {
                              return 1;
                            } else {
                              return b.dateCompleted!
                                  .compareTo(a.dateCompleted!);
                            }
                          });
                          return ListView.builder(
                              itemCount: tasks.length,
                              itemBuilder: (context, index) {
                                return TaskCard(task: tasks[index]);
                              });
                        } else {
                          return Center(
                              child: SizedBox(
                                  height: 50,
                                  width: 50,
                                  child: CircularProgressIndicator(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimary)));
                        }
                      })),
              Button(
                  onPressed: () => showAddTaskDialog(context),
                  text: "Add Task"),
              TextButton(
                  onPressed: () {
                    context.read<TaskManager>().deleteAllTasks();
                  },
                  child: Text(
                    "Alle Tasks löschen",
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
              const SizedBox(height: 35),
            ])));
  }
}
