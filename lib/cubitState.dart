import 'DATAMODEL.dart';

abstract class TaskState {}

// Initial State
class InitialState extends TaskState {}

// Loading State
class LoadingState extends TaskState {}

// Loaded State with List of Tasks
class LoadedState extends TaskState {
  final List<TaskModel> tasks;
  LoadedState({required this.tasks});
}

// Error State with Error Message
class ErrorState extends TaskState {
  final String errorMessage;
  ErrorState({required this.errorMessage});
}
