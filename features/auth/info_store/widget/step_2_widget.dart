import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/item_location.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class Step2Widget extends GetView<InfoStoreController> {
  const Step2Widget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
        child: Column(
          spacing: 24.h,
          children: [
            TitleDefaultTextField(
              focusNode: controller.searchLocationFocusNode,
              controller: controller.searchLocationController,
              title: "Địa chỉ".tr,
              hintText: "Nhập địa chỉ của bạn".tr,
              textInputType: TextInputType.text,
              onChanged: (value) {
                controller.onSearchLocation(value);
              },
            ),
            if (controller.listLocation.isNotEmpty &&
                controller.showListSuggestion.value)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.grayscaleColor40,
                    width: 1.w,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 4.h,
                  children: [
                    ...controller.listLocation.map(
                      (e) => GestureDetector(
                        onTap: () {
                          controller.onSelectLocation(e);
                        },
                        child: ItemLocation(
                          newValue: e.fullNewAddress,
                          oldValue: e.fullAddress,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            TitleDefaultTextField(
              focusNode: controller.streetFocusNode,
              controller: controller.streetController,
              title: "Đường".tr,
              hintText: "--//--".tr,
              readOnly: true,
              textInputType: TextInputType.text,
            ),
            TitleDefaultTextField(
              focusNode: controller.wardFocusNode,
              controller: controller.wardController,
              title: "Phường/ Xã".tr,
              hintText: "--//--".tr,
              readOnly: true,
              textInputType: TextInputType.text,
            ),
            // TitleDefaultTextField(
            //   focusNode: controller.districtFocusNode,
            //   controller: controller.districtController,
            //   title: "Quận/ Huyện".tr,
            //   readOnly: true,
            //   hintText: "--//--".tr,
            //   textInputType: TextInputType.text,
            // ),
            TitleDefaultTextField(
              focusNode: controller.provinceFocusNode,
              controller: controller.provinceController,
              title: "Thành phố".tr,
              hintText: "--//--".tr,
              readOnly: true,
              textInputType: TextInputType.text,
            ),
          ],
        ),
      ),
    );
  }
}
