import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'deposit_information_controller.dart';

class DepositInformationPage extends GetView<DepositInformationController> {
  const DepositInformationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.grayscaleColor5,
      appBar: CustomAppBar(title: 'THÔNG TIN CHUYỂN KHOẢN'.tr),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Text(
                'Quét mã QR để nạp tiền vào tài khoản của bạn. Số dư sẽ được cộng ngay sau khi giao dịch thành công.'
                    .tr,
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              SizedBox(height: 12.h),
              _buildBody(),
              SizedBox(height: 16.h),
              _buildButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.grayscaleColor20,
            blurRadius: 4.r,
            offset: Offset(0, 4.r),
          ),
        ],
      ),
      child: Column(
        children: [
          QrImageView(
            data: controller.transactionData.value.paymentUrl ?? '',
            size: 180.h,
          ),
          SizedBox(height: 24.h),
          AppButton(
            title: 'TẢI XUỐNG'.tr,
            icon: AssetConstants.icDownload,
            onPressed: () {
              controller.saveQrToGallery(
                controller.transactionData.value.paymentUrl ?? '',
              );
            },
            type: AppButtonType.primary,
          ),
          SizedBox(height: 16.h),
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.primaryColor5,
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primaryColor),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.transactionData.value.transactionId != null)
                  _buildItemInfo(
                    'Mã giao dịch'.tr,
                    controller.transactionData.value.transactionId ?? '',
                  ),
                if (controller.transactionData.value.bankData?.bankName != null)
                  _buildItemInfo(
                    'Ngân hàng'.tr,
                    controller.transactionData.value.bankData?.bankName ?? '',
                  ),
                if (controller.transactionData.value.bankData?.bankAccount !=
                    null)
                  _buildItemInfo(
                    'Chủ tài khoản'.tr,
                    controller.transactionData.value.bankData?.bankAccount ??
                        '',
                  ),
                if (controller.transactionData.value.bankData?.bankNumber !=
                    null)
                  _buildItemInfo(
                    'Số tài khoản'.tr,
                    controller.transactionData.value.bankData?.bankNumber ?? '',
                    showIcon: true,
                    onTap: () {
                      controller.copyBankNumber();
                    },
                  ),
                if (controller.transactionData.value.bankData?.bankNumber !=
                    null)
                  _buildItemInfo(
                    'Nội dung chuyển khoản'.tr,
                    'Nạp tiền vào ví XXXXXX${controller.walletId.value.toString().substring(controller.walletId.value.toString().length - 7)}',
                  ),
                if (controller.transactionData.value.totalPrice != null)
                  _buildItemInfo(
                    'Số tiền'.tr,
                    AppUtil.formatMoney(
                      double.tryParse(
                            controller.transactionData.value.totalPrice
                                .toString(),
                          ) ??
                          0,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo(
    String title,
    String value, {
    Function()? onTap,
    bool showIcon = false,
  }) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.regular14()),
                Text(
                  value,
                  style: AppTextStyles.medium14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ],
            ),
          ),
          if (showIcon) ...[
            GestureDetector(
              onTap: onTap,
              child: Container(
                padding: EdgeInsets.all(4.r),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4.r),
                  border: Border.all(color: AppColors.primaryColor),
                ),
                child: Icon(
                  Icons.copy,
                  size: 16.r,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Column(
      children: [
        // AppButton(
        //   title: 'TEST NẠP TIỀN Thành Công'.tr,
        //   onPressed: () {
        //     controller.testComplete();
        //   },
        //   type: AppButtonType.nomal,
        // ),
        // SizedBox(height: 16.h),
        AppButton(
          title: 'QUAY LẠI'.tr,
          onPressed: () {
            Get.back();
          },
          type: AppButtonType.nomal,
        ),
        SizedBox(height: 16.h),
        AppButton(
          title: 'HOÀN THÀNH'.tr,
          onPressed: () {
            Get.back();
          },
          type: AppButtonType.outline,
        ),
      ],
    );
  }
}
