import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/models/task_manager.dart';
import 'package:weekly_challenge/screens/homescreen/components/box.dart';
import 'package:weekly_challenge/screens/tasks_screen/components/add_task_fab.dart';
import 'package:weekly_challenge/screens/tasks_screen/components/task_item.dart';
import 'package:weekly_challenge/models/task.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:weekly_challenge/screens/screen_container.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  void showAddTaskDialog(BuildContext context) {}

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return const Center(child: Text("Not supported on web"));
    }

    Future<List<Task>> tasks = context.watch<TaskManager>().tasks;

    return ScreenContainer(
        title: "ToDo Liste",
        isScrollEnabled: false,
        floatingActionButton: const AddTaskFab(),
        children: [
          FutureBuilder(
              future: tasks,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<Task> tasks = snapshot.data as List<Task>;
                  tasks.sort((a, b) {
                    if (a.dateCompleted == null && b.dateCompleted == null) {
                      return 0;
                    } else if (a.dateCompleted == null) {
                      return -1;
                    } else if (b.dateCompleted == null) {
                      return 1;
                    } else {
                      return b.dateCompleted!.compareTo(a.dateCompleted!);
                    }
                  });
                  return Column(children: [
                    Expanded(
                        child: ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context, index) {
                              return TaskCard(task: tasks[index]);
                            })),
                    const SizedBox(height: 70)
                  ]);
                } else {
                  return Center(
                      child: SizedBox(
                          height: 50,
                          width: 50,
                          child: CircularProgressIndicator(
                              color: Theme.of(context).colorScheme.onPrimary)));
                }
              }),
        ]);
  }
}
