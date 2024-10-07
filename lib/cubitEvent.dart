import 'DATAMODEL.dart';

abstract class TaskEvent {}

// Adding Task Event
class AddingTask extends TaskEvent {
  final TaskModel task;
  AddingTask({required this.task});
}

// Updating Task Event
class UpdatingTask extends TaskEvent {
  final TaskModel task;
  UpdatingTask({required this.task});
}

// Deleting Task Event
class DeletingTask extends TaskEvent {
  final int taskId;
  DeletingTask({required this.taskId});
}

// Fetch Tasks Event
class FetchTasks extends TaskEvent {}

// Search Task Event
class SearchTasks extends TaskEvent {
  final String query;
  SearchTasks({required this.query});
}
