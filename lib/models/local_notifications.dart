import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static Future init() async {
    tz.initializeTimeZones();
    //TODO: local time

    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification: (id, title, body, payload) => null);
    final LinuxInitializationSettings initializationSettingsLinux =
        LinuxInitializationSettings(defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsDarwin,
            linux: initializationSettingsLinux);
    _flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: (details) => null);
  }

  static Future showSimpleNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails('channel 1', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails notificationDetails =
        NotificationDetails(android: androidNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, notificationDetails, payload: payload);
  }

  static Future<void> showScheduledNotificationDaily(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required DateTime dateTime}) async {
    print("Inside schedule");
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        _nextInstanceOfTime(dateTime),
        const NotificationDetails(
          android: AndroidNotificationDetails('Daily notification channel id',
              'daily notification channel name',
              channelDescription: 'daily notification description'),
        ),
        payload: payload,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }

  static Future<void> showScheduledNotification(
      {required int id,
      required String title,
      required String body,
      required String payload,
      required DateTime dateTime}) async {
    print("Inside schedule");
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      _nextInstanceOfTime(dateTime),
      const NotificationDetails(
        android: AndroidNotificationDetails(
            'Notification channel id', 'notification channel name',
            channelDescription: 'notification description'),
      ),
      payload: payload,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> showWeeklyNotification({required id, required DateTime dateTime}) async {
    print('Inside weekly notify');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Time for Sleep',
        'Good Night Buddy !! Have a sweet Dream !!',
        _nextInstanceOfDay(dateTime),
        const NotificationDetails(
          android: AndroidNotificationDetails('weekly sleep notification channel id',
              'weekly sleep notification channel',
              channelDescription: 'Reminder for weekly sleep'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }

  static Future<void> showWeeklyAlarm({required id, required DateTime dateTime}) async {
    print('Inside wakeup notify');
    await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        'Rise and Shine',
        'Good Morning Buddy !! Have a great day !!',
        _nextInstanceOfDay(dateTime),
        const NotificationDetails(
          android: AndroidNotificationDetails('Weekly wakeup alarm channel ID',
              'weekly wakeup notification channel',
              channelDescription: 'Reminder for weekly wakeup', playSound: true,sound: RawResourceAndroidNotificationSound('alarm')),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime);
  }


  static tz.TZDateTime _nextInstanceOfTime(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    print(now.toString());
    tz.TZDateTime desiredTime = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    // Check if desired time has already passed today (including date)

    print(desiredTime.isBefore(now));
    if (desiredTime.isBefore(now)) {
      // Schedule for tomorrow
      desiredTime = desiredTime.add(const Duration(days: 1));
    }
    // Schedule for today
    print(desiredTime.toString());
    return desiredTime;
  }

  static tz.TZDateTime _nextInstanceOfDay(DateTime dateTime) {
    final now = tz.TZDateTime.now(tz.local);
    print(now.toString());
    tz.TZDateTime desiredTime = tz.TZDateTime.from(
      dateTime,
      tz.local,
    );

    // Check if desired time has already passed today (including date)

    print(desiredTime.isBefore(now));
    if (desiredTime.isBefore(now)) {
      // Schedule for tomorrow
      desiredTime = desiredTime.add(const Duration(days: 7));
    }
    // Schedule for today
    print('desired time weekly:');
    print(desiredTime.toString());

    return desiredTime;
  }

  static Future getPending() async {
    final List<PendingNotificationRequest> pendingNotificationRequests =
        await _flutterLocalNotificationsPlugin.pendingNotificationRequests();
    print(pendingNotificationRequests.length);
    return pendingNotificationRequests;
  }

  static Future getActive() async {
    final List<ActiveNotification> activeNotifications =
        await _flutterLocalNotificationsPlugin.getActiveNotifications();
    print(activeNotifications.length);
    return activeNotifications;
  }

  static Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  static Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

}
