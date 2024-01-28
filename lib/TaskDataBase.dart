import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'Task.dart';
import 'dart:developer' as developer;

class TaskDatabase {
  Database? _database;

  Future<void> deleteTask(int id) async {
    await _database!.delete(
      'tasks',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> init() async {
    _database = await openDatabase(
      join(await getDatabasesPath(), 'task.db'),
      onCreate: (db, version) {
        return db.execute(
          'CREATE TABLE tasks(id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, content TEXT, tags TEXT)',
        );
      },
      version: 2,
    );
  }

  Future<void> updateTaskTags(int id, List<String> newTags) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    await _database!.update(
      'tasks',
      {'tags': newTags.join(',')},
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<void> insertTask(Task task) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    await _database!.insert(
      'tasks',
      task.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Task>> getAllTasks() async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    final List<Map<String, dynamic>> maps = await _database!.query('tasks');

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'] as int,
        task: maps[i]['task'] as String,
        content: maps[i]['content'] as String,
        tags: (maps[i]['tags'] as String),
      );
    });
  }

  Future<List<Task>> getTasksByTags([List<String>? tags]) async {
    if (_database == null) {
      throw Exception("Database not initialized");
    }

    String whereClause = tags!.map((tag) => 'tags LIKE ?').join(' AND ');
    List<String> whereArgs = tags.map((tag) => '%$tag%').toList();
    String sql = 'SELECT * FROM tasks WHERE $whereClause';

    developer.log( whereClause, name: 'my.LOG');
    developer.log( '$whereArgs', name: 'my.LOG');

    final List<Map<String, dynamic>> maps = await _database!.rawQuery(sql, whereArgs);

    return List.generate(maps.length, (i) {
      return Task(
        id: maps[i]['id'] as int,
        task: maps[i]['task'] as String,
        content: maps[i]['content'] as String,
        tags: maps[i]['tags'] as String
      );
    });
  }


}