import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'detail_refund_controller.dart';

class DetailRefundPage extends GetView<DetailRefundController> {
  const DetailRefundPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "refund_detail".tr,
      child: Obx(
        () => Column(
          children: [
            SizedBox(height: 12.h),
            Text("refund_amount".tr, style: AppTextStyles.semibold14()),
            SizedBox(height: 4.h),
            Text(
              AppUtil.formatMoney(controller.order.value.totalOrderPrice),
              style: AppTextStyles.medium20().copyWith(
                color: AppColors.primaryColor60,
                fontSize: 26.sp,
              ),
            ),
            _buildStepStatus(),
            Divider(
              color: AppColors.grayscaleColor30,
              height: 16.h,
              thickness: 0.3.h,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Text(
                "Yêu cầu hoàn tiền của bạn đã được chúng tôi xử lý. Với đơn hoàn tiền về Thẻ tín dụng/ Ví điện tử, sẽ cần thêm 7 - 14 ngày để ngân hàng cập nhật tiền hoàn. Bạn có thể liên hệ ngân hàng để kiểm tra ngày cập nhật cụ thể",
                style: AppTextStyles.regular12(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildStepStatus() {
    int currentStep = 0;
    if (controller.approveDate.value.isNotEmpty) {
      currentStep = 1;
    }
    if (controller.successDate.value.isNotEmpty) {
      currentStep = 2;
    }

    Color _borderColorFor(int index) {
      return index <= currentStep
          ? AppColors.successColor
          : AppColors.grayscaleColor30;
    }

    Widget _checkBadge(bool show) {
      if (!show) return const SizedBox.shrink();
      return Positioned(
        right: 0,
        bottom: 0,
        child: Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.successColor, width: 1.5),
          ),
          child: Icon(Icons.check, size: 12.sp, color: AppColors.successColor),
        ),
      );
    }

    Widget _step(int index, Widget inner) {
      return Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 60.w,
            height: 60.w,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: _borderColorFor(index), width: 3),
            ),
            alignment: Alignment.center,
            child: inner,
          ),
          _checkBadge(index <= currentStep),
        ],
      );
    }

    Widget _connector(bool active) {
      return Expanded(
        child: Container(
          height: 3.h,
          color: active ? AppColors.successColor : AppColors.grayscaleColor30,
        ),
      );
    }

    Widget _bankIcon(String icon) {
      return Image.asset(icon, width: 32.r, height: 32.r, fit: BoxFit.cover);
    }

    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _step(0, _bankIcon(AssetConstants.logoGober)),
                  SizedBox(width: 8.w),
                  _connector(controller.approveDate.value.isNotEmpty),
                  SizedBox(width: 8.w),
                  _step(1, _bankIcon(AssetConstants.icBank)),
                  SizedBox(width: 8.w),
                  _connector(controller.successDate.value.isNotEmpty),
                  SizedBox(width: 8.w),
                  _step(2, _bankIcon(AssetConstants.icWalletBank)),
                ],
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.w,
              children: [
                _buildItemStatus("Chấp nhận hoàn tiền"),
                _buildItemStatus("Đang hoàn tiền"),
                _buildItemStatus("Đã hoàn tiền"),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 12.w,
              children: [
                _buildItemDate(0, false, controller.approveDate.value),
                _buildItemDate(
                  1,
                  controller.successDate.value.isEmpty,
                  controller.processRefund.value,
                ),
                _buildItemDate(
                  2,
                  controller.successDate.value.isNotEmpty,
                  controller.successDate.value,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildItemStatus(String title) {
    return Expanded(
      child: Text(
        title,
        style: AppTextStyles.regular12(),
        textAlign: TextAlign.center,
      ),
    );
  }

  _buildItemDate(int index, bool isActive, String date) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
        decoration: BoxDecoration(
          color: isActive ? AppColors.successColor : null,
          borderRadius: BorderRadius.circular(12.r),
        ),
        child: Text(
          DateUtil.formatDate(DateTime.tryParse(date), format: 'dd/MM/yyyy'),
          style: AppTextStyles.regular10().copyWith(
            color: isActive ? Colors.white : AppColors.grayscaleColor60,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
