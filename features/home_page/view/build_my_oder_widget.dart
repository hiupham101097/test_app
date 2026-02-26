import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/home_page/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:merchant/features/root/root_controller.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/build_item_oder_widget.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BuildMyOrderWidget extends GetView<HomeController> {
  const BuildMyOrderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          Row(
            spacing: 8.w,
            children: [
              Image.asset(
                AssetConstants.icFoodBank,
                width: 20.w,
                height: 24.w,
                color: AppColors.grayscaleColor80,
              ),
              Text(
                'my_orders'.tr,
                style: AppTextStyles.semibold16().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {
                  final controller = Get.find<RootController>();
                  controller.switchTab(1);
                },
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 14.w,
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() {
            return controller.orderData.isNotEmpty
                ? Column(
                  children: List.generate(
                    controller.orderData.length,
                    (index) => Padding(
                      padding: EdgeInsets.only(
                        bottom:
                            index == controller.orderData.length - 1 ? 0 : 16.h,
                      ),
                      child: BuildItemOrderWidget(
                        item: controller.orderData[index],
                      ),
                    ),
                  ),
                )
                : CustomEmpty(title: 'no_data'.tr);
          }),
        ],
      ),
    );
  }
}
