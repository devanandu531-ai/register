import 'package:flutter/material.dart';

import '../models.dart';
import '../services/notification_service.dart';
import '../services/storage_service.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<TodoTask> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final loaded = await StorageService.instance.loadTasks();
    if (!mounted) return;
    setState(() {
      _tasks
        ..clear()
        ..addAll(loaded);
    });
  }

  Future<void> _saveTasks() async {
    await StorageService.instance.saveTasks(_tasks);
  }

  Future<void> _addTask() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;

    final task = TodoTask(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: text,
    );

    setState(() {
      _tasks.insert(0, task);
      _controller.clear();
    });

    await _saveTasks();
  }

  Future<void> _toggleTask(TodoTask task, bool? checked) async {
    setState(() => task.isDone = checked ?? false);
    await _saveTasks();
  }

  Future<void> _deleteTask(TodoTask task) async {
    setState(() => _tasks.remove(task));
    await NotificationService.instance.cancelTaskReminder(task.id.hashCode);
    await _saveTasks();
  }

  Future<void> _pickReminder(TodoTask task) async {
    final now = DateTime.now();
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime == null) return;

    var scheduledAt = DateTime(
      now.year,
      now.month,
      now.day,
      pickedTime.hour,
      pickedTime.minute,
    );

    if (scheduledAt.isBefore(now)) {
      scheduledAt = scheduledAt.add(const Duration(days: 1));
    }

    await NotificationService.instance.scheduleTaskReminder(
      notificationId: task.id.hashCode,
      title: task.title,
      scheduledAt: scheduledAt,
    );

    setState(() => task.reminderIso = scheduledAt.toIso8601String());
    await _saveTasks();

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Reminder set for ${pickedTime.format(context)}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('To-Do List')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'New task',
                    ),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  height: 56,
                  child: FilledButton(
                    onPressed: _addTask,
                    child: const Text('Add'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _tasks.isEmpty
                  ? const Center(
                      child: Text('No tasks yet. Add your first task!'),
                    )
                  : ListView.separated(
                      itemCount: _tasks.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 8),
                      itemBuilder: (_, index) {
                        final task = _tasks[index];
                        return Card(
                          child: ListTile(
                            leading: Checkbox(
                              value: task.isDone,
                              onChanged: (checked) => _toggleTask(task, checked),
                            ),
                            title: Text(
                              task.title,
                              style: TextStyle(
                                decoration: task.isDone
                                    ? TextDecoration.lineThrough
                                    : TextDecoration.none,
                              ),
                            ),
                            subtitle: task.reminderIso == null
                                ? null
                                : Text('Reminder: ${task.reminderIso}'),
                            trailing: Wrap(
                              spacing: 8,
                              children: [
                                IconButton(
                                  tooltip: 'Set reminder',
                                  onPressed: () => _pickReminder(task),
                                  icon: const Icon(Icons.alarm),
                                ),
                                IconButton(
                                  tooltip: 'Delete task',
                                  onPressed: () => _deleteTask(task),
                                  icon: const Icon(Icons.delete),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
