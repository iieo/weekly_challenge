import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/components/loading_indicator.dart';
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

    List<Task> tasks = context.watch<TaskManager>().tasks;
    return ScreenContainer(
        title: "ToDo Liste",
        isScrollEnabled: false,
        floatingActionButton: const AddTaskFab(),
        children: [
          Expanded(
              child: FutureBuilder<List<Task>>(
                  future: context.watch<TaskManager>().readTasks(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      tasks = snapshot.data!;
                      return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            return TaskCard(task: tasks[index]);
                          });
                    } else {
                      return const LoadingIndicator();
                    }
                  })),
          const SizedBox(height: 70)
        ]);
  }
}
