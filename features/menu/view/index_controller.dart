import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/features/menu/menu_options/list_options/list_options_menu_controller.dart';
import 'package:merchant/navigations/app_pages.dart';

enum MenuTabBarType { managerMenu, optionsMenu }

extension MenuTabBarTypeExtension on MenuTabBarType {
  String getLabel() {
    return this == MenuTabBarType.managerMenu
        ? "Quản lý sản phẩm".tr
        : "Quản lý đính kèm".tr;
  }
}

class IndexController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiClient client = ApiClient();
  final EasyRefreshController controller = EasyRefreshController();
  late TabController tabController;

  final Rx<MenuTabBarType> selectedTab = MenuTabBarType.managerMenu.obs;
  final RxString selectedItem = "create_menu".tr.obs;

  final List<String> tabMenu = [
    "Tạo danh mục cửa hàng".tr,
    "Tạo sản phẩm mới".tr,
    "Sắp xếp sản phẩm".tr,
    "Bật tắt sản phẩm".tr,
    "Xoá sản phẩm".tr,
  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
  }

  void onTapItem(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.createCategory);
        break;
      case 1:
        Get.toNamed(Routes.createFood);
        break;
      case 2:
        Get.toNamed(Routes.arrangeDishes);
        break;
      case 3:
        Get.find<ListMenuController>(tag: 'listMenu-default').toggleStatus();
        break;
      case 4:
        Get.find<ListMenuController>(
          tag: 'listMenu-default',
        ).toggleStatus(status: MenuStatusType.deleted);
        break;
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
  }

  void onSelectTab(int index) {
    switch (index) {
      case 0:
        selectedTab.value = MenuTabBarType.managerMenu;
        break;
      case 1:
        if (!Get.isRegistered<ListOptionsMenuController>()) {
          Get.put(ListOptionsMenuController());
        }
        selectedTab.value = MenuTabBarType.optionsMenu;
        break;
    }
  }

  void showBottomSheetCustom() {
    selectedItem.value = '';
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "custom".tr,
        dataCustom: tabMenu,
        onTap: (index) {
          selectedItem.value = tabMenu[index];
          onTapItem(index);
        },
        selectedItem: selectedItem.value,
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
