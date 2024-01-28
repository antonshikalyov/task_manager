import 'package:flutter/material.dart';
import 'package:task_manager/Bloc.dart';
import 'Task.dart';
import 'TaskDataBase.dart';
import 'dart:developer' as developer;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final taskDatabase = TaskDatabase();
  await taskDatabase.init();
  // await taskDatabase.insertTask(task);
  await taskDatabase.deleteTask(1);
  print(await taskDatabase.getAllTasks());

  runApp(MyApp());
}



class MyApp extends StatefulWidget {
  final formKey = GlobalKey();

  MyApp();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Bloc bloc = Bloc();
  final taskDatabase = TaskDatabase();
  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {

    bloc.getAllTasks();
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          title: const Text('Task manager'),
          backgroundColor: Colors.blue,
        ),
        body: Stack(
          children: [
            Column(
              children: [
                TextField(
                  onChanged: (text) {
                    List<String> tags = text.split(',').toList();
                    bloc.getTags(tags);
                  }
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: bloc.tasksStream,
                    builder: (context, AsyncSnapshot<List<Task>> snapshot) {
                      List<Task>? tasks = snapshot.data;
                      return ListView.builder(
                        itemCount: tasks?.length ?? 0,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            tileColor: Colors.green,
                            title: Text(tasks![index].task),
                            subtitle: Text(tasks[index].tags),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TaskDetailsScreen(task: tasks[index]),
                                ),
                              );
                            },
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                FloatingActionButton(

                                  heroTag: 'additional_action_1_$index', // Unique tag for each hero
                                  backgroundColor: Colors.blue,
                                  tooltip: 'Additional Action 1',
                                  onPressed: () {
                                    bloc.updateTask(Task(id: tasks[index].id, task: tasks[index].task, content: tasks[index].task, tags: "tag1, tag2"));
                                  },
                                  child: const Icon(Icons.add_box, color: Colors.white, size: 28),
                                ),

                                const SizedBox(width: 12),

                                FloatingActionButton(
                                  heroTag: 'additional_action_2_$index', // Unique tag for each hero
                                  backgroundColor: Colors.red,
                                  tooltip: 'Additional Action 2',
                                  onPressed: () {
                                    bloc.removeTask(tasks[index].id!);
                                  },
                                  child: const Icon(Icons.highlight_remove, color: Colors.white, size: 28),
                                ),

                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FloatingActionButton(
                      heroTag: 'additional_action_1_',
                      backgroundColor: Colors.blue,
                      tooltip: 'Additional Action 1',
                      onPressed: () async {
                        bloc.updateTag();
                        TaskDatabase taskDb = TaskDatabase();

                        int taskIdToUpdate = 0;
                        List<String> newTags = ['tag1', 'tag2', 'tag3'];

                        await taskDb.updateTaskTags(taskIdToUpdate, newTags);
                      },
                      child: const Icon(Icons.check, color: Colors.white, size: 28),
                    ),
                    const SizedBox(height: 8),
                    FloatingActionButton(
                      heroTag: 'additional_action_2_',
                      backgroundColor: Colors.amber,
                      tooltip: 'Additional Action 2',
                      onPressed: () {
                        bloc.updateTask(Task(id: null, task: "some", content: "content", tags: "tag4, tag44"));
                      },
                      child: const Icon(Icons.add, color: Colors.white, size: 28),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }
}


class TaskDetailsScreen extends StatefulWidget {
  final Task task;

  TaskDetailsScreen({required this.task});

  @override
  _TaskDetailsScreenState createState() => _TaskDetailsScreenState();
}

class _TaskDetailsScreenState extends State<TaskDetailsScreen> {
  late TextEditingController _controllerTag;
  late TextEditingController _controllerContent;
  late TextEditingController _controllerTask;
  Bloc bloc = Bloc();



  @override
  void initState() {
    super.initState();

    // Инициализация контроллера с текстом тегов
    _controllerContent = TextEditingController(text: widget.task.content);
    _controllerTask = TextEditingController(text: widget.task.task);
    _controllerTag = TextEditingController(text: widget.task.tags);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task.task),
      ),
      body: Column(
        children: [
          const Text('Task: '),
          TextField(
            controller: _controllerTask,
            onChanged: (text) async {
              final taskDatabase = TaskDatabase();
              await taskDatabase.init();
              developer.log( text, name: 'my.LOG');
              // List<String> tags = text.split(',');
              //
              // // Обновляем теги в базе данных
              bloc.updateTask(Task(
                id: widget.task.id,
                task: text,
                content: widget.task.content,
                tags: widget.task.tags,
              ));
            },
          ),
          const Text('Content: '),
          TextField(
            controller: _controllerContent,
            onChanged: (text) async {
              final taskDatabase = TaskDatabase();
              await taskDatabase.init();
              developer.log( text, name: 'my.LOG');
              // List<String> tags = text.split(',');
              //
              // // Обновляем теги в базе данных
              bloc.updateTask(Task(
                id: widget.task.id,
                task: widget.task.task,
                content: text,
                tags: widget.task.tags,
              ));
            },
          ),
          const Text('Tag: '),
          TextField(
            controller: _controllerTag,
            onChanged: (text) async {
              final taskDatabase = TaskDatabase();
              await taskDatabase.init();
              developer.log( text, name: 'my.LOG');
              // List<String> tags = text.split(',');
              //
              // // Обновляем теги в базе данных
                bloc.updateTask(Task(
                id: widget.task.id,
                task: widget.task.task,
                content: widget.task.content,
                tags: text,
              ));
            },
          ),
          // Add other widgets or information as needed
        ],
      ),
    );
  }

}
