import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/build_item_oder_widget.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/refund/oder_refund/enum/refunt_tab_enum.dart';
import 'package:merchant/features/refund/oder_refund/view/item_oder_refund.dart';
import 'package:merchant/features/refund/request_refund/request_refund_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'oder_refund_controller.dart';

class OrderRefundPage extends GetView<OrderRefundController> {
  const OrderRefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "order_refund".tr,
      isShowDivider: false,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          spacing: 12.h,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // _buildTabBar(),
            // controller.selectedTab.value == RefuntTabEnum.complaint
            //     ? _buildTabBarComplaint()
            //     :_buildTabBarRefund
            _buildTabBarComplaint(),
            Expanded(child: _buildListOrderComplaint()),
            // Expanded(
            //   child: TabBarView(
            //     controller: controller.tabController,
            //     children: [_buildListOrderComplaint(), _buildListOrder()],
            //   ),
            // ),
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
      unselectedLabelColor: AppColors.grayscaleColor80,
      labelStyle: AppTextStyles.medium14(),
      unselectedLabelStyle: AppTextStyles.medium14(),
      padding: EdgeInsets.zero,
      indicatorWeight: 3,
      dividerColor: AppColors.grayscaleColor20,
      onTap: (index) {
        controller.onChangeTab(index);
      },
      tabs: RefuntTabEnum.values.map((e) => Tab(text: e.getLabel())).toList(),
    );
  }

  Widget _buildTabBarRefund() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          StatusRefundEnum.values.length,
          (index) => GestureDetector(
            onTap: () {
              controller.onTapTab(StatusRefundEnum.values[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              width: (Get.width - 48.w) / 3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    index == controller.currentTab.value.index
                        ? AppColors.primaryColor
                        : AppColors.backgroundColor24,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color:
                      index == controller.currentTab.value.index
                          ? AppColors.primaryColor80
                          : AppColors.grayscaleColor30,
                  width: 1.w,
                ),
              ),
              child: Text(
                StatusRefundEnum.values[index].getLabel(),
                style: AppTextStyles.medium12().copyWith(
                  color:
                      index == controller.currentTab.value.index
                          ? Colors.white
                          : AppColors.grayscaleColor80,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTabBarComplaint() {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(
          StatusComplaintEnum.values.length,
          (index) => GestureDetector(
            onTap: () {
              controller.onTapTabComplaint(StatusComplaintEnum.values[index]);
            },
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 6.h),
              width: (Get.width - 48.w) / 3,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:
                    index == controller.currentTabComplaint.value.index
                        ? AppColors.primaryColor
                        : AppColors.backgroundColor24,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(
                  color:
                      index == controller.currentTabComplaint.value.index
                          ? AppColors.primaryColor80
                          : AppColors.grayscaleColor30,
                  width: 1.w,
                ),
              ),
              child: Text(
                StatusComplaintEnum.values[index].getLabel(),
                style: AppTextStyles.medium12().copyWith(
                  color:
                      index == controller.currentTabComplaint.value.index
                          ? Colors.white
                          : AppColors.grayscaleColor80,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListOrderComplaint() {
    return Obx(() {
      final listOrder = controller.listOrderGroupByMonthComplaint;
      final meta = controller.totalDataComplaint.value;
      return CustomEasyRefresh(
        controller: controller.controllerComplaint,
        onRefresh: controller.onRefreshComplaint,
        infoText:
            '${'now'.tr}: ${controller.orderDataComplaint.length}/ ${meta}',
        onLoading: controller.onLoadingPageComplaint,
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == 9 ? 0 : 16),
            child: ItemOrderRefundByMonth(
              item: listOrder[index],
              onTap: (order) {
                Get.toNamed(
                  Routes.requestRefund,
                  arguments: {
                    'order': order,
                    'type':
                        order.refundStatus == "PENDING" &&
                                order.refundStatus.isNotEmpty
                            ? RequestRefundTabEnum.confirm
                            : RequestRefundTabEnum.result,
                  },
                );
              },
            ),
          ),
          childCount: listOrder.length,
        ),
      );
    });
  }

  Widget _buildListOrder() {
    return Obx(() {
      final listOrder = controller.listOrderGroupByMonth;
      final meta = controller.totalData.value;
      return CustomEasyRefresh(
        controller: controller.controller,
        onRefresh: controller.onRefresh,
        infoText: '${'now'.tr}: ${controller.orderData.length}/ ${meta}',
        onLoading: controller.onLoadingPageReimbursement,
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == 9 ? 0 : 16),
            child: ItemOrderRefundByMonth(
              item: listOrder[index],
              onTap: (order) {
                Get.toNamed(
                  Routes.requestRefund,
                  arguments: {
                    'order': order,
                    'type':
                        order.orderStatus == "DRIVER_CANCELED" &&
                                order.refundStatus.isEmpty
                            ? RequestRefundTabEnum.sentRequest
                            : RequestRefundTabEnum.result,
                  },
                );
              },
            ),
          ),
          childCount: listOrder.length,
        ),
      );
    });
  }
}
