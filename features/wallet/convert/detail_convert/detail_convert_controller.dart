import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class DetailConvertController extends GetxController {
  final ApiClient client = ApiClient();

  @override
  void onInit() {
    super.onInit();
  }

  void onConfirm() {
    DialogUtil.showDialogLoading(
      Get.context!,
      title: 'ABC1234AA',
      description:
          'Giao Hệ thống đang kiểm tra giao dịch của bạn. \nViệc này thường mất vài phút. \nBạn không cần thao tác gì thêm.',
    );
    Future.delayed(const Duration(seconds: 2), () {
      Get.back();
      diaLogSuccess();
      Future.delayed(const Duration(seconds: 2), () {
        Get.back();
        diaLogError();
      });
    });
  }

  void diaLogError() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icWarning,
        width: 68.w,
        height: 68.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'confirm_failed'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "system_not_confirm_transaction".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'retry'.tr,
      titleRight: 'skip'.tr,
      typeButtonLeft: AppButtonType.remove,
      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        Get.back();
      },
    );
  }

  void diaLogSuccess() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icDisposeSuccess,
        width: 275.w,
        height: 161.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'topup_success'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.successColor),
        textAlign: TextAlign.center,
      ),
      description: Text.rich(
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            TextSpan(
              text: "you_deposited".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: " ${"amount_placeholder".tr} ",
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: "into_driver_wallet_space".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: "\n${"current_balance_space".tr}",
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: " ${"amount_placeholder_large".tr} ",
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ],
        ),
      ),
      titleLeft: 'back_to_home'.tr,
      titleRight: 'top_up_more'.tr,
      actionLeft: () {
        Get.offAllNamed(Routes.root);
      },
      actionRight: () {
        Get.back();
      },
    );
  }
}
