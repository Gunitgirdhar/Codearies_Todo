import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_intern/page_02.dart'; // Ensure you import your cubit
import 'DATAMODEL.dart';

import 'package:intl/intl.dart';

import 'cubitEvent.dart';
import 'cubitState.dart';
import 'cubit_list.dart';

class ViewTasksPage extends StatefulWidget {
  @override
  _ViewTasksPageState createState() => _ViewTasksPageState();
}

class _ViewTasksPageState extends State<ViewTasksPage> {
  late TaskBloc taskBloc;
  TextEditingController searchController = TextEditingController();
  List<TaskModel> filteredTasks = []; // List to hold filtered tasks

  @override
  void initState() {
    super.initState();
    taskBloc = BlocProvider.of<TaskBloc>(context);
    searchController.addListener(() {
      filterTasks();
    });
  }

  void filterTasks() {
    String query = searchController.text.toLowerCase();

    if (query.isEmpty) {
      // If search text is empty, reset the filteredTasks to all tasks
      taskBloc.add(FetchTasks());
    } else {
      // Filter tasks based on the search query
      setState(() {
        filteredTasks = taskBloc.state is LoadedState
            ? (taskBloc.state as LoadedState).tasks
            .where((task) => task.title.toLowerCase().contains(query))
            .toList()
            : [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Tracker'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search tasks...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
            child: BlocBuilder<TaskBloc, TaskState>(
              builder: (context, state) {
                if (state is LoadingState) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is LoadedState) {
                  final tasksToDisplay = searchController.text.isEmpty
                      ? state.tasks
                      : filteredTasks;

                  return ListView.builder(
                    itemCount: tasksToDisplay.length,
                    itemBuilder: (context, index) {
                      final task = tasksToDisplay[index];
                      return ListTile(
                        title: Text(task.title),
                        subtitle: Text('Due: ${DateFormat('yyyy-MM-dd').format(task.dueDate)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: task.isComplete,
                              onChanged: (bool? value) {
                                setState(() {
                                  task.isComplete = value ?? false;
                                  taskBloc.add(UpdatingTask(task: task));
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.edit),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AddEditTaskPage(task: task),
                                  ),
                                );
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                taskBloc.add(DeletingTask(taskId: task.taskId!));
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is ErrorState) {
                  return Center(child: Text('Error: ${state.errorMessage}'));
                }
                return Center(child: Text('No tasks found.'));
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddEditTaskPage()),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }
}
