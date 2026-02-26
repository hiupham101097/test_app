import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/wallet_bank_model.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'with_draw_controller.dart';

class WithDrawPage extends GetView<WithDrawController> {
  const WithDrawPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: CustomScreen(
        title: 'withdraw_money'.tr,
        backgroundColor: AppColors.backgroundColor24,
        resizeToAvoidBottomInset: false,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(child: SingleChildScrollView(child: _buildBody())),
              SizedBox(height: 12.h),
              Obx(
                () => AppButton(
                  title: 'continue'.tr.toUpperCase(),
                  onPressed: () {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.withdraw();
                    }
                  },
                  isEnable: controller.isValid.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 22.h),
          Text(
            'please_select_money_and_bank'.tr,
            style: AppTextStyles.regular12(),
          ),
          SizedBox(height: 22.h),
          TitleDefaultTextField(
            focusNode: controller.moneyFocusNode,
            controller: controller.moneyController,
            title: 'money_to_withdraw'.tr,
            hintText: 'enter_money_to_withdraw'.tr,
            inputFormatter: [ThousandsFormatter()],
            textInputType: TextInputType.number,
            validator: controller.validateWithdraw,
            suffix: Container(
              margin: EdgeInsets.only(top: 13),
              child: Text(
                "currency_symbol".tr,
                style: AppTextStyles.semibold15(),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'withdraw_fee'.tr,
                style: AppTextStyles.medium12().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              Expanded(
                child: Text(
                  '0đ',
                  style: AppTextStyles.regular12(),
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          Divider(
            color: AppColors.grayscaleColor20,
            height: 16.h,
            thickness: 0.3.r,
          ),
          SizedBox(height: 16.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 8.h,
            children: List.generate(
              controller.listMoney.length,
              (index) => _buildMoney(controller.listMoney[index], index),
            ),
          ),
          SizedBox(height: 24.h),
          Text(
            'select_electronic_wallet'.tr,
            style: AppTextStyles.semibold16().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () =>
                controller.walletModel.value.bankList?.isEmpty ?? true
                    ? Center(
                      child: CustomEmpty(
                        title: 'no_data'.tr,
                        image: AssetConstants.icEmptyImage,
                        width: 48.r,
                        height: 48.r,
                      ),
                    )
                    : Column(
                      spacing: 12.h,
                      children: List.generate(
                        controller.walletModel.value.bankList?.length ?? 0,
                        (index) => _buildBank(
                          controller.walletModel.value.bankList?[index] ??
                              WalletBankModel(),
                        ),
                      ),
                    ),
          ),
          SizedBox(height: 10.h),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.addBank);
            },
            child: Row(
              children: [
                Icon(
                  Icons.add_circle_sharp,
                  color: AppColors.infomationColor,
                  size: 16.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    'Thêm tài khoản ngân hàng khác',
                    style: AppTextStyles.medium12().copyWith(
                      color: AppColors.infomationColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoney(String money, int index) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.moneyController.text = money.replaceAll('đ', '');
          controller.isSelectedMoney.value = index;
        },
        child: Container(
          width: (Get.width - 36.w) / 3,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.primaryColor5,
            border: Border.all(
              color:
                  controller.isSelectedMoney.value == index
                      ? AppColors.primaryColor60
                      : Colors.transparent,
              width: 1.r,
            ),
            borderRadius: BorderRadius.circular(4.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 1.r,
                offset: Offset(0.w, 1.h),
              ),
            ],
          ),
          child: Text(
            money,
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBank(WalletBankModel bank) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.selectedBank.value = bank;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
          decoration: BoxDecoration(
            color:
                controller.selectedBank.value.walletBankId == bank.walletBankId
                    ? AppColors.primaryColor5
                    : AppColors.backgroundColor24,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color:
                  controller.selectedBank.value.walletBankId ==
                          bank.walletBankId
                      ? AppColors.primaryColor60
                      : AppColors.grayscaleColor20,
              width: 0.5.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 1.r,
                offset: Offset(0.w, 2.h),
              ),
            ],
          ),
          child: Row(
            spacing: 12.w,
            children: [
              CachedImage(
                url: bank.bankImg ?? '',
                width: 48.r,
                height: 48.r,
                fit: BoxFit.contain,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      bank.accountHolderName ?? '',
                      style: AppTextStyles.medium14().copyWith(
                        color: AppColors.grayscaleColor80,
                      ),
                    ),
                    Text(
                      '${bank.bankCode ?? ''} | ${bank.cardNumber ?? ''}',
                      style: AppTextStyles.regular14().copyWith(
                        color: AppColors.grayscaleColor40,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  controller.diaLogDelete(bank.walletBankId ?? '');
                },
                child: Icon(
                  FontAwesomeIcons.solidTrashCan,
                  color: AppColors.grayscaleColor40,
                  size: 16.r,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
