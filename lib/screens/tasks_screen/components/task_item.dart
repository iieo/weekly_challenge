import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weekly_challenge/models/task.dart';

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

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
        value: isCompleted,
        onChanged: (value) {
          setState(() {
            isCompleted = value!;
          });
          context.read<TaskManager>().toggleTask(widget.task);
        },
        title: isCompleted
            ? Text(widget.task.name,
                style: const TextStyle(
                  decoration: TextDecoration.lineThrough,
                ))
            : Text(widget.task.name));
  }
}
