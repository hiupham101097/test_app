import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/commons/views/pleace_holder_view.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'create_product_controller.dart';

class CreateProductPage extends GetView<CreateProductController> {
  const CreateProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(
        title:
            controller.type.value == CreateOptionProductType.create
                ? "Sản phẩm đính kèm".tr
                : controller.nameController.text,

        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 20.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      children: [
                        Text(
                          "Ảnh đại diện sản phẩm đính kèm".tr,
                          style: AppTextStyles.medium14().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                        Text(
                          "*",
                          style: AppTextStyles.medium14().copyWith(
                            color: AppColors.warningColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    child: Row(
                      children: [
                        controller.imageUrl.value == null &&
                                controller.pickedImages.value == null
                            ? PleaceHolderView(
                              onTap: () {
                                AppUtil().pickImages().then((value) {
                                  if (value.path.isNotEmpty) {
                                    controller.pickedImages.value = value;
                                  }
                                });
                              },
                              width: 104.w,
                              height: 104.w,
                            )
                            : ClipRRect(
                              borderRadius: BorderRadius.circular(12.r),
                              child: Stack(
                                children: [
                                  controller.pickedImages.value == null
                                      ? ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          12.r,
                                        ),
                                        child: CachedImage(
                                          url: controller.imageUrl.value!,
                                          width: 104.w,
                                          height: 104.w,
                                        ),
                                      )
                                      : Image.file(
                                        File(
                                          controller.pickedImages.value!.path,
                                        ),
                                        width: 104.w,
                                        height: 104.w,
                                      ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        controller.imageUrl.value = null;
                                        controller.pickedImages.value = null;
                                      },
                                      icon: Container(
                                        padding: EdgeInsets.all(4.w),
                                        decoration: BoxDecoration(
                                          color: AppColors.warningColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 12.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                      color: AppColors.warningColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "beautiful_image_will_attract_customers".tr,
                            style: AppTextStyles.regular10(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Divider(color: AppColors.grayscaleColor10, height: 1.h),
                  SizedBox(height: 12.h),
                  _buildForm(),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              spacing: 12.h,
              children: [
                AppButton(
                  title:
                      controller.type.value == CreateOptionProductType.create
                          ? "Thêm sản phẩm đính kèm".tr
                          : "save_edit".tr,
                  onPressed: () {
                    if (controller.formKey.currentState!.validate()) {
                      controller.actionOptionProduct();
                    }
                  },
                  isEnable: controller.isValidate.value,
                ),
                if (controller.type.value == CreateOptionProductType.edit)
                  AppButton(
                    title: "Xoá sản phẩm đính kèm".tr,
                    onPressed: () {
                      controller.actionDelete();
                    },
                    type: AppButtonType.text,
                    colorText: AppColors.warningColor,
                    // isEnable: controller.isValidate.value,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: controller.formKey,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          spacing: 20.h,
          children: [
            TitleDefaultTextField(
              focusNode: controller.nameFocusNode,
              title: "Tên sản phẩm đính kèm".tr,
              hintText: "Nhập tên sản phẩm đính kèm".tr,
              controller: controller.nameController,
              required: true,
              onChanged: (value) {},
            ),
            TitleDefaultTextField(
              focusNode: controller.descriptionFocusNode,
              title: "description".tr,
              hintText: "enter_description".tr,
              controller: controller.descriptionController,
              maxLines: null,
              onChanged: (value) {},
              required: true,
            ),

            TitleDefaultTextField(
              focusNode: controller.priceFocusNode,
              textInputType: TextInputType.number,
              title: "price".tr,
              hintText: "enter_price".tr,
              controller: controller.priceController,
              inputFormatter: [ThousandsFormatter()],
              required: true,
              onChanged: (value) {},
              suffix: Container(
                margin: EdgeInsets.only(top: 13),
                child: Text(
                  "đ",
                  style: AppTextStyles.regular14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
            ),
            TitleDefaultTextField(
              focusNode: controller.priceSaleFocusNode,
              textInputType: TextInputType.number,
              title: "price_sale".tr,
              hintText: "enter_price_sale".tr,
              controller: controller.priceSaleController,
              inputFormatter: [ThousandsFormatter()],
              validator: (value) {
                if (value != null &&
                    (double.tryParse(value.replaceAll(',', '')) ?? 0) >
                        (double.tryParse(
                              controller.priceController.text.replaceAll(
                                ',',
                                '',
                              ),
                            ) ??
                            0)) {
                  return "price_sale_must_be_less_than_price".tr;
                }
                return null;
              },
              suffix: Container(
                margin: EdgeInsets.only(top: 13),
                child: Text(
                  "đ",
                  style: AppTextStyles.regular14().copyWith(
                    color: AppColors.grayscaleColor80,
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
