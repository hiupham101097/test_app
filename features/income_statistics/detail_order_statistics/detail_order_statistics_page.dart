import 'package:merchant/commons/views/build_item_oder_widget.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'detail_order_statistics_controller.dart';

class DetailOrderStatisticsPage
    extends GetView<DetailOrderStatisticsController> {
  const DetailOrderStatisticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "detail_order_statistics".tr,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      final listOrder = controller.orderData;
      final meta = controller.total.value;
      return controller.loading.value
          ? SizedBox.shrink()
          : CustomEasyRefresh(
            controller: controller.controller,
            onRefresh: controller.onRefresh,
            infoText: '${'now'.tr}: ${listOrder.length}/ ${meta}',
            onLoading: controller.onLoadingPage,
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.only(
                  bottom: 16.h,
                  top: index == 0 ? 16.h : 0,
                ),
                child: BuildItemOrderWidget(item: controller.orderData[index]),
              ),
              childCount: listOrder.length,
            ),
          );
    });
  }
}
