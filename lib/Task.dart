class Task {
  final int? id;
  final String task;
  final String content;
  final String tags;

  Task({required this.id, required this.task, required this.content, required this.tags});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'task': task,
      'content': content,
      'tags': tags,
    };
  }
}