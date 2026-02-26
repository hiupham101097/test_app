import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/object_util.dart';
import 'package:merchant/utils/remote_config_util.dart';
import 'package:merchant/utils/local_notification_util.dart';

import '../../domain/data/models/user_model.dart';
import '../../domain/database/user_db.dart';

class SplashController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiClient client = ApiClient();
  late AnimationController animationController;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  @override
  void onInit() async {
    super.onInit();
    await initAnimation();
    final isUpdate = await RemoteConfigUtil.checkForAppUpdate(
      onSkip: () async {
        Get.back();
        if (sl<LocalClient>().email.isNotEmpty) {
          await getStoreByUserEmail();
        } else {
          openApp();
        }
      },
    );
    if (isUpdate) {
      return;
    } else {
      if (sl<LocalClient>().email.isNotEmpty) {
        await getStoreByUserEmail();
      } else {
        openApp();
      }
    }
  }

  Future<void> initAnimation() async {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeIn),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeOut),
    );
    animationController.forward();
  }

  Future<void> openApp() async {
    try {
      final token = sl<LocalClient>().accessToken;
      await 3.delay();
      if (ObjectUtil.isNotEmpty(token)) {
        final response = await client.getInfoUser(token: token);
        if (response.data['resultApi'] != null) {
          final store = StoreModel.fromJson(
            response.data['resultApi']['storeInfo'],
          );
          final user = UserModel.fromJson(response.data['resultApi']['user']);

          await StoreDB().save(store);
          await UserDB().save(user);
          await Get.offAllNamed(Routes.root);
          WidgetsBinding.instance.addPostFrameCallback((_) {
            LocalNotificationUtil.processPendingNavigation();
          });
        } else {
          clearData();
          await Get.offAllNamed(Routes.login);
        }
      } else {
        clearData();
        await Get.offAllNamed(Routes.login);
      }
    } catch (e, t) {
      Get.log(e.toString(), isError: true);
      Get.log(t.toString(), isError: true);
      clearData();
      await Get.offAllNamed(Routes.login);
    }
  }

  void clearData() {
    sl<LocalClient>().clearAccessToken();
    StoreDB().clear();
    UserDB().clear();
    WalletDB().clear();
    WalletDB().clearWalletUser();
    sl<LocalClient>().clearEmail();
    sl<LocalClient>().clearPassword();
  }

  Future<void> getStoreByUserEmail() async {
    if (sl<LocalClient>().phone.isEmpty) {
      await client
          .getStoreByUserEmail(email: sl<LocalClient>().email)
          .then((response) async {
            if (response.statusCode == 200) {
              if (response.data['resultApi']['updatedStore'] != null) {
                final store = StoreModel.fromJson(
                  response.data['resultApi']['updatedStore'],
                );
                await StoreDB().save(store);
                await Get.offAllNamed(Routes.infoStore);
              }
            }
          })
          .catchError((error, trace) {
            ErrorUtil.catchError(error, trace);
          });
    } else {
      await Get.offAllNamed(
        Routes.infoStore,
        arguments: {
          'phone': sl<LocalClient>().phone,
          'email': sl<LocalClient>().email,
        },
      );
    }
  }

  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
}
