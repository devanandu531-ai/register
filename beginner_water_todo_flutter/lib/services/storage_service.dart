import 'package:shared_preferences/shared_preferences.dart';

import '../models.dart';

class StorageService {
  StorageService._();
  static final instance = StorageService._();

  static const _waterCountKey = 'water_count';
  static const _waterDateKey = 'water_date';
  static const _tasksKey = 'tasks';

  Future<int> loadWaterCount() async {
    final prefs = await SharedPreferences.getInstance();
    final today = _todayString();
    final savedDate = prefs.getString(_waterDateKey);

    if (savedDate != today) {
      await prefs.setString(_waterDateKey, today);
      await prefs.setInt(_waterCountKey, 0);
      return 0;
    }

    return prefs.getInt(_waterCountKey) ?? 0;
  }

  Future<void> saveWaterCount(int count) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_waterDateKey, _todayString());
    await prefs.setInt(_waterCountKey, count);
  }

  Future<List<TodoTask>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = prefs.getString(_tasksKey);

    if (encoded == null || encoded.isEmpty) {
      return [];
    }

    return TodoTask.decodeList(encoded);
  }

  Future<void> saveTasks(List<TodoTask> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tasksKey, TodoTask.encodeList(tasks));
  }

  String _todayString() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }
}
