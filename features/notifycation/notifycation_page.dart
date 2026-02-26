import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/notifi_model.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'notifycation_controller.dart';

class NotifycationPage extends GetView<NotifycationController> {
  const NotifycationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title: "notifications".tr,
        action:
            controller.listNotification.isNotEmpty
                ? Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: GestureDetector(
                    onTap: () {
                      if (controller.hasReadNotification.value) {
                        controller.updateNotification();
                      }
                    },
                    child: Text(
                      controller.hasReadNotification.value
                          ? "read_all".tr
                          : "mark_all_read".tr,
                      style: AppTextStyles.regular14().copyWith(
                        color:
                            controller.hasReadNotification.value
                                ? AppColors.infomationColor
                                : AppColors.grayscaleColor60,
                      ),
                    ),
                  ),
                )
                : null,
        child: Obx(() {
          final listData = controller.listNotification;
          final meta = controller.total.value;
          return controller.loading.value
              ? SizedBox.shrink()
              : Padding(
                padding: EdgeInsets.all(12.w),
                child: CustomEasyRefresh(
                  controller: controller.controller,
                  onRefresh: controller.onRefresh,
                  infoText: '${'now'.tr}: ${listData.length}/ ${meta}',
                  onLoading: controller.onLoadingPage,
                  emptyWidget: CustomEmpty(
                    title: "now_you_have_no_notification".tr,
                    width: 100.r,
                    height: 100.r,
                    image: AssetConstants.icEmptyNotify,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Padding(
                      padding: EdgeInsets.only(bottom: 16.h),
                      child: _buildItem(controller.listNotification[index]),
                    ),
                    childCount: listData.length,
                  ),
                ),
              );
        }),
      ),
    );
  }

  Widget _buildItem(NotifiModel item) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.notifycationDetail,
          arguments: {'notification': item},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.h, vertical: 12.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.5.w),
        ),
        child: Row(
          children: [
            Container(
              alignment: Alignment.center,
              width: 24.w,
              height: 24.w,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor24,
                borderRadius: BorderRadius.circular(360.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.grayscaleColor10,
                    blurRadius: 1.r,
                    offset: Offset(1.w, 2.h),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (item.isRead == false)
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.warningColor,
                        borderRadius: BorderRadius.circular(360.r),
                      ),
                    ),
                  Icon(Icons.email, color: AppColors.primaryColor, size: 16.r),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title ?? "",
                    style: AppTextStyles.medium14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    item.message ?? "",
                    style: AppTextStyles.regular12(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.w),
            Icon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.grayscaleColor60,
              size: 12.r,
            ),
          ],
        ),
      ),
    );
  }
}
