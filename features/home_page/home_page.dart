import 'dart:io';

import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/home_page/view/build_app_bar_widget.dart';
import 'package:merchant/features/home_page/view/build_my_oder_widget.dart';
import 'package:merchant/features/home_page/view/build_promotion_program_widget.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'home_controller.dart';

class HomePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Material(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Obx(() {
          final currentRevenue = controller.revenueData.value.current;
          final compareRevenue = controller.revenueData.value.compare;
          final yesterday = DateUtil.formatDate(
            DateTime.parse(controller.yesterdayUpdate.value),
            format: "dd/MM/yyyy",
          );
          final upOrder =
              (currentRevenue?.totalOrders ?? 0) >
              (compareRevenue?.totalOrders ?? 0);
          final upRevenue =
              (currentRevenue?.totalOrders ?? 0) >
              (compareRevenue?.totalOrders ?? 0);
          return CustomScreen(
            child: CustomEasyRefresh(
              controller: controller.controller,
              onRefresh: controller.onRefresh,
              infoText:
                  '${'now'.tr}: ${controller.orderData.length}/ ${controller.total.value}',
              onLoading: controller.onLoadingPage,
              delegate: SliverChildBuilderDelegate(
                (context, index) => Column(
                  children: [
                    BuildAppBarWidget(),
                    SizedBox(height: 12.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      child: Row(
                        spacing: 8.w,
                        children: [
                          buildCardStatistical(
                            title: 'Tổng doanh thu',
                            value: AppUtil.formatNumber(
                              controller.revenueData.value.current?.totalRevenue
                                      .toDouble() ??
                                  0.0,
                            ),
                            unit: 'VNĐ',
                            date: 'So với ngày $yesterday',
                            percentage: 50,
                            color1: 0xFF001D53,
                            color2: 0xFF007CF8,
                            up: upRevenue,
                          ),
                          buildCardStatistical(
                            title: 'Tổng đơn hàng',
                            value: AppUtil.formatNumber(
                              controller.revenueData.value.current?.totalOrders
                                      .toDouble() ??
                                  0.0,
                            ),
                            unit: 'đơn hàng',
                            date: 'So với ngày $yesterday',
                            percentage: 90,
                            color1: 0xFF00567E,
                            color2: 0xFF009387,
                            up: upOrder,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 12.h),
                    _statisticalOrder(),
                    SizedBox(height: 12.h),
                    BuildPromotionProgramWidget(),
                    SizedBox(height: 12.h),
                    BuildMyOrderWidget(),
                    SizedBox(height: 12.h),
                  ],
                ),

                childCount: 1,
              ),
            ),
          );
        }),
      ),
    );
  }

  _statisticalOrder() {
    return Obx(() {
      final currentRevenue = controller.revenueData.value.current;
      final compareRevenue = controller.revenueData.value.compare;
      final upSuccess =
          (currentRevenue?.successOrders ?? 0) >
          (compareRevenue?.successOrders ?? 0);
      final upFailed =
          (currentRevenue?.failedOrders ?? 0) >
          (compareRevenue?.failedOrders ?? 0);
      return Container(
        padding: EdgeInsets.all(8.w),
        margin: EdgeInsets.symmetric(horizontal: 12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor16,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.5.w),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'status_order'.tr,
                    style: AppTextStyles.medium14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.incomeStatistics);
                  },
                  child: Text(
                    'view_income'.tr,
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.infomationColor,
                    ),
                  ),
                ),
              ],
            ),
            Text(
              '${'data_updated'.tr}: ${DateUtil.formatDate(DateTime.parse(controller.todayUpdate.value), format: "dd/MM/yyyy HH:mm")}',
              style: AppTextStyles.regular10().copyWith(
                color: AppColors.grayscaleColor80,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 12.h),
            Row(
              spacing: 20.w,
              children: [
                _buildStatusOrder(
                  up: upSuccess,
                  title: "success_order".tr,
                  value: AppUtil.formatNumber(
                    currentRevenue?.successOrders.toDouble() ?? 0.0,
                  ),
                  date:
                      "${'compare_day'.tr} ${DateUtil.formatDate(DateTime.parse(controller.yesterdayUpdate.value), format: "dd/MM/yyyy")}",
                ),
                Container(
                  width: 1.w,
                  height: 78.h,
                  color: AppColors.grayscaleColor30,
                ),
                _buildStatusOrder(
                  up: upFailed,
                  title: "failed_order".tr,
                  value: AppUtil.formatNumber(
                    currentRevenue?.failedOrders.toDouble() ?? 0.0,
                  ),
                  date:
                      "${'compare_day'.tr} ${DateUtil.formatDate(DateTime.parse(controller.yesterdayUpdate.value), format: "dd/MM/yyyy")}",
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget buildCardStatistical({
    required String title,
    required String value,
    required String unit,
    required String date,
    required int percentage,
    required int color1,
    required int color2,
    required bool up,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Color(color1), Color(color2)],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: [
                Text(
                  title,
                  style: AppTextStyles.semibold14().copyWith(
                    color: Colors.white,
                  ),
                ),
                Image.asset(
                  up
                      ? AssetConstants.icOrderSuccess
                      : AssetConstants.icOrderErorr,
                  width: 24.w,
                  height: 24.w,
                  color: up ? Colors.white : AppColors.warningColor20,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Center(
              child: Text(
                value,
                style: AppTextStyles.semibold20().copyWith(color: Colors.white),
              ),
            ),
            Center(
              child: Text(
                unit,
                style: AppTextStyles.regular14().copyWith(color: Colors.white),
              ),
            ),

            SizedBox(height: 16.h),
            Text(
              date,
              style: AppTextStyles.regular12().copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  _buildItemStatistics(int percentage) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.grayscaleColor20,
            borderRadius: BorderRadius.circular(100.r),
          ),
          width: double.infinity,
          height: 10.h,
        ),
        FractionallySizedBox(
          widthFactor: percentage / 100,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.backgroundColor24,
              borderRadius: BorderRadius.circular(360.r),
            ),
            height: 10.h,
          ),
        ),
      ],
    );
  }

  _buildStatusOrder({
    required String title,
    required String value,
    required String date,
    required bool up,
  }) {
    return Expanded(
      child: Column(
        children: [
          Text(
            title,
            style: AppTextStyles.medium14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 20.h),
          Row(
            spacing: 8.w,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.medium20().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              Image.asset(
                up
                    ? AssetConstants.icOrderSuccess
                    : AssetConstants.icOrderErorr,
                width: 24.w,
                height: 24.w,
                color: up ? AppColors.infomationColor : AppColors.warningColor,
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            date,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }
}
