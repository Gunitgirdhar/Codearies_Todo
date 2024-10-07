import 'package:flutter_bloc/flutter_bloc.dart';
import 'AppDatabase.dart';
import 'cubitEvent.dart';
import 'cubitState.dart';

class TaskBloc extends Bloc<TaskEvent, TaskState> {
  final AppDatabase db;

  TaskBloc({required this.db}) : super(InitialState()) {
    // Adding Task
    on<AddingTask>((event, emit) async {
      emit(LoadingState());
      bool result = await db.addTask(event.task);
      if (result) {
        var tasks = await db.fetchTasks();
        emit(LoadedState(tasks: tasks));
      } else {
        emit(ErrorState(errorMessage: 'Failed to add task'));
      }
    });

    // Updating Task
    on<UpdatingTask>((event, emit) async {
      emit(LoadingState());
      bool result = await db.updateTask(event.task);
      if (result) {
        var tasks = await db.fetchTasks();
        emit(LoadedState(tasks: tasks));
      } else {
        emit(ErrorState(errorMessage: 'Failed to update task'));
      }
    });

    // Deleting Task
    on<DeletingTask>((event, emit) async {
      emit(LoadingState());
      try {
        await db.deleteTask(event.taskId);
        var tasks = await db.fetchTasks();
        emit(LoadedState(tasks: tasks));
      } catch (e) {
        emit(ErrorState(errorMessage: 'Failed to delete task'));
      }
    });

    // Fetching Tasks
    on<FetchTasks>((event, emit) async {
      emit(LoadingState());
      var tasks = await db.fetchTasks();
      emit(LoadedState(tasks: tasks));
    });

    // Searching Tasks by Title
    on<SearchTasks>((event, emit) async {
      emit(LoadingState());
      var tasks = await db.searchTasks(event.query);
      emit(LoadedState(tasks: tasks));
    });
  }
}
