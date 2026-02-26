import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'arrange_dishes_controller.dart';

class ArrangeDishesPage extends GetView<ArrangeDishesController> {
  const ArrangeDishesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "arrange_dishes".tr,
      child: Obx(() {
        final items = controller.listCategory;
        return CustomEasyRefresh(
          controller: controller.controller,
          onRefresh: controller.onRefresh,
          infoText: '${'now'.tr}: ${items.length}/ ${controller.total.value}',
          onLoading: controller.onLoadingPage,
          childCount: items.length,
          sliver: SliverReorderableList(
            itemCount: items.length,
            onReorder:
                (oldIndex, newIndex) => controller.reorder(oldIndex, newIndex),
            itemBuilder: (context, index) {
              final item = items[index];
              return _buildItem(item, index);
            },
          ),
        );
      }),
    );
  }

  Widget _buildItem(CategoryModel item, int index) {
    return GestureDetector(
      key: ValueKey(item.id),
      // onTap: () {
      //   Get.toNamed(
      //     Routes.listProductByCategory,
      //     arguments: {'categoryId': item.id, "name": item.name},
      //   );
      // },
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
            ReorderableDragStartListener(
              index: index,
              child: Icon(
                Icons.menu,
                color: AppColors.grayscaleColor80,
                size: 24,
              ),
            ),
            Expanded(
              child: Text(
                item.name ?? "",
                style: AppTextStyles.medium14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ),
            Icon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.grayscaleColor80,
              size: 12,
            ),
          ],
        ),
      ),
    );
  }
}
