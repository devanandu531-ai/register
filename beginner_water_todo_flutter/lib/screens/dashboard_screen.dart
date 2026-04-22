import 'package:flutter/material.dart';

import '../services/storage_service.dart';
import 'tasks_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _waterCount = 0;
  static const int _goal = 8;

  @override
  void initState() {
    super.initState();
    _loadWater();
  }

  Future<void> _loadWater() async {
    final saved = await StorageService.instance.loadWaterCount();
    if (!mounted) return;
    setState(() => _waterCount = saved);
  }

  Future<void> _addWater() async {
    if (_waterCount >= _goal) return;

    final next = _waterCount + 1;
    setState(() => _waterCount = next);
    await StorageService.instance.saveWaterCount(next);
  }

  @override
  Widget build(BuildContext context) {
    final progress = _waterCount / _goal;

    return Scaffold(
      appBar: AppBar(title: const Text('Daily Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Water Tracker',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_waterCount/$_goal glasses',
                      style: const TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 12),
                    LinearProgressIndicator(value: progress),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: FilledButton.icon(
                        onPressed: _addWater,
                        icon: const Icon(Icons.water_drop),
                        label: const Text('Log one glass'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tasks',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Manage your to-dos and reminders'),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const TasksScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.checklist),
                        label: const Text('Open To-Do List'),
                      ),
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
}
