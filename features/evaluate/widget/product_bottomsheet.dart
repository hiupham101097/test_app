import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/features/evaluate/evaluate_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class ProductBottomsheet extends GetView<EvaluateController> {
  const ProductBottomsheet({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => controller.searchFocusNodeProduct.unfocus(),
      child: Container(
        padding: EdgeInsets.all(12.w).copyWith(
          bottom:
              MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                  ? 40.h
                  : 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Align(
                  child: Text(
                    "Bộ lọc sản phẩm".tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semibold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: controller.onResetProduct,
                    child: Icon(Icons.close),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            TitleDefaultTextField(
              height: 34.h,
              focusNode: controller.searchFocusNodeProduct,
              controller: controller.searchControllerProduct,
              radius: 360.r,
              innerPadding: EdgeInsets.symmetric(horizontal: 8.w),
              hintText: "Tìm sản phẩm".tr,
              onChanged: (value) {
                controller.onSearchProduct(search: value);
              },
              preIcon: Icon(
                Icons.search,
                color: AppColors.grayscaleColor80,
                size: 20.w,
              ),
            ),
            SizedBox(height: 12.h),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: Get.height * 0.6,
                minHeight: 10.h,
              ),
              child: Obx(() {
                final listOrder = controller.listProductGroupByCategory;
                final meta = controller.totalProduct.value;
                return CustomEasyRefresh(
                  controller: controller.controllerProduct,
                  onRefresh: controller.onRefreshProduct,
                  infoText:
                      '${'now'.tr}: ${controller.listProductData.length}/ ${meta}',
                  onLoading: controller.onLoadingPageProduct,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildItem(listOrder[index]),
                    childCount: listOrder.length,
                  ),
                );
              }),
            ),
            SizedBox(height: 12.h),
            Row(
              spacing: 12.w,
              children: [
                Expanded(
                  child: AppButton(
                    title: "ĐẶT LẠI",
                    type: AppButtonType.nomal,
                    onPressed: () {
                      controller.onResetProduct();
                    },
                  ),
                ),
                Expanded(
                  child: AppButton(
                    title: "XÁC NHẬN",
                    type: AppButtonType.outline,
                    onPressed: () {
                      controller.onConfirmProduct(
                        controller.listProductSelectedTemp,
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(ProductGroupCategoryModel productGroupCategory) {
    return Obx(
      () => Container(
        width: Get.width,
        padding: EdgeInsets.symmetric(vertical: 6.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grayscaleColor30, width: 0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${productGroupCategory.category} (${productGroupCategory.categoryLength})',
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            SizedBox(height: 6.h),
            ...List.generate(
              productGroupCategory.products.length,
              (index) => GestureDetector(
                onTap: () {
                  if (controller.listProductSelectedTemp.contains(
                    productGroupCategory.products[index].id,
                  )) {
                    controller.listProductSelectedTemp.remove(
                      productGroupCategory.products[index].id,
                    );
                  } else {
                    controller.listProductSelectedTemp.add(
                      productGroupCategory.products[index].id,
                    );
                  }
                },
                child: Container(
                  width: Get.width,
                  margin: EdgeInsets.only(bottom: 8.h),
                  padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 6.w),
                  decoration: BoxDecoration(
                    color:
                        controller.listProductSelectedTemp.contains(
                              productGroupCategory.products[index].id,
                            )
                            ? AppColors.backgroundColor12
                            : null,
                    borderRadius: BorderRadius.circular(4.r),
                    boxShadow:
                        controller.listProductSelectedTemp.contains(
                              productGroupCategory.products[index].id,
                            )
                            ? [
                              BoxShadow(
                                color: AppColors.grayscaleColor20,
                                blurRadius: 0,
                                offset: const Offset(0, 2),
                              ),
                            ]
                            : null,
                  ),
                  child: Text(
                    productGroupCategory.products[index].name,
                    style: AppTextStyles.regular14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
