import 'dart:io';

import 'package:merchant/commons/types/status_enum_food.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_dropdown.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/commons/views/pleace_holder_view.dart';
import 'package:merchant/domain/data/models/variant_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'create_food_controller.dart';

class CreateFoodPage extends GetView<CreateFoodController> {
  const CreateFoodPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Obx(
        () => CustomScreen(
          title:
              controller.type.value == ProductType.create
                  ? "Tạo sản phẩm mới".tr
                  : controller.nameController.text,

          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Row(
                  children: [
                    Text(
                      "representative_product_image".tr,
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
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                        : Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.grayscaleColor10,
                                blurRadius: 1.r,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.r),
                            child: Stack(
                              children: [
                                controller.pickedImages.value == null
                                    ? ClipRRect(
                                      borderRadius: BorderRadius.circular(12.r),
                                      child: CachedImage(
                                        url: controller.imageUrl.value!,
                                        width: 104.w,
                                        height: 104.w,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                    : Image.file(
                                      File(controller.pickedImages.value!.path),
                                      width: 104.w,
                                      height: 104.w,
                                      fit: BoxFit.cover,
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
              _buildVariant(),
              SizedBox(height: 12.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  spacing: 12.h,
                  children: [
                    AppButton(
                      title:
                          controller.type.value == ProductType.create
                              ? "Tạo sản phẩm mới".tr
                              : "save_edit".tr,
                      onPressed: () {
                        if (controller.formKey.currentState!.validate()) {
                          controller.addProduct();
                        }
                      },
                      isEnable: controller.isValidate.value,
                    ),
                    if (controller.type.value == ProductType.edit)
                      AppButton(
                        title: "Xoá sản phẩm".tr,
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
        ),
      ),
    );
  }

  Widget _buildVariant() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            spacing: 8.h,
            children: [
              for (var variant in controller.listVariant)
                _buildVariantItem(variant),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                "Thêm biến thể sản phẩm".tr,
                style: AppTextStyles.semibold12().copyWith(
                  color: AppColors.infomationColor,
                ),
              ),
              SizedBox(width: 4.w),
              GestureDetector(
                onTap: () {
                  controller.showBottomSheetAddVariant();
                },
                child: Icon(
                  Icons.add,
                  color: AppColors.infomationColor,
                  size: 16.w,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildVariantItem(VariantModel variant) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grayscaleColor60, width: 1),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                variant.title,
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              Spacer(),
              Text(
                AppUtil.formatMoney(variant.price),
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Divider(color: AppColors.grayscaleColor10, height: 1.h),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  controller.editVariant(variant);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: AppColors.grayscaleColor60,
                      width: 0.5.w,
                    ),
                  ),
                  child: Text(
                    "Chinh sửa".tr,
                    style: AppTextStyles.medium10().copyWith(
                      color: AppColors.infomationColor,
                    ),
                  ),
                ),
              ),

              SizedBox(width: 12.w),
              GestureDetector(
                onTap: () {
                  controller.deleteVariant(variant);
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: AppColors.grayscaleColor60,
                      width: 0.5.w,
                    ),
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  child: Text(
                    "Xóa".tr,
                    style: AppTextStyles.medium10().copyWith(
                      color: AppColors.warningColor,
                    ),
                  ),
                ),
              ),
            ],
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
            if (controller.type.value == ProductType.edit)
              Obx(
                () => CustomDropdown<String>(
                  title: 'status'.tr,
                  hintText: 'select_status'.tr,
                  value: controller.selectedStatus.value?.getLabel(),
                  items:
                      StatusEnumFood.values.map((e) => e.getLabel()).toList(),
                  onChanged: (value) {
                    controller.selectedStatus.value = StatusEnumFood.values
                        .firstWhere((e) => e.getLabel() == value);
                  },
                  isRequired: true,
                  onTap: () {
                    controller.showBottomSheetStatus();
                  },
                ),
              ),
            TitleDefaultTextField(
              focusNode: controller.nameFocusNode,
              title: "name_product".tr,
              hintText: "enter_name_product".tr,
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
            Obx(
              () => CustomDropdown<String>(
                title: 'category'.tr,
                hintText: 'select_category'.tr,
                value: controller.selectedCategory.value?.name,
                items:
                    controller.listCategory.map((e) => e.name ?? "").toList(),
                onChanged: (value) {
                  controller.selectedCategory.value = controller.listCategory
                      .firstWhere((e) => e.name == value);
                },
                isRequired: true,
                onTap: () {
                  controller.showBottomSheetCategory();
                },
              ),
            ),

            TitleDefaultTextField(
              focusNode: controller.optionProductFocusNode,
              textInputType: TextInputType.number,
              readOnly: true,
              title: "Sản phẩm đính kèm".tr,
              hintText: "Chọn sản phẩm đính kèm".tr,
              controller: controller.optionProductController,
              inputFormatter: [ThousandsFormatter()],
              maxLines: null,
              onTab: () {
                controller.showBottomSheetOptionProduct();
              },
              onTabSuffix: () {
                controller.showBottomSheetOptionProduct();
              },
              suffix: Icon(
                Icons.keyboard_arrow_down_sharp,
                color: AppColors.grayscaleColor80,
              ),
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
              onChanged: (value) {},
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
