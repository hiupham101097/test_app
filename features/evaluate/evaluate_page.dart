import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/evaluation_item_model.dart';
import 'package:merchant/features/evaluate/widget/build_rating.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'evaluate_controller.dart';

class EvaluatePage extends GetView<EvaluateController> {
  const EvaluatePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(title: "evaluate_review".tr, child: _buildContent());
  }

  _buildContent() {
    return Obx(() {
      final listOrder = controller.listDataEvaluate;
      final meta = controller.total.value;
      return CustomEasyRefresh(
        controller: controller.controller,
        onRefresh: controller.onRefresh,
        infoText: '${'now'.tr}: ${listOrder.length}/ ${meta}',
        onLoading: controller.onLoadingPage,
        delegate: SliverChildBuilderDelegate(
          (context, index) => Padding(
            padding: EdgeInsets.only(bottom: index == 9 ? 0 : 16.h),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCard(),
                  SizedBox(height: 24.h),
                  _buildListEvaluate(),
                ],
              ),
            ),
          ),
          childCount: 1,
        ),
      );
    });
  }

  _buildCard() {
    return Obx(
      () => Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.primaryColor5,
          borderRadius: BorderRadius.circular(8.w),

          border: Border.all(color: AppColors.primaryColor80, width: 0.3.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 7.w),
              child: Row(
                children: [
                  Column(
                    children: [
                      Text(
                        controller.evaluateOverview.value.averageRating
                            .toString(),
                        style: AppTextStyles.semibold16().copyWith(
                          color: AppColors.grayscaleColor80,
                          fontSize: 48.sp,
                        ),
                      ),
                      BuildRating(
                        rating: controller.evaluateOverview.value.averageRating,
                      ),
                      SizedBox(height: 8.h),
                      Text(
                        "${controller.evaluateOverview.value.totalRatingCount} đánh giá",
                        style: AppTextStyles.regular10().copyWith(
                          color: AppColors.infomationColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 24.w),
                  Expanded(
                    child: Column(
                      children: List.generate(
                        5,
                        (index) => _buildItem(
                          title: "${index + 1}",
                          value:
                              controller
                                  .evaluateOverview
                                  .value
                                  .ratingDistribution
                                  ?.getRatingCount(index + 1)
                                  .toString() ??
                              '0',
                          percentage:
                              controller
                                  .evaluateOverview
                                  .value
                                  .ratingDistribution
                                  ?.getPercentage(index + 1) ??
                              0,
                        ),
                      ),
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

  _buildItem({
    required String title,
    required String? value,
    required double percentage,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Row(
        children: [
          Text(
            title,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Icon(Icons.star, size: 14.sp, color: AppColors.attentionColor),
          SizedBox(width: 4.w),
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.grayscaleColor10,
                    borderRadius: BorderRadius.circular(100.r),
                  ),
                  width: double.infinity,
                  height: 4.h,
                ),
                FractionallySizedBox(
                  widthFactor: percentage / 100,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.attentionColor,
                      borderRadius: BorderRadius.circular(100.r),
                    ),
                    height: 4.h,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            value ?? '0',
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }

  _buildListEvaluate() {
    return Obx(() {
      final data = controller.listDataEvaluate;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  "evaluate_from_customer".tr,
                  style: AppTextStyles.semibold14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.showProductBottomsheet();
                },
                child: Container(
                  padding: EdgeInsets.all(4.r),
                  decoration: BoxDecoration(
                    color: AppColors.successColor,
                    borderRadius: BorderRadius.circular(8.r),
                    border: Border.all(
                      color: AppColors.grayscaleColor80,
                      width: 0.5.r,
                    ),
                  ),
                  child: Row(
                    children: [
                      CachedImage(
                        url: AssetConstants.icFilter,
                        width: 16.w,
                        height: 16.w,
                        color: Colors.white,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        "filter".tr,
                        style: AppTextStyles.semibold14().copyWith(
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          if (data.isNotEmpty)
            ...List.generate(
              data.length,
              (index) => Padding(
                padding: EdgeInsets.only(bottom: index == -1 ? 0 : 12.h),
                child: _buildItemEvaluate(evaluationItem: data[index]),
              ),
            )
          else
            Center(
              child: CustomEmpty(
                title: "no_evaluate".tr,
                image: AssetConstants.icEmptyImage,
                width: 60.r,
                height: 60.r,
              ),
            ),
        ],
      );
    });
  }

  _buildItemEvaluate({required EvaluationItemModel evaluationItem}) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.evaluateDetail,
          arguments: {'evaluationItem': evaluationItem},
        );
      },
      child: Container(
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
                url: evaluationItem.imageUrlMap,
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
                    evaluationItem.fullName != ''
                        ? evaluationItem.fullName
                        : 'N/A',
                    style: AppTextStyles.semibold12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    DateUtil.formatDate(
                      DateTime.tryParse(evaluationItem.createDate) ??
                          DateTime.now(),
                      format: 'HH:mm dd/MM/yyyy',
                    ),
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor50,
                    ),
                  ),
                  BuildRating(rating: evaluationItem.rating.toDouble()),
                  Text(evaluationItem.content),
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4.r),
                        child: CachedImage(
                          url: evaluationItem.product?.imageUrlMap ?? '',
                          width: 52.w,
                          height: 52.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              evaluationItem.product?.name ?? '',
                              style: AppTextStyles.medium12().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            if (evaluationItem
                                    .product
                                    ?.productOptionFood
                                    .isNotEmpty ??
                                false)
                              Row(
                                children: [
                                  CachedImage(
                                    url: AssetConstants.icOption,
                                    width: 12.w,
                                    height: 12.w,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    'and_product_option_food'.trArgs([
                                      (evaluationItem
                                                  .product
                                                  ?.productOptionFood
                                                  .length ??
                                              0)
                                          .toString(),
                                    ]),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  evaluationItem.feedBack.isNotEmpty
                      ? _buildFeedbackStore(evaluationItem: evaluationItem)
                      : Container(
                        decoration: BoxDecoration(
                          color: AppColors.grayscaleColor5,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(color: AppColors.grayscaleColor20),
                        ),
                        width: 81.w,
                        alignment: Alignment.center,
                        padding: EdgeInsets.symmetric(vertical: 4.h),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          spacing: 4.w,
                          children: [
                            Image.asset(
                              AssetConstants.icChat,
                              width: 16.w,
                              height: 16.w,
                            ),
                            Text(
                              "feedback".tr,
                              style: AppTextStyles.semibold10().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                          ],
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

  _buildFeedbackStore({required EvaluationItemModel evaluationItem}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundColor12,
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 4.h,
        children: [
          Text(
            "feedback_from_seller".tr,
            style: AppTextStyles.medium12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          // Text(
          //   "14:41 01/01/2024",
          //   style: AppTextStyles.regular12().copyWith(
          //     color: AppColors.grayscaleColor50,
          //   ),
          // ),
          Text(
            evaluationItem.feedBack,
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }
}
