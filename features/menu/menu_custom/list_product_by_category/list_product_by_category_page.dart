import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'list_product_by_category_controller.dart';

class ListProductByCategoryPage
    extends GetView<ListProductByCategoryController> {
  const ListProductByCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final items = controller.listProduct;
      return CustomScreen(
        title: controller.categoryName.value,
        child: ReorderableListView(
          onReorder:
              (oldIndex, newIndex) => controller.reorder(oldIndex, newIndex),
          children: [
            for (int index = 0; index < items.length; index++)
              ReorderableDragStartListener(
                key: ValueKey(items[index]),
                index: index,
                child: _buildItem(items[index]),
              ),
          ],
        ),
      );
    });
  }

  Widget _buildItem(ProductModel item) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor24,
          border: Border(
            bottom: BorderSide(color: AppColors.grayscaleColor30, width: 0.5),
          ),
        ),
        child: Row(
          spacing: 12.w,
          children: [
            Icon(Icons.menu, color: AppColors.grayscaleColor80, size: 24),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.w,
                children: [
                  CachedImage(
                    radius: 4,
                    url: item.imageUrlMap ?? "",
                    width: 79.w,
                    height: 79.w,
                    fit: BoxFit.cover,
                  ),
                  Expanded(
                    child: Column(
                      spacing: 3.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(item.name, style: AppTextStyles.medium14()),
                        Text(
                          AppUtil().convertHtmlToPlainText(item.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.regular10(),
                        ),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: AppUtil.formatMoney(
                                  item.priceSale != 0
                                      ? item.priceSale.toDouble()
                                      : item.price.toDouble(),
                                ),
                                style: AppTextStyles.medium12().copyWith(
                                  color: AppColors.primaryColor60,
                                ),
                              ),
                              TextSpan(
                                text: "  ",
                                style: AppTextStyles.medium12(),
                              ),
                              if (item.priceSale != 0 &&
                                  item.price != 0 &&
                                  item.priceSale < item.price)
                                TextSpan(
                                  text: AppUtil.formatMoney(
                                    item.price.toDouble(),
                                  ),
                                  style: AppTextStyles.medium10().copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: AppColors.grayscaleColor40,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        if (item.productOptionFood.isNotEmpty)
                          Row(
                            children: [
                              Icon(
                                Icons.edit_note_outlined,
                                size: 12.w,
                                color: AppColors.grayscaleColor80,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                "Sản phẩm có ${item.productOptionFood.length} tùy chỉnh",
                                style: AppTextStyles.medium10().copyWith(
                                  color: AppColors.grayscaleColor80,
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
          ],
        ),
      ),
    );
  }
}
