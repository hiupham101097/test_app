import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:merchant/features/menu/menu_options/create_product/create_product_controller.dart';
import 'package:merchant/features/menu/menu_options/list_options/list_options_menu_controller.dart';
import 'package:merchant/navigations/app_pages.dart';

import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';

class ListOptionsMenuPage extends GetView<ListOptionsMenuController> {
  const ListOptionsMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(
        child: Obx(() {
          final listOptionProduct = controller.optionProductData;
          final total = controller.total.value;
          return controller.isLoading.value
              ? SizedBox.shrink()
              : Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                child: CustomEasyRefresh(
                  controller: controller.controller,
                  onRefresh: controller.onRefresh,
                  infoText: '${'now'.tr}: ${listOptionProduct.length}/ $total',
                  onLoading: controller.onLoadingPage,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      padding: EdgeInsets.only(
                        bottom:
                            index == listOptionProduct.length - 1 ? 0 : 16.h,
                        top: index == 0 ? 16.h : 0,
                      ),
                      child: _buildItemOptionProduct(
                        controller.optionProductData[index],
                      ),
                    ),
                    childCount: listOptionProduct.length,
                  ),
                ),
              );
        }),
      ),
    );
  }

  Widget _buildItemOptionProduct(OptionProductModel model) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.createProduct,
          arguments: {
            'type': CreateOptionProductType.edit,
            'optionProduct': model,
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.3.w),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8.r),
              child: CachedImage(
                url: model.imageUrl,
                width: 76.w,
                height: 79.h,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 4.h,
                children: [
                  Text(
                    model.name,
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    AppUtil().convertHtmlToPlainText(model.description),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.regular10(),
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppUtil.formatMoney(
                            model.priceSale != 0
                                ? model.priceSale.toDouble()
                                : model.price.toDouble(),
                          ),
                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.primaryColor60,
                          ),
                        ),
                        TextSpan(text: "  ", style: AppTextStyles.medium12()),
                        if (model.priceSale != 0 &&
                            model.price != 0 &&
                            model.priceSale < model.price)
                          TextSpan(
                            text: AppUtil.formatMoney(model.price.toDouble()),
                            style: AppTextStyles.medium10().copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: AppColors.grayscaleColor40,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
