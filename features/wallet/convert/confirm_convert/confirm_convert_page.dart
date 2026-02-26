import 'dart:ffi';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'confirm_convert_controller.dart';

class ConfirmConvertPage extends GetView<ConfirmConvertController> {
  const ConfirmConvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(title: 'XÁC NHẬN CHUYỂN ĐỔI'.tr, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 28.h, horizontal: 12.w),
        child: Column(
          children: [
            if (controller.isSuccess.value) ...[
              Image.asset(AssetConstants.icSuccess, width: 64.w, height: 69.h),
              SizedBox(height: 8.h),
              Text(
                'Chuyển đổi thành công',
                style: AppTextStyles.semibold14().copyWith(
                  color: AppColors.primaryColor,
                ),
              ),
              SizedBox(height: 20.h),
            ],

            Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundColor24,
                border: Border.all(color: AppColors.primaryColor),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                children: [
                  Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      vertical: 12.h,
                      horizontal: 16.w,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      'THÔNG TIN CHUYỂN ĐỔI',
                      style: AppTextStyles.bold14().copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  !controller.isSuccess.value
                      ? buidHeader()
                      : buidHeaderSuccess(),
                  Divider(
                    color: AppColors.grayscaleColor30,
                    height: 24.h,
                    thickness: 0.5.r,
                  ),
                  _buildInfoTrip(),
                ],
              ),
            ),
            Spacer(),
            AppButton(
              type:
                  controller.isSuccess.value
                      ? AppButtonType.nomal
                      : AppButtonType.outline,
              title:
                  controller.isSuccess.value
                      ? 'về ví của tôi'.tr
                      : 'confirm'.tr,
              onPressed: () {
                if (controller.isSuccess.value) {
                  Get.back();
                  Get.back();
                  Get.back();
                } else {
                  controller.confirmConvert();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTrip() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        children: [
          _buildItemInfo(
            'Hình thức',
            'Chuyển đổi từ Ví tiền vào sang Ví chiết khấu',
          ),
          _buildItemInfo(
            'Tiền gốc chuyển đổi',
            AppUtil.formatMoney(
              double.tryParse(controller.amount.value ?? '0') ?? 0,
            ),
          ),

          _buildItemInfo('Phí giao dịch', 'Miễn phí'),
          _buildItemInfo(
            'Tổng tiền chuyển đổi',
            AppUtil.formatMoney(
              double.tryParse(controller.amount.value ?? '0') ?? 0,
            ),
          ),
          Divider(
            color: AppColors.grayscaleColor20,
            height: 1.h,
            thickness: 0.3.r,
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.regular14(),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.medium14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget buidHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        children: [
          Image.asset(AssetConstants.icMoneyBalance, width: 56.w, height: 76.h),
          SizedBox(height: 8.h),
          Text(
            'Nạp tiền vào Ví chiết khấu',
            style: AppTextStyles.regular14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Text(
            AppUtil.formatMoney(
              double.tryParse(controller.amount.value ?? '0') ?? 0,
            ),
            style: AppTextStyles.medium16().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }

  Widget buidHeaderSuccess() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        children: [
          Text(
            'Chuyển đổi thành công',
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Text(
            DateUtil.formatDate(
              DateTime.tryParse(DateTime.now().toLocal().toString()) ??
                  DateTime.now(),
              format: 'dd/MM/yyyy HH:mm ',
            ),
            style: AppTextStyles.regular10().copyWith(
              color: AppColors.grayscaleColor60,
            ),
          ),
          Text(
            AppUtil.formatMoney(
              double.tryParse(controller.amount.value ?? '0') ?? 0,
            ),
            style: AppTextStyles.medium16().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }
}
