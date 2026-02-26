import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/features/menu/menu_custom/create_food/create_food_controller.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/view/input_add_product_promotion.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'list_menu_controller.dart';

class ListMenuPage extends GetView<ListMenuController> {
  static String? _resolveTag() {
    final args = Get.arguments;
    if (args is Map) {
      final menuType = args['listMenuType']?.toString();
      if (menuType != null && menuType.isNotEmpty)
        return 'listMenuType-$menuType';
    }
    return 'listMenu-default';
  }

  @override
  String? get tag => _resolveTag();

  @override
  final ListMenuController controller = Get.put(
    ListMenuController(),
    tag: _resolveTag(),
  );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
        () => CustomScreen(
          title:
              controller.listMenuType.value == ListMenuType.promotion
                  ? "Quản lý sản phẩm".tr
                  : null,

          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  if (controller.isShowHeaderSearch.value &&
                      controller.listMenuType.value == ListMenuType.all)
                    _buildHeaderSearch(),
                  buildFilterCategory(),
                  Expanded(
                    child: Obx(() {
                      return controller.isLoading.value
                          ? SizedBox.shrink()
                          : CustomEasyRefresh(
                            controller: controller.controller,
                            onRefresh: controller.onRefresh,
                            infoText:
                                '${'now'.tr}: ${controller.listProductData.length}/ ${controller.total.value}',
                            onLoading: controller.onLoadingPage,
                            delegate: SliverChildBuilderDelegate(
                              (context, index) => Padding(
                                padding: EdgeInsets.only(bottom: 12),
                                child: _buildItemMenu(
                                  controller.listProductGroupByCategory[index],
                                ),
                              ),
                              childCount:
                                  controller.listProductGroupByCategory.length,
                            ),
                          );
                    }),
                  ),
                ],
              ),

              if (controller.listMenuType.value == ListMenuType.promotion &&
                  controller.listProductData.isNotEmpty)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12,
                    ).copyWith(
                      bottom:
                          Platform.isIOS
                              ? MediaQuery.of(context).padding.bottom
                              : 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor30,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: Row(
                      children: [
                        Text(
                          "add_product_promotion".tr,
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                        Spacer(),
                        GestureDetector(
                          onTap: () {
                            if (controller.listProductSelected.isEmpty) {
                              DialogUtil.showErrorMessage(
                                "select_product_promotion".tr,
                              );
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => InputAddProductPromotion(
                                      listProductSelected:
                                          controller.listProductSelected,
                                      onConfirm: (listProduct) {
                                        controller.addProductPromotion(
                                          listProduct,
                                        );
                                      },
                                    ),
                              ),
                            );

                            // print(controller.listProductSelected.length);
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
                              "add".tr,
                              style: AppTextStyles.medium12().copyWith(
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderSearch() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w).copyWith(top: 16.h),
        child: Row(
          children: [
            Expanded(
              child: TitleDefaultTextField(
                height: 34.h,
                focusNode: controller.searchFocusNode,
                controller: controller.searchController,
                radius: 360.r,
                innerPadding: EdgeInsets.symmetric(horizontal: 8.w),
                hintText: "Tìm kiếm món".tr,
                onChanged: (value) {
                  controller.onSearch(search: value);
                },
                preIcon: Icon(
                  Icons.search,
                  color: AppColors.grayscaleColor80,
                  size: 20.w,
                ),
              ),
            ),
            SizedBox(width: 8.w),
            if (controller.menuStatusType.value == MenuStatusType.active)
              Expanded(
                child: SizedBox(
                  height: 34.h,
                  child: AppButton(
                    title:
                        controller.listProductSelected.isNotEmpty
                            ? "Đổi trạng thái".tr
                            : "cancel".tr,
                    type: AppButtonType.nomal,
                    onPressed: () {
                      if (controller.listProductSelected.isNotEmpty) {
                        controller.showChangeStatusBottomsheet();
                      } else {
                        controller.toggleStatus();
                      }
                    },
                  ),
                ),
              ),
            if (controller.menuStatusType.value == MenuStatusType.deleted)
              Expanded(
                child: SizedBox(
                  height: 34.h,
                  child: AppButton(
                    title:
                        controller.listProductSelected.isNotEmpty
                            ? "Xóa".tr
                            : "Chọn tất cả".tr,
                    type:
                        controller.listProductSelected.isNotEmpty
                            ? AppButtonType.remove
                            : AppButtonType.nomal,
                    onPressed: () {
                      if (controller.listProductSelected.isNotEmpty) {
                        controller.diaLogDeletedProduct();
                      } else {
                        controller.selectedAllProduct();
                      }
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu(ProductGroupCategoryModel groupProduct) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 12.h,
        children: [
          Text(
            '${groupProduct.category} (${groupProduct.categoryLength})',
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Column(
            spacing: 8.h,
            children: List.generate(
              groupProduct.products.length,
              (index) => _buildItemMenuProduct(groupProduct.products[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemMenuProduct(ProductModel product) {
    return Obx(
      () => GestureDetector(
        onLongPress: () {
          controller.toggleStatus();
        },
        onTap: () {
          if (controller.isShowSelect.value) {
            controller.onSelectItem(product);
          } else {
            Get.toNamed(
              Routes.createFood,
              arguments: {"type": ProductType.edit, "product": product},
            );
          }
        },
        child: Stack(
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 10.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(
                        color: AppColors.grayscaleColor30,
                        width: 0.3,
                      ),
                    ),
                    child: Row(
                      spacing: 8.w,
                      children: [
                        if (controller.isShowSelect.value)
                          GestureDetector(
                            onTap: () {
                              controller.onSelectItem(product);
                            },
                            child: Icon(
                              product.selected.value
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                              size: 18.w,
                              color:
                                  product.selected.value
                                      ? AppColors.primaryColor
                                      : AppColors.grayscaleColor80,
                            ),
                          ),
                        Expanded(
                          child: Stack(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(12.r),
                                    child: CachedImage(
                                      url: product.imageUrlMap,
                                      width: 76.w,
                                      height: 76.w,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  SizedBox(width: 12.w),
                                  Expanded(
                                    child: Column(
                                      spacing: 3.h,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: AppTextStyles.medium14(),
                                        ),
                                        Text(
                                          AppUtil().convertHtmlToPlainText(
                                            product.description,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: AppTextStyles.regular10(),
                                        ),
                                        RichText(
                                          text: TextSpan(
                                            children: [
                                              TextSpan(
                                                text: AppUtil.formatMoney(
                                                  product.priceSale != 0
                                                      ? product.priceSale
                                                          .toDouble()
                                                      : product.price
                                                          .toDouble(),
                                                ),
                                                style: AppTextStyles.medium12()
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .primaryColor60,
                                                    ),
                                              ),
                                              TextSpan(
                                                text: "  ",
                                                style: AppTextStyles.medium12(),
                                              ),
                                              if (product.priceSale != 0 &&
                                                  product.price != 0 &&
                                                  product.priceSale <
                                                      product.price)
                                                TextSpan(
                                                  text: AppUtil.formatMoney(
                                                    product.price.toDouble(),
                                                  ),
                                                  style: AppTextStyles.medium10()
                                                      .copyWith(
                                                        decoration:
                                                            TextDecoration
                                                                .lineThrough,
                                                        color:
                                                            AppColors
                                                                .grayscaleColor40,
                                                      ),
                                                ),
                                            ],
                                          ),
                                        ),
                                        if (product
                                            .productOptionFood
                                            .isNotEmpty)
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.edit_note_outlined,
                                                size: 12.w,
                                                color:
                                                    AppColors.grayscaleColor80,
                                              ),
                                              SizedBox(width: 4.w),
                                              Text(
                                                "Sản phẩm có ${product.productOptionFood.length} tùy chỉnh",
                                                style: AppTextStyles.medium10()
                                                    .copyWith(
                                                      color:
                                                          AppColors
                                                              .grayscaleColor80,
                                                    ),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: 20.w),
                                ],
                              ),
                              if (!product.availability ||
                                  (controller.listMenuType.value ==
                                          ListMenuType.promotion &&
                                      (product.status != "APPROVE" ||
                                          product.keyPromotion.isNotEmpty)))
                                Positioned(
                                  right: 6.w,
                                  top: 0,
                                  left: 0,
                                  bottom: 0,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8.r),
                                      color: AppColors.backgroundColor24
                                          .withOpacity(0.4),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 6.w),
              ],
            ),
            Positioned(
              right: -6.w,
              top: 8.h,
              child: Image.asset(
                product.availability
                    ? AssetConstants.icActive
                    : AssetConstants.icOff,
                width: 60.w,
                height: 20.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterCategory() {
    return GestureDetector(
      onTap: () {
        controller.showBottomSheetCategory();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 6.h),
        margin: EdgeInsets.only(top: 12.h, left: 12.w, right: 12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor24,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.3.w),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Danh mục sản phẩm".tr),
            SizedBox(width: 4.w),
            Icon(
              Icons.keyboard_arrow_down_rounded,
              color: AppColors.grayscaleColor80,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
