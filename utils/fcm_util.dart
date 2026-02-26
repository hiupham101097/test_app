import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/local_notification_util.dart';
import '../domain/data/models/store_model.dart';
import 'object_util.dart';

class FcmUtil {
  FcmUtil();
  final WalletService walletService = WalletService();
  static final FirebaseMessaging _firebaseMessaging =
      FirebaseMessaging.instance;

  initForegroundNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: Platform.isIOS ? true : false,
    );
  }

  Future<void> init() async {
    try {
      NotificationSettings settings = await _firebaseMessaging
          .requestPermission(
            alert: true,
            announcement: true,
            badge: true,
            carPlay: true,
            criticalAlert: false,
            provisional: true,
            sound: Platform.isIOS ? true : false,
          );
      print('User granted permission: ${settings.authorizationStatus}');
      await _firebaseMessaging.requestPermission(
        sound: Platform.isIOS ? true : false,
        badge: true,
        alert: false,
        provisional: true,
      );
      try {
        _firebaseMessaging.subscribeToTopic("DEFAULT_FCM_ALL_TOPIC");
      } catch (ex) {
        //
      }
      await _firebaseMessaging.setAutoInitEnabled(true);
      _firebaseMessaging.getInitialMessage().then((RemoteMessage? message) {
        if (message != null) {
          if (kDebugMode) {
            print('getInitialMessage data: ${message.data}');
          }
          if (kDebugMode) {
            print('getInitialMessage notification: ${message.notification}');
          }
        }
      });

      FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
        debugPrint("onMessage: ${message.toMap()}");
        RemoteNotification? notification = message.notification;
        print("notification: ${notification?.toMap()}");
        debugPrint("sound: ${message.notification?.apple?.sound?.name}");
        debugPrint("sound android: ${message.notification?.android?.sound}");
        debugPrint("title: ${message.notification?.title}");
        debugPrint("body: ${message.notification?.body}");

        AndroidNotification? android = notification?.android;
        Map<String, dynamic> data = message.data;
        walletService.getWalletUser();
        walletService.getWallet(
          phone: StoreDB().currentStore()?.phone ?? '',
          store: StoreDB().currentStore() ?? StoreModel(),
        );
        if (ObjectUtil.isNotEmpty(data)) {
          eventBus.fire(NotificationEvent());
          eventBus.fire(OderEvent());
          if (notification != null) {
            if (Platform.isAndroid) {
              print("android?.sound");
              print(message.notification?.android?.sound);
              await LocalNotificationUtil().showNotification(
                notification.hashCode,
                notification?.title ?? '',
                notification?.body ?? '',
                'merchant_noti_id',
                'Merchant Local Notification', // title
                'Local Notification',
                payload: jsonEncode(message.data),
                sound: android?.sound ?? 'default',
                playSound: false,
              );
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
            }
          }
        }
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        debugPrint("onMessageOpenedApp: data ${message.data}");
        debugPrint("onMessageOpenedApp: notification ${message.notification}");
        openNotification(message);
      });
    } catch (e) {
      //
    }
  }

  Future<String?> getFcmToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }

  openNotification(RemoteMessage message) async {
    print('openNotification: ${message.data}');
    if (message.notification != null && message.data['orderId'].isNotEmpty) {
      if (message.data['orderStatus'].isNotEmpty &&
          message.data['orderStatus'] == 'PENDING') {
        Get.toNamed(
          Routes.confirmOrderDetail,
          arguments: {'orderId': message.data['orderId']},
        );
      } else if (message.data['orderStatus'].isNotEmpty &&
          message.data['orderStatus'] == 'COMPLETED') {
        Get.toNamed(
          Routes.oderDetail,
          arguments: {'orderId': message.data['orderId']},
        );
      }
    }
  }

  backgroundHandler() async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(
      LocalNotificationUtil.backgroundMessageHandler,
    );
  }

  configureSelectNotificationSubject(BuildContext context, Function callback) {
    LocalNotificationUtil().configureSelectNotificationSubject(
      context,
      callback,
    );
  }

  Future<void> subscribeTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  Future<void> unsubscribeTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  dispose() {
    LocalNotificationUtil().dispose();
  }
}
