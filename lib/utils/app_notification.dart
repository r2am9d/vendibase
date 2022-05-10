import 'dart:math';

import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:vendibase/theme/app_theme.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppNotification {
  static const int MAX_ID = 2147483647;
  static const String VENDIBASE_CHANNEL = 'vendibase_channel';
  static const String VENDIBASE_GROUP_CHANNEL = 'vendibase_group_channel';

  static int notificationId = 0; // Indicates no notifs has ever been created
  static String? selectedPayload = '';

  static final onNotification = BehaviorSubject<String?>();
  static final _localNotification = FlutterLocalNotificationsPlugin();

  static void notificationTapBackground(response) async {
    selectedPayload = response.payload;
    onNotification.add(response.payload);
  }

  static int _getRandomNumber() => Random().nextInt(AppNotification.MAX_ID);

  static NotificationDetails _notificationDetails() {
    return NotificationDetails(
      android: AndroidNotificationDetails(
        AppNotification.VENDIBASE_CHANNEL,
        'Basic Notifications',
        channelDescription: 'Notification channel for basic notifications',
        priority: Priority.max,
        importance: Importance.max,
        channelShowBadge: true,
        color: AppColor.lightRed,
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

    await _localNotification.initialize(
      initSettings,
      onSelectNotification: (String? payload) async {
        selectedPayload = payload;
        onNotification.add(payload);
      },
      // onDidReceiveNotificationResponse: (NotificationResponse response) async {
      //   selectedPayload = response.payload;
      //   onNotification.add(response.payload);
      // },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    String? payload,
  }) async {
    notificationId = _getRandomNumber();

    return await _localNotification.show(
      notificationId,
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
    // Debugging notifs
    // final _dt = tz.TZDateTime.now(tz.local).add(Duration(seconds: 15));

    notificationId = _getRandomNumber();
    final _dt = tz.TZDateTime.from(dateTime, tz.local).add(Duration(hours: 8));

    return await _localNotification.zonedSchedule(
      notificationId,
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
    return await _localNotification.cancel(id);
  }

  static Future<NotificationAppLaunchDetails?> getLaunchDetails() async {
    return await _localNotification.getNotificationAppLaunchDetails();
  }

  static void resetPayload() {
    selectedPayload = '';
  }
}
