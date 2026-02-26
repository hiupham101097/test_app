import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'notifycation_detail_controller.dart';

class NotifycationDetailPage extends GetView<NotifycationDetailController> {
  const NotifycationDetailPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title: controller.notification.value.title ?? "",
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CachedImage(
          url:
              "${AppConstants.domainImage}/${(controller.notification.value.image ?? "")}",
          width: Get.width,
          height: 196.h,
          fit: BoxFit.cover,
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(height: 12.w),
              // Text(
              //   controller.notification.value.title ?? "",
              //   style: AppTextStyles.bold14().copyWith(
              //     color: AppColors.grayscaleColor80,
              //   ),
              // ),
              // SizedBox(height: 4.w),
              // Text(
              //   "${"expiry_date".tr}: ${controller.notification.value.expiredAt ?? ""}",
              //   style: AppTextStyles.regular12(),
              // ),
              SizedBox(height: 24.w),
              Text(
                "notification_detail".tr,
                style: AppTextStyles.bold14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                controller.notification.value.message ?? "",
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
