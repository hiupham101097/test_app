import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/evaluate/widget/build_rating.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'evaluate_detail_controller.dart';

class EvaluateDetailPage extends GetView<EvaluateDetailController> {
  const EvaluateDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "evaluate_review".tr,
      child: Obx(
        () => Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCard(),
                    SizedBox(height: 24.h),
                    if (controller.evaluationItem.value.feedBack.isNotEmpty)
                      _buildFeedback(),
                  ],
                ),
              ),
              AppButton(
                title:
                    controller.evaluationItem.value.feedBack.isEmpty
                        ? "send_feedback".tr
                        : "update_feedback".tr,
                onPressed: () {
                  controller.showBottomSheetFeedback();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCard() {
    print(
      "controller.evaluationItem.value.imageUrlMap: ${controller.evaluationItem.value.imageUrlMap}",
    );
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundColor24,
          borderRadius: BorderRadius.circular(8.w),
          border: Border.all(color: AppColors.grayscaleColor20, width: 0.3.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.grayscaleColor20,
              blurRadius: 1,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(360.r),
              child: CachedImage(
                url: controller.evaluationItem.value.imageUrlMap,
                width: 52.w,
                height: 52.w,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                spacing: 4.h,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.evaluationItem.value.fullName != ''
                        ? controller.evaluationItem.value.fullName
                        : 'N/A',
                    style: AppTextStyles.semibold12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    DateUtil.formatDate(
                      DateTime.tryParse(
                            controller.evaluationItem.value.createDate,
                          ) ??
                          DateTime.now(),
                      format: 'HH:mm dd/MM/yyyy',
                    ),
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor50,
                    ),
                  ),
                  BuildRating(
                    rating: controller.evaluationItem.value.rating.toDouble(),
                  ),
                  Text(controller.evaluationItem.value.content),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFeedback() {
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "feedback_from_seller".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor12,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              controller.evaluationItem.value.feedBack,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
