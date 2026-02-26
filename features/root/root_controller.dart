import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/features/home_page/home_controller.dart';
import 'package:merchant/features/menu/view/index_page.dart';
import 'package:merchant/features/menu/view/index_controller.dart';
import 'package:merchant/features/my_oder/my_oder_controller.dart';
import 'package:merchant/features/my_oder/my_oder_page.dart';
import 'package:merchant/features/profile/profile_controller.dart';
import 'package:merchant/features/profile/profile_page.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_page.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/features/home_page/home_page.dart';
import 'package:merchant/service/socket_service.dart';
import 'package:merchant/utils/local_notification_util.dart';

class RootController extends GetxController {
  final RxInt currentTab = 0.obs;
  final socketService = SocketService();

  void _ensureControllerRegistered(int tabIndex) {
    switch (tabIndex) {
      case 0:
        if (!Get.isRegistered<HomeController>()) {
          Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
        }
        break;
      case 1:
        if (!Get.isRegistered<MyOrderController>()) {
          Get.lazyPut<MyOrderController>(
            () => MyOrderController(),
            fenix: true,
          );
        }
        break;
      case 2:
        if (!Get.isRegistered<IndexController>()) {
          Get.lazyPut<IndexController>(() => IndexController(), fenix: true);
        }
        break;
      case 3:
        if (!Get.isRegistered<MyWalletController>()) {
          Get.lazyPut<MyWalletController>(
            () => MyWalletController(),
            fenix: true,
          );
        }
        break;
      case 4:
        if (!Get.isRegistered<ProfileController>()) {
          Get.lazyPut<ProfileController>(
            () => ProfileController(),
            fenix: true,
          );
        }
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _ensureControllerRegistered(0);
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LocalNotificationUtil.processPendingNavigation();
    });
  }

  Widget getCurrentPage() {
    _ensureControllerRegistered(currentTab.value);
    switch (currentTab.value) {
      case 0:
        return HomePage();
      case 1:
        return MyOrderPage();
      case 2:
        return MenuTabBar();
      case 3:
        return MyWalletPage();
      case 4:
        return ProfilePage();
      default:
        return const SizedBox.shrink();
    }
  }

  void switchTab(int index) {
    if (index == 4) {
      Get.toNamed(Routes.profile);
    } else {
      _ensureControllerRegistered(index);
      if (index == 1 &&
          Get.isRegistered<MyOrderController>() &&
          currentTab.value != 1) {
        final myOrderController = Get.find<MyOrderController>();
        // if (myOrderController.selectedTab.value != StatusOrderEnum.PENDING) {
        myOrderController.selectedTab.value = StatusOrderEnum.PENDING;
        myOrderController.page.value = 1;
        myOrderController.fetchData();
        ();
        // }
      }
      currentTab.value = index;
    }
  }

  Future<void> connectSocket() async {
    try {
      await socketService.connect();
      await Future.delayed(Duration(seconds: 1));
    } catch (e) {
      print("⚠️ Không thể connect socket: $e");
    } finally {}
  }

  Widget get currentPage => getCurrentPage();
}
