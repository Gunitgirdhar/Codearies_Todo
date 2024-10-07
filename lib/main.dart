import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'AppDatabase.dart';
import 'SplashScreen.dart';
import 'cubit_list.dart';
import 'cubitEvent.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskBloc(db: AppDatabase()), // Initialize with database
      child: MaterialApp(
        title: 'ToDo App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: SplashScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
