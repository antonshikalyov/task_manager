import 'dart:async';
import 'Task.dart';
import 'TaskDataBase.dart';
class Bloc {
  TaskDatabase database = TaskDatabase();

  final _tasksController = StreamController<List<Task>>.broadcast();
  Stream<List<Task>> get tasksStream => _tasksController.stream;


  Future<List<Task>> getAllTasks() async {
    await database.init();
    final List<Task> tasks = await database.getAllTasks();
    _tasksController.add(tasks);
    return tasks; // Возвращаем список задач
  }

  Future<List<Task>> updateTag() async {
    await database.init();

    final List<Task> tasks = await database.getAllTasks();
    _tasksController.add(tasks);
    return tasks; // Возвращаем список задач
  }

  Future<void> addTask(Task task) async {
    await database.init();
    database.insertTask(task);
    await getAllTasks(); // Используем await, чтобы дождаться завершения getAllTasks
  }

  Future<void> getTags(List<String> x) async {
    await database.init();
    final List<Task> tasks = await database.getTasksByTags(x);
    _tasksController.add(tasks);
  }

  Future<void> removeTask(int taskId) async {
    await database.init();
    database.deleteTask(taskId);
    await getAllTasks(); // Используем await, чтобы дождаться завершения getAllTasks
  }

  Future<void> updateTask(Task task) async {
    await database.init();
    database.insertTask(task);
    await getAllTasks(); // Используем await, чтобы дождаться завершения getAllTasks
  }

  void dispose() {
    _tasksController.close();
  }
}
