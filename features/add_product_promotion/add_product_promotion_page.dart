import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'add_product_promotion_controller.dart';

class AddProductPromotionPage extends GetView<AddProductPromotionController> {
  const AddProductPromotionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title: controller.promotionDetail.value.name ?? '',
        child: _buildProduct(),
        floatingActionButton:
            controller.listProductGroupByCategory.isNotEmpty
                ? FloatingActionButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(360.r),
                  ),
                  backgroundColor: AppColors.primaryColor,
                  onPressed: () {
                    Get.toNamed(
                      Routes.listMenu,
                      arguments: {
                        'listMenuType': ListMenuType.promotion,
                        'promotion': controller.promotionDetail.value,
                        'listProductSelected': controller.listProductData,
                      },
                    );
                  },
                  child: const Icon(Icons.add, color: Colors.white),
                )
                : null,
      ),
    );
  }

  _buildProduct() {
    return Obx(() {
      final meta = controller.total.value;
      final data = controller.listProductGroupByCategory;
      return controller.isLoading.value
          ? SizedBox.shrink()
          : data.isEmpty
          ? _buildEmpty()
          : CustomEasyRefresh(
            controller: controller.controller,
            onRefresh: controller.onRefresh,
            infoText:
                '${'now'.tr}: ${controller.listProductData.length}/ ${meta}',
            onLoading: controller.onLoadingPage,
            delegate: SliverChildBuilderDelegate(
              (context, index) => Padding(
                padding: EdgeInsets.only(
                  bottom: index == data.length - 1 ? 0 : 14.h,
                  top: index == 0 ? 12.h : 0,
                ),
                child: _buildItemMenu(data[index]),
              ),
              childCount: data.length,
            ),
          );
    });
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
    return GestureDetector(
      onTap: () {
        controller.showBottomSheetUpdateVoucher(product);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.3),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
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
                SizedBox(height: 4.h),
                GestureDetector(
                  onTap: () {
                    controller.diaLogDeletedProduct(product);
                  },
                  child: Text(
                    "delete".tr,
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.warningColor,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                spacing: 3.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: AppTextStyles.medium14()),
                  Text(
                    AppUtil().convertHtmlToPlainText(product.description),
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
                                ? product.priceSale.toDouble()
                                : product.price.toDouble(),
                          ),
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.primaryColor60,
                          ),
                        ),
                        TextSpan(text: "  ", style: AppTextStyles.medium12()),
                        if (product.priceSale != 0 &&
                            product.price != 0 &&
                            product.priceSale < product.price)
                          TextSpan(
                            text: AppUtil.formatMoney(product.price.toDouble()),
                            style: AppTextStyles.medium10().copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.grayscaleColor40,
                            ),
                          ),
                      ],
                    ),
                  ),
                  if (product.productOptionFood.isNotEmpty)
                    Row(
                      children: [
                        Icon(
                          Icons.edit_note_outlined,
                          size: 12.w,
                          color: AppColors.grayscaleColor80,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          "Sản phẩm có ${product.productOptionFood.length} tùy chỉnh",
                          style: AppTextStyles.medium10().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ],
                    ),
                  SizedBox(height: 4.h),
                  if (product.quantityPromotion > 0 &&
                      product.quantityPromotion > product.sellPromotion)
                    Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor10,
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          width: Get.width,
                          height: 12.h,
                        ),
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width:
                                (product.sellPromotion /
                                    product.quantityPromotion) *
                                Get.width,
                            height: 12.h,
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor40,
                              borderRadius: BorderRadius.circular(100.r),
                            ),
                          ),
                        ),
                        Positioned.fill(
                          child: Center(
                            child: Text(
                              "${product.sellPromotion}/ ${product.quantityPromotion}",
                              style: AppTextStyles.bold11().copyWith(
                                color: AppColors.grayscaleColor80,
                                height: 1,
                                fontSize: 10.sp,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(AssetConstants.icEmptyImage, width: 128.r, height: 128.r),
        Text(
          "Hiện tại, bạn chưa có danh sách sản phẩm!".tr,
          style: AppTextStyles.regular12(),
        ),
        GestureDetector(
          onTap: () {
            Get.toNamed(
              Routes.listMenu,
              arguments: {
                'listMenuType': ListMenuType.promotion,
                'promotion': controller.promotionDetail.value,
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.add_circle_sharp,
                color: AppColors.primaryColor,
                size: 20.r,
              ),
              SizedBox(width: 8.w),
              Text(
                "Hãy nhấp vào biểu tượng này, để thêm sản phẩm".tr,
                style: AppTextStyles.medium12().copyWith(
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
