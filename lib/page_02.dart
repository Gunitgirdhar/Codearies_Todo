import 'package:flutter/material.dart';
import 'DATAMODEL.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubitEvent.dart';
import 'cubit_list.dart';


class AddEditTaskPage extends StatefulWidget {
  final TaskModel? task;  // If task is null, we're adding a new task, otherwise we're editing

  AddEditTaskPage({this.task});

  @override
  _AddEditTaskPageState createState() => _AddEditTaskPageState();
}

class _AddEditTaskPageState extends State<AddEditTaskPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;
  DateTime dueDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      title = widget.task!.title;
      description = widget.task!.description;
      dueDate = widget.task!.dueDate;
    } else {
      title = '';
      description = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task != null ? 'Edit Task' : 'Add Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: title,
                decoration: InputDecoration(labelText: 'Task Title'),
                onSaved: (value) {
                  title = value!;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a task title';
                  }
                  return null;
                },
              ),
              TextFormField(
                initialValue: description,
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) {
                  description = value!;
                },
              ),
              // Date Picker for Due Date
              Row(
                children: [
                  Text('Due Date: ${dueDate.toLocal()}'),
                  Spacer(),
                  ElevatedButton(
                    onPressed: () async {
                      final selectedDate = await showDatePicker(
                        context: context,
                        initialDate: dueDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (selectedDate != null && selectedDate != dueDate) {
                        setState(() {
                          dueDate = selectedDate;
                        });
                      }
                    },
                    child: Text('Pick Date'),
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    final newTask = TaskModel(
                      taskId: widget.task?.taskId,  // Use existing taskId if editing
                      title: title,
                      description: description,
                      dueDate: dueDate,
                      isComplete: widget.task?.isComplete ?? false,
                    );
                    if (widget.task == null) {
                      BlocProvider.of<TaskBloc>(context).add(AddingTask(task: newTask));
                    } else {
                      BlocProvider.of<TaskBloc>(context).add(UpdatingTask(task: newTask));
                    }
                    Navigator.pop(context);
                  }
                },
                child: Text(widget.task != null ? 'Update Task' : 'Add Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
