import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tzl;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationsServices {
  static final _localnotification = FlutterLocalNotificationsPlugin();

  static bool notificationEnabled = false;

  static Future<void> requestPermission() async {
    if (Platform.isIOS || Platform.isMacOS) {
      /// agar [IOS] bo'lsa shu orqali ruxsat so'raymiz
      notificationEnabled = await _localnotification
          .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      ) ??
          false;

      await _localnotification
          .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    } else if (Platform.isAndroid) {
      /// agar [Android] bo'lsa bundan foydalanamiz
      final androidImplementation =
      _localnotification.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // bu yerda darhol xabarnomaga ruhsat so'raymiz.
      final bool? grantedNotificationPermission =
      await androidImplementation?.requestExactAlarmsPermission();

      // bu yerda rejali xabarnomaga ruxsat so'raymiz
      final bool? grantedScheduleNotificationPermission =
      await androidImplementation?.requestExactAlarmsPermission();

      //! kamchilik:
      //? ikkalasi uchunham bitta o'zgaruvchi ishlatilgan!
      notificationEnabled = grantedNotificationPermission ?? false;
      notificationEnabled = grantedScheduleNotificationPermission ?? false;
    }
  }

  static Future<void> start() async {
    final currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tzl.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    /// [Adroid] va [IOS] uchun sozlamalarni to'g'irlaymiz
    const androidInit = AndroidInitializationSettings("xasan");
    final iosInit = DarwinInitializationSettings(
      notificationCategories: [
        DarwinNotificationCategory(
          'demoCategory',
          actions: <DarwinNotificationAction>[
            DarwinNotificationAction.plain('id_1', 'Action 1'),
            DarwinNotificationAction.plain(
              'id_2',
              'Action 2',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.destructive,
              },
            ),
            DarwinNotificationAction.plain(
              'id_3',
              'Action 3',
              options: <DarwinNotificationActionOption>{
                DarwinNotificationActionOption.foreground,
              },
            ),
          ],
          options: <DarwinNotificationCategoryOption>{
            DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
          },
        )
      ],
    );

    final notificationInit = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    await _localnotification.initialize(
      notificationInit,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) async {
        print(notificationResponse.payload);
      },
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );
  }

  static void showNotification() async {
    // android va ios uchun qanday turdagi xabar ko'rsatishi kerakligini aytamiz

    const androidDetails = AndroidNotificationDetails(
      "goodchannelId",
      "goodchannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      actions: [
        AndroidNotificationAction("id_1", "Action 1"),
      ],
    );
    // const iosDetails = DarwinNotificationDetails(

    // );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localnotification.show(
      0,
      "Birinchi notifiaction",
      "asdfghjhgfdswertyujhgfvc",
      notificationDetails,
    );
  }

  static void scheduleNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "goodchannelId",
      "goodchannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      actions: [
        AndroidNotificationAction("id_1", "Action 1"),
      ],
    );
    // const iosDetails = DarwinNotificationDetails(

    // );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localnotification.zonedSchedule(
      0,
      "Schedule notification",
      "5 sekundan keyin kelgan xabar",
      tz.TZDateTime.now(tz.local).add(
        const Duration(seconds: 5),
      ),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static Future<void> scheduleDailyMotivationNotification(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "motivation_channel",
      "Motivation Channel",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final tz.TZDateTime scheduledDate = _nextInstanceOfEightAM();

    await _localnotification.zonedSchedule(
      0,
      title,
      body,
      scheduledDate,
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfEightAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, 8);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  static Future<void> scheduleTestNotification() async {
    const androidDetails = AndroidNotificationDetails(
      "testchannelId",
      "testchannelName",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
      actions: [
        AndroidNotificationAction("id_1", "Action 1"),
      ],
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localnotification.zonedSchedule(
      0,
      "Test Message",
      "This is a test notification",
      _nextInstanceOfFiveSeconds(),
      notificationDetails,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  static tz.TZDateTime _nextInstanceOfFiveSeconds() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = now.add(const Duration(seconds: 5));
    return scheduledDate;
  }

  static Future<void> showNotificationTest(String title, String body) async {
    const androidDetails = AndroidNotificationDetails(
      "motivation_channel",
      "Motivation Channel",
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: RawResourceAndroidNotificationSound("notification"),
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    await _localnotification.show(
      0,
      title,
      body,
      notificationDetails,
    );
  }

// static void sendMotivation() async {
//   scheduleDailyMotivationNotification();
// }
}