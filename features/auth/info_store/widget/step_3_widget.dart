import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/features/auth/info_store/widget/pikemage_mutil_widget.dart';
import 'package:merchant/features/auth/info_store/widget/pikemage_widget.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';

class Step3Widget extends GetView<InfoStoreController> {
  const Step3Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 24.h,
          children: [
            TitleDefaultTextField(
              focusNode: controller.minPriceFocusNode,
              controller: controller.minPriceController,
              title: "Giá thấp nhất".tr,
              hintText: "Nhập đơn giá".tr,
              inputFormatter: [ThousandsFormatter()],
              textInputType: TextInputType.number,
              validator: (value) => Validator.formValidation(value),
            ),

            TitleDefaultTextField(
              focusNode: controller.maxPriceFocusNode,
              controller: controller.maxPriceController,
              inputFormatter: [ThousandsFormatter()],
              title: "Giá cao nhất".tr,
              hintText: "Nhập đơn giá".tr,
              textInputType: TextInputType.number,
              validator: (value) => Validator.formValidation(value),
            ),
            Obx(
              () => PickImageWidget(
                pickedImages: controller.pickedImagesMenus.value,
                title: "Hình ảnh menu",
                width: (Get.width - 48.w) / 2,
                height: 118.h,
                onTap: (value) {
                  controller.pickedImagesMenus.value = value;
                },
                onDelete: (value) {
                  controller.pickedImagesMenus.value = "";
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
