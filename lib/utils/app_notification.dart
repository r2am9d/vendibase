import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotification {
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'VENDIBASE_NOTIF_MAX',
        'Max Importance Notifications',
        channelDescription: "Channel for max importantance notifications",
        importance: Importance.max,
      ),
      iOS: IOSNotificationDetails(),
    );
  }

  static Future init() async {
    final androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final iosInitSettings = IOSInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification:
          (int, String? title, String? body, String? payload) async {
        onNotification.add(payload);
      },
    );

    final initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _notification.initialize(
      initSettings,
      onSelectNotification: (payload) async {
        onNotification.add(payload);
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    return await _notification.show(
      0,
      title,
      body,
      _notificationDetails(),
      payload: payload,
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime dateTime,
    String? payload,
  }) async {
    return await _notification.zonedSchedule(
      0,
      title,
      body,
      tz.TZDateTime.from(dateTime, tz.local),
      _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }
}
