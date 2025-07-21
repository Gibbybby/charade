import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;
import 'dart:math';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'notification_messages.dart';

class NotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    if (kIsWeb) return; // Local notifications unsupported on web
    if (!(Platform.isAndroid || Platform.isIOS ||
        Platform.isMacOS || Platform.isWindows)) {
      return; // Skip initialization on unsupported platforms
    }

    const android = AndroidInitializationSettings('@mipmap/ic_launcher');
    const ios = DarwinInitializationSettings();
    const settings = InitializationSettings(android: android, iOS: ios);

    await _plugin.initialize(settings);
    tz.initializeTimeZones();
  }

  static Future<void> scheduleWeeklyAlternating() async {
    if (kIsWeb) return;
    if (!(Platform.isAndroid || Platform.isIOS ||
        Platform.isMacOS || Platform.isWindows)) {
      return;
    }

    var now = tz.TZDateTime.now(tz.local);
    var firstFriday = _nextInstanceOfWeekdayTime(DateTime.friday, 18, 0, now);
    var firstSaturday = _nextInstanceOfWeekdayTime(DateTime.saturday, 20, 0, now);

    var nextDate = firstFriday;
    bool isFriday = true;
    final random = Random();
    for (int i = 0; i < 20; i++) {
      final message = notificationMessages[random.nextInt(notificationMessages.length)];
      await _plugin.zonedSchedule(
        100 + i,
        'Time to play',
        message,
        nextDate,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'weekly_charade',
            'Charade Notifications',
            channelDescription: 'Reminders to play the game',
          ),
          iOS: DarwinNotificationDetails(),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
      nextDate = nextDate.add(Duration(days: isFriday ? 8 : 6));
      isFriday = !isFriday;
    }
  }

  static tz.TZDateTime _nextInstanceOfWeekdayTime(
      int weekday, int hour, int minute, tz.TZDateTime from) {
    var scheduled = tz.TZDateTime(tz.local, from.year, from.month, from.day, hour, minute);
    while (scheduled.isBefore(from) || scheduled.weekday != weekday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
