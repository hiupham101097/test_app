import 'package:merchant/commons/widget/animatedBottomNavigationBar/animated_bottom_navigation_bar.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import '../../style/app_text_style.dart';
import 'root_controller.dart';

class RootPage extends GetView<RootController> {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: WillPopScope(
        onWillPop: () async {
          // controller.showAlert();
          return false;
        },
        child: Obx(
          () => Scaffold(
            body: controller.currentPage,
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor24,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.backgroundColor12,
                    blurRadius: 4,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: AnimatedBottomNavigationBar.builder(
                itemCount: 5,
                tabBuilder:
                    (int index, bool isActive) =>
                        _buildBottomNavBar(context, isActive)[index],
                activeIndex: controller.currentTab.value,
                splashColor: AppColors.primaryColor,
                splashSpeedInMilliseconds: 300,
                notchSmoothness: NotchSmoothness.defaultEdge,
                gapLocation: GapLocation.none,
                onTap: controller.switchTab,
                backgroundColor: AppColors.backgroundColor24,
                height: 70.h,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildBottomNavBar(BuildContext context, bool isActive) {
    return [
      _buildBottomNavigationBarItem(
        context,
        'home'.tr,
        AssetConstants.icHome,
        0,
        isActive,
      ),
      _buildBottomNavigationBarItem(
        context,
        'order_text'.tr,
        AssetConstants.icFoodBank,

        1,
        isActive,
      ),
      _buildBottomNavigationBarItem(
        context,
        'menu'.tr,
        AssetConstants.icMenuBook,

        2,
        isActive,
      ),

      _buildBottomNavigationBarItem(
        context,
        'wallet_money'.tr,
        AssetConstants.icWallet,

        3,
        isActive,
      ),
      _buildBottomNavigationBarItem(
        context,
        'profile'.tr,
        AssetConstants.icAccountCircle,
        4,
        isActive,
      ),
    ];
  }

  Widget _buildBottomNavigationBarItem(
    BuildContext context,
    String title,
    String iconPath,
    int index,
    bool isActive,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      spacing: 4,
      children: [
        Image.asset(
          iconPath,
          width: 20.w,
          height: 20.w,
          color: isActive ? AppColors.primaryColor : AppColors.grayscaleColor80,
        ),
        Text(
          title,
          style: AppTextStyles.semibold11().copyWith(
            color:
                isActive ? AppColors.primaryColor : AppColors.grayscaleColor80,
          ),
        ),
      ],
    );
  }
}
