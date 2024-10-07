class TaskModel {
  int? taskId;
  String title;
  String description;
  DateTime dueDate;
  bool isComplete;

  TaskModel({
    this.taskId,
    required this.title,
    required this.description,
    required this.dueDate,
    this.isComplete = false,
  });

  // Factory method to convert map to TaskModel
  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      taskId: map['task_id'],
      title: map['title'],
      description: map['description'],
      dueDate: DateTime.parse(map['due_date']),
      isComplete: map['is_complete'] == 1,
    );
  }

  // Method to convert TaskModel to map for database insertion
  Map<String, dynamic> toMap() {
    return {
      'task_id': taskId,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'is_complete': isComplete ? 1 : 0,
    };
  }
}
