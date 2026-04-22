import 'dart:convert';

class TodoTask {
  TodoTask({
    required this.id,
    required this.title,
    this.isDone = false,
    this.reminderIso,
  });

  final String id;
  final String title;
  bool isDone;
  String? reminderIso;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'isDone': isDone,
      'reminderIso': reminderIso,
    };
  }

  factory TodoTask.fromMap(Map<String, dynamic> map) {
    return TodoTask(
      id: map['id'] as String,
      title: map['title'] as String,
      isDone: map['isDone'] as bool? ?? false,
      reminderIso: map['reminderIso'] as String?,
    );
  }

  static String encodeList(List<TodoTask> tasks) {
    final mapped = tasks.map((task) => task.toMap()).toList();
    return jsonEncode(mapped);
  }

  static List<TodoTask> decodeList(String source) {
    final decoded = jsonDecode(source) as List<dynamic>;
    return decoded
        .map((item) => TodoTask.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}
