import 'package:sqflite/sqflite.dart';
import 'DATAMODEL.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._();
  static Database? _database;

  AppDatabase._();

  factory AppDatabase() {
    return _instance;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    return await openDatabase(
      'tasks.db',
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE tasks (
            task_id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            description TEXT,
            due_date TEXT,
            is_complete INTEGER
          )
        ''');
      },
    );
  }

  // Fetch all tasks, ordered by due date
  Future<List<TaskModel>> fetchTasks() async {
    final db = await database;
    // Added orderBy clause to sort tasks by due date in ascending order
    final List<Map<String, dynamic>> maps = await db.query('tasks', orderBy: 'due_date ASC');
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }

  // Add new task
  Future<bool> addTask(TaskModel task) async {
    final db = await database;
    await db.insert('tasks', task.toMap());
    return true;
  }

  // Update existing task
  Future<bool> updateTask(TaskModel task) async {
    final db = await database;
    await db.update(
      'tasks',
      task.toMap(),
      where: 'task_id = ?',
      whereArgs: [task.taskId],
    );
    return true;
  }

  // Delete task by task ID
  Future<void> deleteTask(int id) async {
    final db = await database;
    await db.delete(
      'tasks',
      where: 'task_id = ?',
      whereArgs: [id],
    );
  }

  // Search for tasks by title (case-insensitive)
  Future<List<TaskModel>> searchTasks(String query) async {
    final db = await database;
    // Added where clause to filter tasks by title
    final List<Map<String, dynamic>> maps = await db.query(
      'tasks',
      where: 'title LIKE ?',
      whereArgs: ['%$query%'],
    );
    return List.generate(maps.length, (i) {
      return TaskModel.fromMap(maps[i]);
    });
  }
}
