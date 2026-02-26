import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/features/auth/info_store/widget/cancel_register.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class IntroWidget extends GetView<InfoStoreController> {
  const IntroWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          controller.store.value.id != "" ? _registerSuccess() : _buildHeader(),
          SizedBox(height: 12.h),
          _buildPageView(),
          SizedBox(height: 12.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Chào mừng bạn đến với Chợ Thông Minh!".tr,
            style: AppTextStyles.bold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            "Cùng bắt đầu hành trình mở gian hàng và tiếp cận khách hàng online ngay hôm nay."
                .tr,
            style: AppTextStyles.regular12(),
          ),
        ],
      ),
    );
  }

  Widget _registerSuccess() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tóm tắt hồ sơ".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.grayscaleColor20, width: 0.5),
            ),
            child: Column(
              children: [
                _itemSummary(
                  title: "Ngày tạo hồ sơ",
                  value: DateUtil.formatDate(
                    DateTime.tryParse(controller.store.value.createDate ?? ''),
                    format: 'dd/MM/yyyy',
                  ),
                ),
                _itemSummary(
                  title: "Ngày duyệt hồ sơ",
                  value:
                      controller.store.value.timeUpdateStatus == "" ||
                              controller.store.value.status.toUpperCase() ==
                                  "PENDING"
                          ? "--/--/----"
                          : DateUtil.formatDate(
                            DateTime.tryParse(
                              controller.store.value.timeUpdateStatus ?? '',
                            ),
                            format: 'dd/MM/yyyy',
                          ),
                ),

                _itemSummary(
                  title: "Trạng thái",
                  value:
                      controller.store.value.status == "PENDING"
                          ? "Chờ duyệt"
                          : controller.store.value.status == "APPROVE"
                          ? "Đã duyệt"
                          : "Đã từ chối",
                  colorValue:
                      controller.store.value.status == "PENDING"
                          ? AppColors.attentionColor
                          : controller.store.value.status == "APPROVE"
                          ? AppColors.successColor
                          : AppColors.warningColor,
                ),
              ],
            ),
          ),
          if (controller.store.value.status == "REJECT")
            CancelRegister(
              reasonCancel: controller.store.value.reasonCancel,
              onTap: () {
                controller.onAction();
              },
            ),
        ],
      ),
    );
  }

  Widget _itemSummary({
    required String title,
    required String value,
    Color? colorValue = AppColors.grayscaleColor80,
    bool isLast = false,
    bool isSuccess = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border:
            isLast
                ? null
                : Border(
                  bottom: BorderSide(
                    color: AppColors.grayscaleColor10,
                    width: 0.5,
                  ),
                ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.start,
              style: AppTextStyles.regular14(),
            ),
          ),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: AppTextStyles.medium14().copyWith(color: colorValue),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Text(
            "Bắt đầu tạo hồ sơ cửa hàng".tr,
            style: AppTextStyles.bold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ),
        SizedBox(height: 24.h),
        CarouselSlider(
          carouselController: controller.carouselController,
          items: List.generate(
            controller.steps.length,
            (i) => _buildStep(step: controller.steps[i]),
          ),
          options: CarouselOptions(
            onPageChanged: (index, reason) {
              controller.currentPage.value = index;
            },
            height: 340.h,
            enableInfiniteScroll: false,
            viewportFraction: 1,
          ),
        ),
        SizedBox(height: 12),
        if (controller.steps.length > 1)
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(controller.steps.length, (i) {
                final isActive = i == controller.currentPage.value;
                return AnimatedContainer(
                  duration: Duration(milliseconds: 100),
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  width: isActive ? 20.w : 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                    color:
                        isActive
                            ? AppColors.primaryColor60
                            : AppColors.grayscaleColor10,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                );
              }),
            ),
          ),
      ],
    );
  }

  Widget _buildStep({required Map<String, dynamic> step}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      width: Get.width - 24.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grayscaleColor50, width: 0.4.w),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            step['image'],
            width: 175.w,
            height: 175.h,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 14.h),
          Text(
            step['title'],
            style: AppTextStyles.bold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            step['subtitle'],
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor60,
            ),
          ),
          if (step['isSuccess'] == true) ...[
            SizedBox(height: 12.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.check_circle_outline_outlined,
                  color: AppColors.successColor,
                  size: 16.w,
                ),
                SizedBox(width: 4.w),
                Text(
                  "Đã hoàn thành".tr,
                  style: AppTextStyles.regular12().copyWith(
                    color: AppColors.successColor,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
