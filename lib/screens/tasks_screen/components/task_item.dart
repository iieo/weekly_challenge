import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/models/task.dart';
import 'package:weekly_challenge/models/task_manager.dart';

class TaskCard extends StatefulWidget {
  final Task task;
  const TaskCard({super.key, required this.task});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  late bool isCompleted;

  @override
  void initState() {
    isCompleted = widget.task.isCompleted;
    super.initState();
  }

  void _toggleTask(value) {
    setState(() {
      isCompleted = value!;
    });
    context.read<TaskManager>().toggleTask(widget.task);
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(widget.task.hashCode.toString()),
        confirmDismiss: (direction) {
          if (direction == DismissDirection.endToStart) {
            _toggleTask(!isCompleted);
            return Future.value(false);
          }
          return Future.value(true);
        },
        background: Container(
            color: Theme.of(context).colorScheme.error,
            child: const Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.only(left: 16),
                    child: Icon(Icons.delete, color: Colors.white)))),
        secondaryBackground: Container(
            color: Theme.of(context).colorScheme.secondary,
            child: const Align(
                alignment: Alignment.centerRight,
                child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(Icons.check, color: Colors.white)))),
        onDismissed: (direction) {
          if (direction == DismissDirection.startToEnd) {
            context.read<TaskManager>().deleteTask(widget.task);
          }
        },
        child: CheckboxListTile(
            value: isCompleted,
            onChanged: _toggleTask,
            title: isCompleted
                ? Text(widget.task.name,
                    style: const TextStyle(
                      decoration: TextDecoration.lineThrough,
                    ))
                : Text(widget.task.name)));
  }
}
