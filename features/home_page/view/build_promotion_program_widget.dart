import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/features/home_page/home_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/home_page/view/voucher_item_widget.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BuildPromotionProgramWidget extends GetView<HomeController> {
  const BuildPromotionProgramWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'promotion_program'.tr,
                    style: AppTextStyles.semibold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(Routes.listVoucher);
                    },
                    child: Icon(
                      Icons.arrow_forward_ios,
                      size: 14.sp,
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ],
              ),
              Obx(
                () => Text(
                  'you_are_participating_in'.tr +
                      " ${controller.totalUseMotion.value} " +
                      'promotion_programs'.tr,
                  style: AppTextStyles.regular10().copyWith(
                    color: AppColors.grayscaleColor80,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10.h),
        Obx(
          () =>
              controller.listVoucher.length < 1
                  ? CustomEmpty(title: "no_data".tr)
                  : SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    clipBehavior: Clip.none,
                    child: Row(
                      children: [
                        ...List.generate(
                          controller.listVoucher.length,
                          (index) => GestureDetector(
                            onTap: () {
                              Get.toNamed(Routes.voucherDetail);
                            },
                            child: Container(
                              width:
                                  controller.listVoucher.length > 1
                                      ? 291.w
                                      : Get.width - 24.w,
                              margin: EdgeInsets.only(
                                left: 12.w,
                                right:
                                    index == controller.listVoucher.length - 1
                                        ? 12.w
                                        : 0,
                              ),
                              child: VoucherItemWidget(
                                promotion: controller.listVoucher[index],
                                isJoin: false,
                                onJoin: () {
                                  Get.toNamed(
                                    Routes.voucherDetail,
                                    arguments: {
                                      'idVoucher':
                                          controller.listVoucher[index].id,
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
        ),
      ],
    );
  }
}
