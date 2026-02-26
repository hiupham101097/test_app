import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/menu/view/index_controller.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_page.dart';
import 'package:merchant/features/menu/menu_options/list_options/list_options_menu_page.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MenuTabBar extends GetView<IndexController> {
  const MenuTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScreen(
        isBack: false,
        isShowDivider: false,
        title:
            controller.selectedTab.value == MenuTabBarType.managerMenu
                ? "Quản lý sản phẩm".tr
                : "Quản lý đính kèm".tr,
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(360),
          ),
          backgroundColor: AppColors.primaryColor,
          onPressed: () {
            if (controller.selectedTab.value == MenuTabBarType.managerMenu) {
              controller.showBottomSheetCustom();
            } else {
              Get.toNamed(Routes.createProduct);
            }
          },
          child: const Icon(Icons.add, color: Colors.white),
        ),
        child: Column(
          children: [
            _buildTabBar(),
            Expanded(
              child: TabBarView(
                controller: controller.tabController,
                physics: const NeverScrollableScrollPhysics(),
                children: [ListMenuPage(), ListOptionsMenuPage()],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildTabBar() {
    return TabBar(
      controller: controller.tabController,
      isScrollable: false,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.infomationColor,
      labelColor: AppColors.infomationColor,
      splashFactory: NoSplash.splashFactory,
      dividerColor: Colors.transparent,
      unselectedLabelColor: AppColors.grayscaleColor60,
      labelStyle: AppTextStyles.medium14(),
      unselectedLabelStyle: AppTextStyles.medium14(),
      padding: EdgeInsets.zero,
      indicatorWeight: 2,
      onTap: (index) {
        controller.onSelectTab(index);
      },
      tabs:
          MenuTabBarType.values
              .map(
                (e) => Container(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        e == MenuTabBarType.managerMenu
                            ? AssetConstants.icOrder
                            : AssetConstants.icRestaurant,
                        width: 20.w,
                        height: 20.w,
                        color:
                            controller.selectedTab.value == e
                                ? AppColors.infomationColor
                                : AppColors.grayscaleColor60,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        e.getLabel(),
                        style: AppTextStyles.medium14().copyWith(
                          color:
                              controller.selectedTab.value == e
                                  ? AppColors.infomationColor
                                  : AppColors.grayscaleColor60,
                        ),
                      ),
                    ],
                  ),
                ),
              )
              .toList(),
    );
  }
}
