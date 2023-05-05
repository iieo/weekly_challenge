//only saved locally

class Task {
  final String name;
  bool isCompleted;
  DateTime? dateCompleted;
  final String category;

  Task(
      {required this.name,
      this.category = "default",
      this.isCompleted = false,
      this.dateCompleted});

  @override
  String toString() {
    return 'Task{name: $name, category: $category dateCompleted: $dateCompleted}';
  }
}
