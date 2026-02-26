import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/wallet/detail_transaction/detail_transaction_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailTransactionPage extends GetView<DetailTransactionController> {
  const DetailTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'LỊCH SỬ GIAO DỊCH'.tr,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(children: [_buildBody(), Spacer()]),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
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
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12.r)),
            ),
            child: Text(
              'CHI TIẾT GIAO DỊCH',
              style: AppTextStyles.bold14().copyWith(color: Colors.white),
            ),
          ),
          if (controller.detailTransactionDiscount.value.orderId != null)
            _buildItemInfo(
              'Mã đơn hàng'.tr,
              controller.detailTransactionDiscount.value.orderId ?? "",
            ),

          if (controller.detailTransactionIn.value.refcode != null ||
              controller.detailTransactionDiscount.value.transactionId != null)
            _buildItemInfo(
              'Mã giao dịch'.tr,
              controller.detailTransactionIn.value.refcode ??
                  controller.detailTransactionDiscount.value.transactionId ??
                  '',
            ),

          _buildItemInfo(
            'Số tiền '.tr,
            AppUtil.formatMoney(
              controller.detailTransactionIn.value.amount?.toDouble().abs() ??
                  controller.detailTransactionDiscount.value.amount
                      ?.toDouble()
                      .abs() ??
                  0,
            ),
          ),

          _buildItemInfo(
            'Thời gian'.tr,
            DateUtil.formatDate(
              controller.detailTransactionIn.value.createdAt ??
                  controller.detailTransactionDiscount.value.createDate ??
                  DateTime.now(),
              format: 'HH:mm, dd/MM/yyyy',
            ),
          ),
          if (controller.detailTransactionIn.value.bankAccount != null)
            _buildItemInfo(
              'Chủ tài khoản'.tr,
              controller.detailTransactionIn.value.bankAccount ?? "",
            ),
          if (controller.detailTransactionIn.value.bankNumber != null)
            _buildItemInfo(
              'Số tài khoản'.tr,
              controller.detailTransactionIn.value.bankNumber ?? "",
            ),

          _buildItemInfo('Loại giao dịch'.tr, controller.getTitleTransaction()),
          _buildItemInfo('Phí giao dịch'.tr, 'Miễn phí'.tr),
          _buildItemInfo(
            'Trạng thái'.tr,
            controller.getStatusTransaction(
              controller.detailTransactionIn.value.status ??
                  controller.detailTransactionDiscount.value.status ??
                  '',
            ),
            color: controller.getColorStatusTransaction(
              controller.detailTransactionIn.value.status ??
                  controller.detailTransactionDiscount.value.status ??
                  '',
            ),
          ),
          Divider(
            color: AppColors.grayscaleColor20,
            height: 8.h,
            thickness: 0.3.r,
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    'total_amount'.tr,
                    style: AppTextStyles.semibold14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
                Expanded(
                  child: Text(
                    AppUtil.formatMoney(
                      controller.detailTransactionIn.value.amount
                              ?.toDouble()
                              .abs() ??
                          controller.detailTransactionDiscount.value.amount
                              ?.toDouble()
                              .abs() ??
                          0,
                    ),
                    style: AppTextStyles.medium14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo(String title, String value, {Color? color}) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: AppTextStyles.regular14(),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              style: AppTextStyles.medium14().copyWith(
                color: color ?? AppColors.grayscaleColor70,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
