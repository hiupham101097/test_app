import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_dropdown.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'create_category_controller.dart';

class CreateCategoryPage extends GetView<CreateCategoryController> {
  @override
  final CreateCategoryController controller = Get.put(
    CreateCategoryController(),
    tag: DateTime.now().toString(),
  );

  @override
  String? get tag => Get.arguments['productId'] as String;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(
        resizeToAvoidBottomInset: false,
        title:
            controller.createCategoryType.value == CreateCategoryType.create
                ? "Tạo danh mục cửa hàng".tr
                : "Sửa danh mục cửa hàng".tr,

        child: Obx(
          () => Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TitleDefaultTextField(
                        focusNode: controller.systemFocusNode,
                        controller: controller.systemController,
                        title: "Lĩnh vực hoạt động".tr,
                        hintText: "Chọn lĩnh vực hoạt động".tr,
                        readOnly: true,
                        onTab: () {
                          if (controller.listSystem.length > 1) {
                            controller.showBottomSheetSystem();
                          }
                        },
                        suffix: Icon(
                          Icons.keyboard_arrow_down_sharp,
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      CustomDropdown<String>(
                        title: 'belong_to_category'.tr,
                        hintText: 'select_category'.tr,
                        value: controller.selectedCategorySestym.value?.name,
                        items:
                            controller.listCategorySestym
                                .map((e) => e.name ?? "")
                                .toList()
                                .obs,
                        onChanged: (value) {
                          controller.selectedCategorySestym.value = controller
                              .listCategorySestym
                              .firstWhere((e) => e.name == value);
                        },
                        onTap: () {
                          if (controller.systemController.text.isNotEmpty) {
                            controller.showBottomSheetCategory();
                          }
                        },
                      ),
                      SizedBox(height: 20.h),
                      TitleDefaultTextField(
                        focusNode: controller.categoryNameFocusNode,
                        controller: controller.categoryNameController,
                        title: "name_category".tr,
                        hintText: "enter_name_category".tr,
                      ),

                      SizedBox(height: 10.h),
                      controller.createCategoryType.value ==
                              CreateCategoryType.create
                          ? GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.listCategory);
                            },
                            child: Text(
                              "list_category".tr,
                              style: AppTextStyles.semibold12().copyWith(
                                color: AppColors.infomationColor,
                              ),
                            ),
                          )
                          : SizedBox.shrink(),
                    ],
                  ),
                ),
                AppButton(
                  title:
                      controller.createCategoryType.value ==
                              CreateCategoryType.create
                          ? "Thêm danh mục".tr
                          : "Lưu".tr,

                  isEnable: controller.isValidate.value,
                  onPressed: () {
                    controller.createCategoryType.value ==
                            CreateCategoryType.create
                        ? controller.addCategory()
                        : controller.updateCategory();
                  },
                ),
                if (controller.createCategoryType.value ==
                    CreateCategoryType.edit) ...[
                  SizedBox(height: 10.h),
                  AppButton(
                    title: "Xoá danh mục".tr,
                    type: AppButtonType.text,
                    onPressed: () {
                      controller.diaLogDeleteCategory();
                    },
                    colorText: AppColors.warningColor,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
