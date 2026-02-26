import 'dart:ffi';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'convert_controller.dart';

class ConvertPage extends GetView<ConvertController> {
  const ConvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title: 'convert'.tr,
        child: _buildBody(),
        // child: Container(),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'source_money_convert'.tr,
                        style: AppTextStyles.semibold16().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildWallet(
                        title: 'Ví tiền vào'.tr,
                        balance:
                            double.tryParse(
                              controller.walletModel.value.withdrawableBalance
                                      ?.toString() ??
                                  '0',
                            ) ??
                            0,
                        image: AssetConstants.icMoneyCash,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'convert_to'.tr,
                        style: AppTextStyles.semibold16().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      _buildWallet(
                        title: 'Ví chiết khấu'.tr,
                        balance:
                            double.tryParse(
                              controller.walletUser.value.wallet?.toString() ??
                                  '0',
                            ) ??
                            0,
                        image: AssetConstants.icMoneyBalance,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'enter_money_convert'.tr,
                        style: AppTextStyles.semibold16().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          if (controller
                                      .walletModel
                                      .value
                                      .withdrawableBalance !=
                                  null &&
                              controller
                                      .walletModel
                                      .value
                                      .withdrawableBalance! >
                                  50000) {
                            FocusScope.of(Get.context!).unfocus();
                            controller.formKey.currentState?.reset();
                            controller.selectedRadio.value = 0;
                          }
                        },
                        child: _buildRadioButton(
                          'convert_partial'.tr,
                          controller.moneyEditingController,
                          controller.moneyFocusNode,
                          'plehoder_minimum_balance'.tr,
                          controller.selectedRadio.value == 0,
                          readOnly:
                              controller.selectedRadio.value == 0
                                  ? false
                                  : true,
                          validate:
                              (value) => Validator.validateTripConvert(
                                value?.replaceAll(",", "") ?? '',
                                controller.walletModel.value.withdrawableBalance
                                        .toString() ??
                                    '0',
                              ),
                        ),
                      ),
                      SizedBox(height: 16.h),
                      GestureDetector(
                        onTap: () {
                          if (controller
                                      .walletModel
                                      .value
                                      .withdrawableBalance !=
                                  null &&
                              controller
                                      .walletModel
                                      .value
                                      .withdrawableBalance! >
                                  50000) {
                            FocusScope.of(Get.context!).unfocus();
                            controller.formKey.currentState?.reset();
                            controller.selectedRadio.value = 1;
                            controller
                                .allMoneyEditingController
                                .text = AppUtil.formatMoney(
                              controller
                                      .walletModel
                                      .value
                                      .withdrawableBalance ??
                                  0,
                            );
                          }
                        },
                        child: _buildRadioButton(
                          'convert_all'.tr,
                          controller.allMoneyEditingController,
                          controller.allMoneyFocusNode,
                          'plehoder_minimum_balance'.tr,
                          controller.selectedRadio.value == 1,
                          readOnly: true,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              AppButton(
                title: 'continue_text'.tr,
                isEnable: controller.selectedRadio.value < 2,
                onPressed: () {
                  FocusScope.of(Get.context!).unfocus();
                  if (controller.selectedRadio.value == 0) {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.onAction();
                    }
                  } else {
                    controller.onAction();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRadioButton(
    String title,
    TextEditingController controller,
    FocusNode focusNode,
    String hintText,
    bool isSelected, {
    bool readOnly = false,
    FormFieldValidator<String>? validate,
  }) {
    return GestureDetector(
      child: Container(
        padding: EdgeInsets.all(8.r),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryColor5 : null,
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : AppColors.grayscaleColor20,
          ),
          borderRadius: BorderRadius.circular(4.r),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.regular12()),
                  TextFormField(
                    style: AppTextStyles.regular16(),
                    focusNode: focusNode,
                    controller: controller,
                    readOnly: readOnly,
                    enableInteractiveSelection: !readOnly,
                    showCursor: !readOnly,
                    validator: validate,
                    keyboardType: TextInputType.number,
                    inputFormatters: [ThousandsFormatter()],
                    decoration: InputDecoration(
                      errorStyle: AppTextStyles.regular12().copyWith(
                        color: AppColors.warningColor,
                      ),
                      hintText: hintText,
                      hintStyle: AppTextStyles.regular16(),
                      border: InputBorder.none,
                    ),
                    onTap: readOnly ? null : () {},
                  ),
                ],
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked_outlined
                  : Icons.radio_button_off_outlined,
              size: 16.r,
              color:
                  isSelected
                      ? AppColors.primaryColor
                      : AppColors.grayscaleColor50,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWallet({
    required String title,
    required double balance,
    required String image,
  }) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.grayscaleColor20),
        borderRadius: BorderRadius.circular(4.r),
      ),
      child: Row(
        children: [
          Image.asset(image, width: 29.w, height: 40.h),
          SizedBox(width: 24.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTextStyles.regular12()),
              Text(
                AppUtil.formatMoney(balance),
                style: AppTextStyles.semibold16(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
