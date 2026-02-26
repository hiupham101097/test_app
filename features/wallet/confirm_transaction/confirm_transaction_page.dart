import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/features/wallet/confirm_transaction/confirm_transaction_controller.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ConfirmTransactionPage extends GetView<ConfirmTransactionController> {
  const ConfirmTransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: 'detail_transaction'.tr,
      child: Container(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildBody(),
            Spacer(),
            buildFeeTransfer(),
            SizedBox(height: 12.h),
            AppButton(
              title: 'confirm'.tr,
              onPressed: () {
                final amountSetting = sl<LocalClient>().amountSetting;
                final amount =
                    int.tryParse(
                      controller.amount.value?.replaceAll(",", "") ?? '0',
                    ) ??
                    0;
                final wallet = controller.walletUser.value.wallet!;
                if (controller.selectedWithDrawType.value ==
                        MyWalletType.discountWallet &&
                    (wallet - amount) < int.parse(amountSetting)) {
                  controller.diaLogErrorWalletNotEnough();
                  return;
                } else {
                  controller.actionWithdrawBottomSheet();
                  return;
                }
              },
            ),
          ],
        ),
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
          _buildItemInfo(
            'amount'.tr,
            AppUtil.formatMoney(
              double.tryParse(
                    controller.amount.value?.replaceAll(",", "") ?? '0',
                  ) ??
                  0,
            ),
          ),
          _buildItemInfo(
            'Thơi gian '.tr,
            DateUtil.formatDate(
              DateTime.now().toLocal(),
              format: 'HH:mm dd/MM/yyyy',
            ),
          ),

          _buildItemInfo('method'.tr, 'Chuyến khoản'.tr),
          _buildItemInfo(
            'Rút tiền về tài khoản'.tr,

            controller.selectedBank.value.bankName ?? '',
          ),
          _buildItemInfo('fee_transfer'.tr, '3,000đ'.tr),
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
                      double.tryParse(
                            controller.amount.value?.replaceAll(",", "") ?? '0',
                          ) ??
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

  Widget buildFeeTransfer() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryColor10,
        boxShadow: [
          BoxShadow(
            color: AppColors.grayscaleColor40,
            blurRadius: 1.r,
            offset: Offset(0, 1.r),
          ),
        ],
        border: Border.all(color: AppColors.grayscaleColor40, width: 0.5.r),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_rounded,
            color: AppColors.warningColor,
            size: 24.w,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text:
                        'Phí chuyển tiền từ ví Merchant ra tài khoản ngân hàng áp dụng là ',
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  TextSpan(
                    text: '3.000 đồng/giao dịch',
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.warningColor,
                    ),
                  ),
                  TextSpan(
                    text: ' .Tối đa cho 1 giao dịch là: ',
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  TextSpan(
                    text: '299.000.000 đồng',
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.infomationColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 16.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                color: AppColors.grayscaleColor70,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
