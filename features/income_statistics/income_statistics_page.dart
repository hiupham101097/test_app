import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'income_statistics_controller.dart';

class IncomeStatisticsPage extends GetView<IncomeStatisticsController> {
  const IncomeStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "income_statistics".tr,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Column(
            children: [
              _buildHeader(),
              SizedBox(height: 14.h),
              _buildTab(),
              SizedBox(height: 16.h),
              _buildTotal(),
            ],
          ),
        ),
      ),
    );
  }

  _buildHeader() {
    return Container(
      width: double.infinity,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 12.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor24,
        border: Border.all(color: AppColors.grayscaleColor20, width: 0.3.r),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Obx(
        () =>
            controller.listData.isNotEmpty
                ? SingleChildScrollView(
                  controller: controller.scrollController,
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      controller.listData.length,
                      (index) => Padding(
                        padding: EdgeInsets.only(
                          right:
                              index < controller.listData.length - 1 ? 8.0 : 0,
                        ),
                        child: GestureDetector(
                          onTap: () {
                            controller.onDateSelected(
                              controller.listData[index].day != null
                                  ? controller.listData[index].day ?? ''
                                  : controller.listData[index].month ?? '',
                            );
                          },
                          child: _buildItemStatistics(
                            controller.listData[index].totalRevenue as int,
                            controller.rxIMaxRevenue.value,
                            controller.listData[index].day != null
                                ? controller.listData[index].day ?? ''
                                : controller.listData[index].month ?? '',
                            controller.dateSelected.value ==
                                (controller.listData[index].day != null
                                    ? controller.listData[index].day ?? ''
                                    : controller.listData[index].month ?? ''),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                : CustomEmpty(
                  title: "no_data".tr,
                  width: 60.r,
                  height: 60.r,
                  image: AssetConstants.icEmptyImage,
                ),
      ),
    );
  }

  _buildTab() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          controller.tabList.length,
          (index) => GestureDetector(
            onTap: () {
              controller.onSelectTab(index);
            },
            child: Obx(
              () => Container(
                width: (Get.width - 56.w) / 2,
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360.r),
                  border: Border.all(
                    color:
                        controller.currentIndex.value == index
                            ? AppColors.primaryColor80
                            : AppColors.grayscaleColor30,
                    width: 1.w,
                  ),
                  color:
                      controller.currentIndex.value == index
                          ? AppColors.primaryColor
                          : null,
                ),
                child: Text(
                  controller.tabList[index],
                  style: AppTextStyles.medium12().copyWith(
                    color:
                        controller.currentIndex.value == index
                            ? Colors.white
                            : AppColors.grayscaleColor50,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildTotal() {
    return Obx(
      () => Column(
        spacing: 4.h,
        children: [
          Text(
            "total_income".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Text(
            AppUtil.formatMoney(
              controller.totalRevenueDisplay.value.toDouble(),
            ),
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.primaryColor80,
              fontSize: 30.sp,
            ),
          ),
          GestureDetector(
            onTap: () {
              controller.showBottomSheetDateTimePikerMonth();
            },
            child: Container(
              width: 169.w,
              height: 24.h,
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4.r),
                border: Border.all(
                  color: AppColors.grayscaleColor50,
                  width: 1.r,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      controller.totalRevenue
                          .map((element) => element)
                          .join(", "),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular10(),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Icon(
                    Icons.date_range,
                    size: 16.r,
                    color: AppColors.grayscaleColor80,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.grayscaleColor20, height: 0.3.r),
          _buildItemIncome("total_order".tr, controller.total.value.toString()),
          _buildItemIncome(
            "completed_order".tr,
            controller.completed.value.toString(),
            showIcon: true,
            onTap: () {
              if (controller.completed.value > 0) {
                Get.toNamed(
                  Routes.detailOrderStatistics,
                  arguments: {
                    'type': 'completed',
                    'date': controller.dateSelected.value,
                    'dateType':
                        controller.currentIndex.value == 0 ? 'day' : 'month',
                  },
                );
              }
            },
          ),
          _buildItemIncome(
            "canceled_order".tr,
            controller.canceled.value.toString(),
            showIcon: true,
            onTap: () {
              if (controller.canceled.value > 0) {
                Get.toNamed(
                  Routes.detailOrderStatistics,
                  arguments: {
                    'type': 'canceled',
                    'date': controller.dateSelected.value,
                    'dateType':
                        controller.currentIndex.value == 0 ? 'day' : 'month',
                  },
                );
              }
            },
          ),
          _buildItemIncome(
            "Đơn hàng huỷ bởi tài xế".tr,
            controller.canceledByDriver.value.toString(),
            showIcon: true,
            onTap: () {
              if (controller.canceledByDriver.value > 0) {
                Get.toNamed(
                  Routes.detailOrderStatistics,
                  arguments: {
                    'type': 'DRIVER_CANCELED',
                    'date': controller.dateSelected.value,
                    'dateType':
                        controller.currentIndex.value == 0 ? 'day' : 'month',
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  _buildItemIncome(
    String title,
    String value, {
    bool showIcon = false,
    Function()? onTap,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor24,
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor20, width: 0.3.r),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.medium14(),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              AppUtil.formatNumber(double.tryParse(value) ?? 0),
              style: AppTextStyles.medium14(),
              textAlign: TextAlign.end,
            ),
          ),
          SizedBox(width: 4.w),
          showIcon
              ? GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.chevron_right,
                  size: 20.r,
                  color: AppColors.grayscaleColor80,
                ),
              )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  _buildItemStatistics(
    int percentage,
    int maxValue,
    String date,
    bool isSelected,
  ) {
    return Container(
      width: 81.w,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 29.w,
            height: 256.h,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grayscaleColor10,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(100.r),
                      topRight: Radius.circular(100.r),
                    ),
                  ),
                  width: 29.w,
                  height: 256.h,
                ),
                if (percentage > 0)
                  Positioned(
                    left: 0,
                    bottom: 0,
                    child: Container(
                      width: 29.w,
                      height: (percentage / maxValue) * 256.h,
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor60,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(100.r),
                          topRight: Radius.circular(100.r),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: 24.h),

          Text(
            controller.formatDateForDisplay(date)[0].toString(),
            textAlign: TextAlign.center,
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Text(
            controller.formatDateForDisplay(date)[1].toString(),
            textAlign: TextAlign.center,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 4.h),
          if (isSelected)
            Container(
              width: 60.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.grayscaleColor80,
                borderRadius: BorderRadius.circular(100.r),
              ),
            ),
        ],
      ),
    );
  }
}
