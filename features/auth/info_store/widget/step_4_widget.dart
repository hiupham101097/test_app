import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/features/auth/info_store/widget/pikemage_mutil_widget.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';

class Step4Widget extends GetView<InfoStoreController> {
  const Step4Widget({super.key});

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
              focusNode: controller.codeNumberFocusNode,
              controller: controller.codeNumberController,
              title: "Mã số thuế".tr,
              hintText: "Nhập mã số thuế".tr,
              textInputType: TextInputType.number,
              validator: (value) => Validator.formValidation(value),
            ),
            Obx(
              () => PickImageMutilWidget(
                pickedImages:
                    controller.pickedImagesVerificationDocuments.value,
                title: "Tải file GPKD/ GPKD có điều kiện",
                width: (Get.width - 48.w) / 2,
                maxImages: 5,
                height: 118.h,
                onTap: (value) {
                  controller.pickedImagesVerificationDocuments.add(value);
                },
                onDelete: (value) {
                  controller.pickedImagesVerificationDocuments.remove(value);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
