import 'dart:convert';
import 'dart:io';
import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:merchant/commons/views/_listen_notification.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/domain/data/models/received_notification.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:rxdart/subjects.dart';

@pragma('vm:entry-point')
class LocalNotificationUtil {
  LocalNotificationUtil() {
    flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    didReceiveLocalNotificationSubject ??=
        BehaviorSubject<ReceivedNotification>();
    selectNotificationSubject ??= BehaviorSubject<String>();
  }

  static FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  // Streams are created so that app can respond to notification-related events since the plugin is initialised in the `main` function
  static BehaviorSubject<ReceivedNotification>?
  didReceiveLocalNotificationSubject;

  static BehaviorSubject<String>? selectNotificationSubject =
      BehaviorSubject<String>();

  static NotificationAppLaunchDetails? notificationAppLaunchDetails;
  static Map<String, dynamic>? _pendingNavigationData;

  void init() async {
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin
            ?.getNotificationAppLaunchDetails();
    var initializationSettingsAndroid = const AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    var initializationSettingsIOS = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const DarwinInitializationSettings initializationSettingsMacOS =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
      macOS: initializationSettingsMacOS,
    );
    await flutterLocalNotificationsPlugin!.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            final payload = notificationResponse.payload ?? 'null';
            selectNotificationSubject!.sink.add(payload);
            handleNotificationPayload(payload);
            break;
          case NotificationResponseType.selectedNotificationAction:
            break;
        }
      },
    );
    await isAndroidPermissionGranted();
  }

  Future<void> isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted =
          await flutterLocalNotificationsPlugin
              ?.resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >()
              ?.areNotificationsEnabled() ??
          false;
      debugPrint('Android 13 areNotificationsEnabled: $granted');

      if (!granted) {
        final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
            flutterLocalNotificationsPlugin
                ?.resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >();

        final bool result =
            await androidImplementation?.requestNotificationsPermission() ??
            false;
        debugPrint('Android 13 requestPermission: $result');
      }
    }
  }

  requestIOSPermissions() async {
    var result = await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    return result;
  }

  void configureDidReceiveLocalNotificationSubject(BuildContext context) {
    didReceiveLocalNotificationSubject!.stream.listen((
      ReceivedNotification receivedNotification,
    ) async {
      await showDialog(
        context: context,
        builder:
            (BuildContext context) => CupertinoAlertDialog(
              title:
                  receivedNotification.title != null
                      ? Text(receivedNotification.title ?? '')
                      : null,
              content:
                  receivedNotification.body != null
                      ? Text(receivedNotification.body ?? '')
                      : null,
              actions: [
                CupertinoDialogAction(
                  isDefaultAction: true,
                  child: const Text('Ok'),
                  onPressed: () async {
                    Navigator.of(context, rootNavigator: true).pop();
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ListenNotification(
                              receivedNotification.payload ?? '',
                            ),
                      ),
                    );
                  },
                ),
              ],
            ),
      );
    });
  }

  void configureSelectNotificationSubject(
    BuildContext context,
    Function callback,
  ) {
    selectNotificationSubject!.stream.listen((String payload) {
      Get.log('onOpenLocalNotification $payload');
      handleNotificationPayload(payload);
      callback(payload);
    });
  }

  Future<NotificationAppLaunchDetails?>
  getNotificationAppLaunchDetails() async {
    return await flutterLocalNotificationsPlugin!
        .getNotificationAppLaunchDetails();
  }

  void dispose() {
    if (didReceiveLocalNotificationSubject != null) {
      didReceiveLocalNotificationSubject!.close();
    }
    if (selectNotificationSubject != null) {
      selectNotificationSubject!.close();
    }
  }

  Future<void> showNotification(
    int id,
    String title,
    String body,
    String androidChannelId,
    String androidChannelName,
    String androidChannelDescription, {
    String? payload,
    String? ticker,
    String sound = 'default',
    bool playSound = true,
    Importance importance = Importance.max,
    Priority priority = Priority.high,
  }) async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'merchant_noti_id',
      'Merchant Local Notification',
      description: 'Local Notification',
      importance: Importance.max,
      playSound: false, //
    );
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription: androidChannelDescription,
      importance: importance,
      priority: priority,
      ticker: ticker,
      sound: RawResourceAndroidNotificationSound(sound),
    );
    var iOSPlatformChannelSpecifics = DarwinNotificationDetails(
      presentSound: true,
      presentBadge: true,
      presentAlert: true,
      sound: sound == 'default' ? null : '$sound.wav',
    );
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: sound == 'default' ? null : iOSPlatformChannelSpecifics,
    );
    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin!.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> repeatNotification(
    int id,
    String title,
    String body,
    RepeatInterval repeatInterval,
    String androidChannelId,
    String androidChannelName,
    String androidChannelDescription, {
    String? payload,
  }) async {
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      androidChannelId,
      androidChannelName,
      channelDescription: androidChannelDescription,
    );
    var iOSPlatformChannelSpecifics = const DarwinNotificationDetails();
    // ignore: unused_local_variable
    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );
    // await flutterLocalNotificationsPlugin!.periodicallyShow(
    //     id, title, body, repeatInterval, platformChannelSpecifics,
    //     payload: payload);
  }

  Future<void> zonedScheduleNotification() async {
    // await flutterLocalNotificationsPlugin!.zonedSchedule(
    //     0,
    //     'scheduled title',
    //     'scheduled body',
    //     tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
    //     const NotificationDetails(
    //       android: AndroidNotificationDetails(
    //         'your channel id',
    //         'your channel name',
    //         channelDescription: 'your channel description',
    //         sound: RawResourceAndroidNotificationSound('driver_new_order'),
    //         playSound: true,
    //         importance: Importance.max,
    //         priority: Priority.max,
    //         enableLights: true,
    //       ),
    //     ),
    //     uiLocalNotificationDateInterpretation:
    //         UILocalNotificationDateInterpretation.absoluteTime);
  }

  @pragma('vm:entry-point')
  static Future<dynamic> backgroundMessageHandler(RemoteMessage message) async {
    debugPrint("onBackgroundMessage data: ${message.data}");
    debugPrint("noti data: ${message.notification}");
    RemoteNotification? notification = message.notification;
    AndroidNotification? android = notification?.android;
    if (notification != null && android != null) {
      final player = AudioPlayer();
      final soundName = message.notification?.android?.sound;
      if (soundName != null && soundName.isNotEmpty) {
        final fileSound = 'sounds/$soundName.wav';
        print('Playing sound: $fileSound');
        try {
          await player.play(AssetSource(fileSound));
        } catch (e) {
          print('Error playing sound: $e');
          await FlutterRingtonePlayer().playNotification();
        }
        await Future.delayed(const Duration(seconds: 10));
        await player.dispose();
      } else {
        await FlutterRingtonePlayer().playNotification();
      }
    } else {
      await FlutterRingtonePlayer().playNotification();
    }
  }

  static openNotification(RemoteMessage message) async {
    print('openNotification: ${message.data}');
    if (message.notification != null) {
      _handleNavigationData(message.data);
    }
  }

  static void handleNotificationPayload(String? payload) {
    if (payload == null || payload.isEmpty || payload.toLowerCase() == 'null') {
      return;
    }
    try {
      final Map<String, dynamic> data = jsonDecode(payload);
      _handleNavigationData(data);
    } catch (e) {
      debugPrint('handleNotificationPayload error: $e');
    }
  }

  static void _handleNavigationData(Map<String, dynamic> data) {
    if (_shouldDeferNavigation()) {
      _pendingNavigationData = data;
      return;
    }
    _navigateToOrderDetail(data);
  }

  static bool _shouldDeferNavigation() {
    final currentRoute = Get.currentRoute;
    return currentRoute.isEmpty || currentRoute == Routes.splash;
  }

  static void processPendingNavigation() {
    if (_pendingNavigationData == null) {
      return;
    }
    final data = _pendingNavigationData!;
    _pendingNavigationData = null;
    _navigateToOrderDetail(data);
  }

  static void _navigateToOrderDetail(Map<String, dynamic> data) {
    final String orderId = (data['orderId'] ?? '').toString();
    if (orderId.isEmpty) {
      return;
    }
    final String orderStatus = (data['orderStatus'] ?? '').toString();
    if (orderStatus == 'PENDING') {
      Get.toNamed(Routes.confirmOrderDetail, arguments: {'orderId': orderId});
    } else if (orderStatus == 'COMPLETED') {
      Get.toNamed(Routes.oderDetail, arguments: {'orderId': orderId});
    }
  }

  Future<void> checkPendingNotificationRequests(BuildContext context) async {
    var pendingNotificationRequests =
        await flutterLocalNotificationsPlugin!.pendingNotificationRequests();
    for (var pendingNotificationRequest in pendingNotificationRequests) {
      debugPrint(
        'pending notification: [id: ${pendingNotificationRequest.id}, title: ${pendingNotificationRequest.title}, body: ${pendingNotificationRequest.body}, payload: ${pendingNotificationRequest.payload}]',
      );
    }
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            '${pendingNotificationRequests.length} pending notification requests',
          ),
          actions: [
            AppButton(
              title: 'OK',
              type: AppButtonType.nomal,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> cancelNotification(int id) async {
    await flutterLocalNotificationsPlugin!.cancel(id);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin!.cancelAll();
  }

  Future<void> onDidReceiveLocalNotification(
    BuildContext context,
    int id,
    String title,
    String body,
    String payload,
  ) async {
    // display a dialog with the notification details, tap ok to go to another page
    await showDialog(
      context: context,
      builder:
          (BuildContext context) => CupertinoAlertDialog(
            title: Text(title),
            content: Text(body),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                child: const Text('Ok'),
                onPressed: () async {
                  Navigator.of(context, rootNavigator: true).pop();
                  await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ListenNotification(payload),
                    ),
                  );
                },
              ),
            ],
          ),
    );
  }
}
