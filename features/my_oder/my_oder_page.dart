import 'package:flutter/material.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/build_item_oder_widget.dart';
import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'my_oder_controller.dart';

class MyOrderPage extends GetView<MyOrderController> {
  const MyOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "my_orders".tr,
      isBack: false,
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Stack(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  clipBehavior: Clip.none,
                  child: Row(
                    children: List.generate(
                      StatusOrderEnum.values.length,
                      (index) => GestureDetector(
                        onTap: () {
                          controller.onChangeTab(StatusOrderEnum.values[index]);
                        },
                        child: Obx(
                          () => Container(
                            margin: EdgeInsets.only(
                              top: 12.h,
                              right:
                                  index == StatusOrderEnum.values.length - 1
                                      ? 0
                                      : 8.w,
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(360.r),
                              border: Border.all(
                                color:
                                    controller.selectedTab.value ==
                                            StatusOrderEnum.values[index]
                                        ? AppColors.primaryColor80
                                        : AppColors.grayscaleColor30,
                                width: 1.w,
                              ),
                              color:
                                  controller.selectedTab.value ==
                                          StatusOrderEnum.values[index]
                                      ? AppColors.primaryColor
                                      : null,
                            ),
                            child: Text(
                              "${StatusOrderEnum.values[index].getLabel()}",
                              style: AppTextStyles.medium12().copyWith(
                                color:
                                    controller.selectedTab.value ==
                                            StatusOrderEnum.values[index]
                                        ? Colors.white
                                        : AppColors.grayscaleColor50,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),
                if (controller.selectedTab.value == StatusOrderEnum.PENDING &&
                    controller.metaData.value.total > 0) ...[
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor20,
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          AssetConstants.icNotify,
                          width: 24.w,
                          height: 24.h,
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Bạn đang có ${controller.metaData.value.total} đơn hàng mới!",
                            style: AppTextStyles.medium12().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 8.h),
                ],

                if (controller.metaData.value.total > 0) ...[
                  Row(
                    children: [
                      Text(
                        "Tổng số đơn hiện có:",
                        style: AppTextStyles.regular12().copyWith(
                          color: AppColors.grayscaleColor80,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      Spacer(),
                      Text(
                        "${controller.metaData.value.total} Đơn hàng",
                        style: AppTextStyles.medium12().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),
                ],

                Obx(() {
                  final listOrder = controller.orderData;
                  final meta = controller.metaData.value;
                  return Expanded(
                    child:
                        controller.loading.value
                            ? SizedBox.shrink()
                            : CustomEasyRefresh(
                              controller: controller.controller,
                              onRefresh: controller.onRefresh,
                              infoText:
                                  '${'now'.tr}: ${listOrder.length}/ ${meta.total}',
                              onLoading: controller.onLoadingPage,
                              delegate: SliverChildBuilderDelegate(
                                (context, index) => Padding(
                                  padding: EdgeInsets.only(bottom: 16.h),
                                  child: BuildItemOrderWidget(
                                    item: controller.orderData[index],
                                    showSelectedItem:
                                        controller.showSelectedItem.value,
                                    onSelectItem: controller.onSelectItem,
                                    onLongPress: controller.onLongPress,
                                  ),
                                ),
                                childCount: listOrder.length,
                              ),
                            ),
                  );
                }),
              ],
            ),
          ),

          if (controller.selectedTab.value == StatusOrderEnum.PENDING &&
              controller.orderData.isNotEmpty)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w,
                  vertical: 12,
                ).copyWith(bottom: 12),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor30,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  ),
                ),
                child: Row(
                  children: [
                    controller.selectedOrderData.isNotEmpty
                        ? Text(
                          "Bạn muốn nhận ${controller.selectedOrderData.length} đơn hàng"
                              .tr,
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        )
                        : Text(
                          "you_want_to_receive_all_orders".tr,
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                    Spacer(),
                    GestureDetector(
                      onTap: () async {
                        final systems = StoreDB().getSystem();
                        final futures =
                            systems.map((element) {
                              return controller.onConfirmAllOrders(
                                system: element,
                              );
                            }).toList();
                        await Future.wait(futures);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor5,
                          borderRadius: BorderRadius.circular(360.r),
                          border: Border.all(
                            color: AppColors.primaryColor80,
                            width: 0.5,
                          ),
                        ),
                        child: Text(
                          controller.selectedOrderData.isNotEmpty
                              ? "Xác nhận".tr
                              : "receive_all".tr,
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    if (controller.showSelectedItem.value) ...[
                      SizedBox(width: 8.w),
                      GestureDetector(
                        onTap: () {
                          controller.onClearSelectedItem();
                        },
                        child: Icon(
                          Icons.clear,
                          size: 16.w,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
