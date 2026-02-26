import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/commons/views/pleace_holder_view.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/features/refund/request_refund/view/form_request_widget.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'request_refund_controller.dart';

class RequestRefundPage extends GetView<RequestRefundController> {
  const RequestRefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => CustomScreen(
        onBackPress: () {
          controller.actionBack();
        },
        title:
            controller.order.value.refundStatus == AppConstants.refundPending
                ? "request_refund".tr
                : "refund_detail".tr,
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 24.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.order.value.orderStatus ==
                                AppConstants.refundFailed ||
                            controller.order.value.refundStatus ==
                                AppConstants.reject)
                          _buildReject(),
                        if (controller.order.value.orderStatus ==
                                AppConstants.refundPending &&
                            controller.order.value.refundStatus.isEmpty)
                          _buildSuccess(
                            "refund_success_description".tr,
                            "refund_success_description_2".tr,
                            false,
                          ),
                        if (controller.order.value.orderStatus ==
                                AppConstants.refundSuccess ||
                            controller.order.value.refundStatus ==
                                AppConstants.approve)
                          _buildSuccess(
                            "accept_refund".tr,
                            "refund_success_description_3".tr,
                            true,
                          ),
                        FormRequestWidget(),
                        _buildImage(),
                        SizedBox(height: 12.h),
                      ],
                    ),
                  ),
                ),
                if (controller.isReadonly.value) buildButton(),
                if (controller.type.value == RequestRefundTabEnum.confirm)
                  buildButtonConfirm(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReject() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.warningColor10,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          Text(
            "Lý do từ chối".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.warningColor,
            ),
          ),
          Text(
            controller.order.value.reasonCancel,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(6.w),
                  decoration: BoxDecoration(
                    color: AppColors.warningColor10,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.phone_enabled_outlined,
                    size: 20.r,
                    color: AppColors.warningColor,
                  ),
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    "Vui lòng liên hệ qua Hotline: 1900.80200 khi có bất kì thắc mắc nào"
                        .tr,
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess(String title, String description, bool isShow) {
    return GestureDetector(
      onTap: () {
        if (isShow) {
          Get.toNamed(
            Routes.detailRefund,
            arguments: {'order': controller.order.value},
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: AppColors.primaryColor10,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 4.h,
          children: [
            Text(
              title,
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.successColor,
              ),
            ),
            Text(
              description,
              style: AppTextStyles.regular12().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            if (isShow)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor40,
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Row(
                  children: [
                    Text(
                      "Xem chi tiết hoàn tiền".tr,
                      style: AppTextStyles.semibold12().copyWith(
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12.r,
                        color: AppColors.primaryColor,
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

  Widget _buildImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text("attached_images".tr, style: AppTextStyles.semibold14()),
        Obx(() {
          return Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: [
              if (!controller.isReadonly.value &&
                  controller.listImages.isNotEmpty)
                ...controller.listImages.map(
                  (e) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.r),
                      color: AppColors.backgroundColor24,
                      border: Border.all(
                        color: AppColors.grayscaleColor10,
                        width: 0.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayscaleColor10,
                          blurRadius: 1.r,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: CachedImage(
                        url: e,
                        width: (Get.width - 48.w) / 2,
                        height: 118.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ...controller.pickedImages.map(
                (e) => Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.r),
                    color: AppColors.backgroundColor24,
                    border: Border.all(
                      color: AppColors.grayscaleColor10,
                      width: 0.5.w,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.grayscaleColor10,
                        blurRadius: 1.r,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12.r),
                    child: Stack(
                      children: [
                        Image.file(
                          File(e.path),
                          width: (Get.width - 48.w) / 2,
                          height: 118.h,
                          fit: BoxFit.cover,
                        ),
                        Positioned(
                          top: 4.w,
                          right: 4.w,
                          child: GestureDetector(
                            onTap: () {
                              controller.pickedImages.remove(e);
                            },
                            child: Container(
                              padding: EdgeInsets.all(4.w),
                              decoration: BoxDecoration(
                                color: AppColors.warningColor,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                Icons.close,
                                size: 16.w,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (controller.pickedImages.length < 4 &&
                  controller.isReadonly.value)
                PleaceHolderView(
                  onTap: () {
                    AppUtil().pickImages().then((value) {
                      if (value.path.isNotEmpty) {
                        controller.pickedImages.add(value);
                      }
                      controller.isValidate();
                    });
                  },
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget buildButton() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.only(top: 12.w),
        child: AppButton(
          title: "send_request".tr,
          onPressed: () {
            controller.createRequestRefund();
          },
          isEnable: controller.isDisable.value,
        ),
      ),
    );
  }

  Widget buildButtonConfirm() {
    return Padding(
      padding: EdgeInsets.only(top: 12.w),
      child: Row(
        spacing: 12.w,
        children: [
          Expanded(
            child: AppButton(
              title: "cancel".tr,
              onPressed: () {
                controller.updateRequestRefund(status: "rejected");
              },
              type: AppButtonType.remove,
            ),
          ),
          Expanded(
            child: AppButton(
              title: "confirm".tr,
              onPressed: () {
                controller.updateRequestRefund(status: "approved");
              },
            ),
          ),
        ],
      ),
    );
  }
}
