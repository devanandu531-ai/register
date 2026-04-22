import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();
  static final instance = NotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const settings = InitializationSettings(android: androidSettings);

    await _plugin.initialize(settings);

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    await scheduleWaterReminderEvery2Hours();
  }

  NotificationDetails _defaultDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'main_channel',
        'Main Notifications',
        channelDescription: 'General app reminders',
        importance: Importance.max,
        priority: Priority.high,
      ),
    );
  }

  Future<void> scheduleWaterReminderEvery2Hours() async {
    await _plugin.cancel(1001);

    await _plugin.periodicallyShow(
      1001,
      'Drink Water',
      'Time to drink a glass of water 💧',
      RepeatInterval.hourly,
      _defaultDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  Future<void> scheduleTaskReminder({
    required int notificationId,
    required String title,
    required DateTime scheduledAt,
  }) async {
    final scheduledTz = tz.TZDateTime.from(scheduledAt, tz.local);

    await _plugin.zonedSchedule(
      notificationId,
      'Task Reminder',
      title,
      scheduledTz,
      _defaultDetails(),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: null,
    );
  }

  Future<void> cancelTaskReminder(int notificationId) async {
    await _plugin.cancel(notificationId);
  }
}
