import 'package:carousel_slider/carousel_slider.dart';
import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/features/oder_detail/oder_detail_controller.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

class ListProductWidget extends GetView<OrderDetailController> {
  const ListProductWidget({super.key});

  @override
  Widget build(BuildContext context) {
    late double height;
    final oderDetail = controller.oderDetail.value;
    late bool ishowDone = oderDetail.orderStatus.toUpperCase() == "PREPARING";

    int maxLengthOptionFoods = 0;
    if (oderDetail.productList.isNotEmpty) {
      final productsWithOptions =
          oderDetail.productList
              .where((e) => e.productOptionFoods.isNotEmpty)
              .toList();

      if (productsWithOptions.isNotEmpty) {
        maxLengthOptionFoods = productsWithOptions
            .map((e) => e.productOptionFoods.length)
            .reduce((a, b) => a > b ? a : b);
      }
    }

    double baseHeight = 50.h;
    if (ishowDone) {
      baseHeight += 36.h;
    }

    double optionFoodsHeight =
        maxLengthOptionFoods > 0 ? (maxLengthOptionFoods * 29.h) + 24.h : 0;

    height = baseHeight + optionFoodsHeight;

    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              "order_has_product".trArgs([oderDetail.totalOrder.toString()]),
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ),
          SizedBox(height: 12.h),
          CarouselSlider(
            carouselController: controller.carouselController,
            items: List.generate(
              oderDetail.productList.length,
              (i) => _buildItemSummary(
                oderProductItem: oderDetail.productList[i],
                ishowDone: ishowDone,
              ),
            ),
            options: CarouselOptions(
              onPageChanged: (index, reason) {
                controller.currentPage.value = index;
              },
              height: height,
              enableInfiniteScroll: false,
              viewportFraction: 1,
            ),
          ),
          SizedBox(height: 12),
          if (oderDetail.productList.length > 1)
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(oderDetail.productList.length, (i) {
                  final isActive = i == controller.currentPage.value;
                  return AnimatedContainer(
                    duration: Duration(milliseconds: 100),
                    margin: EdgeInsets.symmetric(horizontal: 4.w),
                    width: isActive ? 20.w : 6.w,
                    height: 6.h,
                    decoration: BoxDecoration(
                      color:
                          isActive
                              ? AppColors.primaryColor60
                              : AppColors.grayscaleColor10,
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  );
                }),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildItemSummary({
    OderProductItemModel? oderProductItem,
    bool? ishowDone,
  }) {
    return Obx(
      () => Container(
        width: Get.width - 24.w,
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color:
              oderProductItem?.isDone.value == true
                  ? AppColors.primaryColor5
                  : Colors.white,
          border: Border.all(
            color:
                oderProductItem?.isDone.value == true
                    ? AppColors.primaryColor80
                    : AppColors.grayscaleColor10,
            width: 0.5.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    alignment: Alignment.center,
                    height: 24.h,
                    child: Row(
                      children: [
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Flexible(
                                child: Text(
                                  oderProductItem?.name ?? '',
                                  style: AppTextStyles.medium14().copyWith(
                                    color: AppColors.grayscaleColor80,
                                  ),
                                ),
                              ),
                              SizedBox(width: 4.w),
                              (oderProductItem?.quantity ?? 0) > 1
                                  ? Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 4,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'x${oderProductItem?.quantity ?? 0}',
                                      style: AppTextStyles.medium10().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  )
                                  : SizedBox.shrink(),
                            ],
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Text(
                          AppUtil.formatMoney(
                            oderProductItem?.priceSale ??
                                oderProductItem?.price ??
                                0,
                          ),

                          style: AppTextStyles.medium12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (oderProductItem?.productOptionFoods.isNotEmpty ==
                      true) ...[
                    Container(
                      alignment: Alignment.centerLeft,
                      height: 20.h,
                      child: Text(
                        "Món mua kèm:",
                        style: AppTextStyles.medium12().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                    ),
                    ...List.generate(
                      oderProductItem?.productOptionFoods.length ?? 0,
                      (index) => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildItemInfo(
                            title:
                                oderProductItem
                                    ?.productOptionFoods[index]
                                    .name ??
                                '',
                            value: AppUtil.formatMoney(
                              oderProductItem
                                      ?.productOptionFoods[index]
                                      .priceSale
                                      .toDouble() ??
                                  oderProductItem
                                      ?.productOptionFoods[index]
                                      .price
                                      .toDouble() ??
                                  0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (oderProductItem?.isDone.value == false &&
                ishowDone == true &&
                controller.oderDetail.value.statusDriver == "PENDING") ...[
              GestureDetector(
                onTap: () {
                  oderProductItem?.isDone.value = true;
                },
                child: Center(
                  child: Container(
                    width: 94.w,
                    height: 32.h,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor80,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(360),
                    ),
                    child: Center(
                      child: Text(
                        "complete".tr,
                        style: AppTextStyles.semibold10().copyWith(
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItemInfo({String? title, String? value}) {
    return Container(
      height: 28.h,
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "· ${title}:",
              style: AppTextStyles.medium12().copyWith(
                color: AppColors.grayscaleColor60,
              ),
            ),
          ),
          Text(
            value ?? "",
            style: AppTextStyles.medium12().copyWith(
              color: AppColors.grayscaleColor60,
            ),
          ),
        ],
      ),
    );
  }
}
