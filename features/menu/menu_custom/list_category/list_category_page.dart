import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/features/menu/menu_custom/create_category/create_category_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'list_category_controller.dart';

class ListCategoryPage extends GetView<ListCategoryController> {
  const ListCategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "list_category".tr,
      child: Obx(() {
        final listCategory = controller.listCategory;
        final meta = controller.total.value;
        return controller.isLoading.value
            ? SizedBox.shrink()
            : Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: CustomEasyRefresh(
                controller: controller.controller,
                onRefresh: controller.onRefresh,
                infoText: '${'now'.tr}: ${listCategory.length}/ ${meta}',
                onLoading: controller.onLoadingPage,
                delegate: SliverChildBuilderDelegate(
                  (context, index) => Padding(
                    padding: EdgeInsets.only(bottom: index == 9 ? 0 : 10),
                    child: _buildItemCategory(controller.listCategory[index]),
                  ),
                  childCount: controller.listCategory.length,
                ),
              ),
            );
      }),
    );
  }

  Widget _buildItemCategory(CategoryModel category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor24,
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor30, width: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  category.name ?? "",
                  style: AppTextStyles.medium14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  Get.toNamed(
                    Routes.createCategory,
                    arguments: {
                      'category': category,
                      'createCategoryType': CreateCategoryType.edit,
                      'categorySestym': category.systemCategoryId,
                    },
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360.r),
                    border: Border.all(color: AppColors.infomationColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        FontAwesomeIcons.edit,
                        color: AppColors.infomationColor,
                        size: 16.r,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "edit".tr,
                        style: AppTextStyles.semibold10().copyWith(
                          color: AppColors.infomationColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Obx(
                () => GestureDetector(
                  onTap: () {
                    controller.toggleSubCategory(category);
                  },
                  child: Icon(
                    !category.showSubCategory.value
                        ? FontAwesomeIcons.chevronDown
                        : FontAwesomeIcons.chevronUp,
                    color: AppColors.grayscaleColor80,
                    size: 12.r,
                  ),
                ),
              ),
            ],
          ),
          // SizedBox(height: 8.h),
          // if (category.showSubCategory.value)
          //   Container(
          //     padding: EdgeInsets.symmetric(horizontal: 12.w),
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: List.generate(
          //         category.length ?? 0,
          //         (index) => Padding(
          //           padding: EdgeInsets.only(
          //             bottom:
          //                 index == category.subCategories.length - 1 ? 0 : 8.h,
          //           ),
          //           child: Text(
          //             category.subCategories[index],
          //             style: AppTextStyles.medium12().copyWith(
          //               color: AppColors.grayscaleColor80,
          //             ),
          //           ),
          //         ),
          //       ),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
