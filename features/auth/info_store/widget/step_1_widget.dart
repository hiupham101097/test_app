import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/features/auth/info_store/widget/pikemage_widget.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';

class Step1Widget extends GetView<InfoStoreController> {
  const Step1Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 24.h,
            children: [
              Text(
                'Thông tin cửa hàng',
                style: AppTextStyles.semibold14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              TitleDefaultTextField(
                focusNode: controller.nameFocusNode,
                controller: controller.nameController,
                title: "Tên cửa hàng".tr,
                hintText: "Tên cửa hàng".tr,
                textInputType: TextInputType.text,
                validator: (value) => Validator.formValidation(value),
              ),
              TitleDefaultTextField(
                focusNode: controller.selectedFieldFocusNode,
                controller: controller.selectedFieldController,
                title: "Lĩnh vực kinh doanh".tr,
                hintText: "Lựa chọn lĩnh vực kinh doanh".tr,
                textInputType: TextInputType.text,
                readOnly: true,
                onTab: () {
                  controller.showBottomSheetField();
                },
                suffix: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.grayscaleColor80,
                ),
                onTabSuffix: () {
                  controller.showBottomSheetField();
                },
              ),
              TitleDefaultTextField(
                focusNode: controller.selectedCategorySestymFocusNode,
                controller: controller.selectedCategorySestymController,
                title: "Danh mục sản phẩm".tr,
                hintText: "Lựa chọn danh mục".tr,
                textInputType: TextInputType.text,
                readOnly: true,
                onTab: () {
                  if (controller.listCategorySestym.isNotEmpty) {
                    controller.showBottomSheetCategory();
                  }
                },
                suffix: Icon(
                  Icons.keyboard_arrow_down_sharp,
                  color: AppColors.grayscaleColor80,
                ),
                onTabSuffix: () {
                  if (controller.listCategorySestym.isNotEmpty) {
                    controller.showBottomSheetCategory();
                  }
                },
              ),
              TitleDefaultTextField(
                focusNode: controller.descriptionFocusNode,
                controller: controller.descriptionController,
                title: "Mô tả ".tr,
                hintText: "Nhâp mô tả cửa hàng".tr,
                textInputType: TextInputType.text,
                validator: (value) => Validator.formValidation(value),
              ),
              PickImageWidget(
                pickedImages: controller.pickedImagesAvatar.value,
                title: "Hình ảnh đại diện",
                width: (Get.width - 48.w) / 2,
                height: 118.h,
                onTap: (value) {
                  controller.pickedImagesAvatar.value = value;
                },
                onDelete: (value) {
                  controller.pickedImagesAvatar.value = "";
                },
              ),
              PickImageWidget(
                pickedImages: controller.pickedImagesBanner.value,
                title: "Hình ảnh Banner",
                width: Get.width - 24.w,
                height: 200.h,
                onTap: (value) {
                  controller.pickedImagesBanner.value = value;
                },
                onDelete: (value) {
                  controller.pickedImagesBanner.value = "";
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
