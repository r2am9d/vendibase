import 'dart:math';

import 'package:timezone/timezone.dart' as tz;
import 'package:vendibase/theme/app_theme.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

class AppNotificationAlt {
  static const String VENDIBASE_CHANNEL = 'vendibase_channel';
  static const String VENDIBASE_GROUP_CHANNEL = 'vendibase_group_channel';

  static int notificationId = 0; // Indicates no notifs has ever been created
  static final awesomeNotification = AwesomeNotifications();

  static int _getRandomNumber() => Random().nextInt(AwesomeNotifications.maxID);

  static Future<void> init() async {
    await awesomeNotification.initialize(
      null,
      [
        NotificationChannel(
          channelKey: AppNotificationAlt.VENDIBASE_CHANNEL,
          channelGroupKey: AppNotificationAlt.VENDIBASE_GROUP_CHANNEL,
          channelName: 'Basic Notifications',
          channelDescription: 'Notification channel for basic notifications',
          channelShowBadge: true,
          defaultColor: AppColor.lightRed,
          ledColor: AppColor.lightRed,
          importance: NotificationImportance.High,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupkey: AppNotificationAlt.VENDIBASE_GROUP_CHANNEL,
          channelGroupName: 'Basic Group Notifications',
        ),
      ],
      debug: true,
    );

    await awesomeNotification.requestPermissionToSendNotifications(
      channelKey: AppNotificationAlt.VENDIBASE_CHANNEL,
      permissions: [
        NotificationPermission.Alert,
        NotificationPermission.Sound,
        NotificationPermission.Badge,
        NotificationPermission.Vibration,
        NotificationPermission.Light
      ],
    );
  }

  static Future<void> showNotification({
    required String title,
    required String body,
    Map<String, String>? payload,
  }) async {
    notificationId = _getRandomNumber();

    await awesomeNotification.createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: AppNotificationAlt.VENDIBASE_CHANNEL,
        title: title,
        body: body,
        payload: payload,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'NOTIFICATION_DONE',
          label: 'Done',
          showInCompactView: true,
          buttonType: ActionButtonType.KeepOnTop,
        )
      ],
    );
  }

  static Future<void> scheduleNotification({
    required String title,
    required String body,
    required DateTime dateTime,
    Map<String, String>? payload,
  }) async {
    notificationId = _getRandomNumber();
    final _dateTime = tz.TZDateTime.from(dateTime, tz.local);

    await awesomeNotification.createNotification(
      content: NotificationContent(
        id: notificationId,
        channelKey: AppNotificationAlt.VENDIBASE_CHANNEL,
        title: title,
        body: body,
        payload: payload,
        wakeUpScreen: true,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        day: _dateTime.day,
        hour: 7, // 8am
        minute: _dateTime.minute,
        second: 5,
        millisecond: 0,
        repeats: true,
        allowWhileIdle: true,
        timeZone: tz.local.name,
      ),
      actionButtons: [
        NotificationActionButton(
          key: 'NOTIFICATION_DONE',
          label: 'Done',
          showInCompactView: true,
          buttonType: ActionButtonType.KeepOnTop,
        ),
      ],
    );
  }

  static Future<void> cancelNotification(int id) async {
    return await awesomeNotification.cancel(id);
  }
}
