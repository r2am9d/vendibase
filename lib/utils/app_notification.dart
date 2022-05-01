import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotification {
  static int notifId = 0; // 0 indicates no notifs has been created
  static String selectedPayload = '';
  static final _notification = FlutterLocalNotificationsPlugin();
  static final onNotification = BehaviorSubject<String?>();

  static NotificationDetails _notificationDetails() {
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

  static Future<void> init() async {
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
        selectedPayload = payload!;
        onNotification.add(payload);
      },
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    notifId++;
    final _id = notifId;
    return await _notification.show(
      _id,
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
    notifId++;
    final _id = notifId;

    final _dt = tz.TZDateTime.from(dateTime, tz.local);
    // Debugging notifs
    // tz.TZDateTime.now(tz.local).add(const Duration(seconds: 15));

    return await _notification.zonedSchedule(
      _id,
      title,
      body,
      _dt,
      _notificationDetails(),
      payload: payload,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static Future<void> cancelNotification(int id) async {
    return await _notification.cancel(id);
  }

  static Future<NotificationAppLaunchDetails?> getLaunchDetails() async {
    return await _notification.getNotificationAppLaunchDetails();
  }

  static void resetPayload() {
    selectedPayload = '';
  }
}
