import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/channel_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'dispose_controller.dart';

class DisposePage extends GetView<DisposeController> {
  const DisposePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.focusScope?.unfocus();
      },
      child: CustomScreen(
        title: 'dispose_money'.tr,
        resizeToAvoidBottomInset: false,
        child: Padding(
          padding: EdgeInsets.all(12.w),
          child: Column(
            children: [
              Expanded(child: _buildBody()),
              SizedBox(height: 12.h),
              Obx(
                () => AppButton(
                  title: 'continue'.tr.toUpperCase(),
                  onPressed: () {
                    if (controller.formKey.currentState?.validate() ?? false) {
                      controller.confirmTransaction();
                    }
                  },
                  isEnable:
                      controller.isValid.value && !controller.loading.value,
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
          Text(
            'Số tiền muốn nạp'.tr,
            style: AppTextStyles.semibold16().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 22.h),
          Text(
            'dispose_money_description'.tr,
            style: AppTextStyles.regular12(),
          ),
          SizedBox(height: 22.h),
          TitleDefaultTextField(
            focusNode: controller.moneyFocusNode,
            controller: controller.moneyController,
            title: 'money_title'.tr,
            hintText: 'money_hint'.tr,
            inputFormatter: [ThousandsFormatter()],
            textInputType: TextInputType.number,
            validator: controller.validateDisposeMoney,
            suffix: Container(
              margin: EdgeInsets.only(top: 13),
              child: Text(
                "currency_symbol".tr,
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Text(
                'dispose_money_fee'.tr,
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
            'select_wallet'.tr,
            style: AppTextStyles.semibold16().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 10.h),
          Obx(
            () => Column(
              spacing: 12.h,
              children: List.generate(
                controller.channelList.length,
                (index) => _buildMethod(controller.channelList[index]),
              ),
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
          controller.moneyController.text = money;
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
            '${money} đ',
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMethod(ChannelModel channel) {
    return Obx(
      () => GestureDetector(
        onTap: () {
          controller.selectedChannel.value = channel;
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 18.w),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor24,
            borderRadius: BorderRadius.circular(8.r),
            border: Border.all(
              color:
                  controller.selectedChannel.value.brandId == channel.brandId
                      ? AppColors.primaryColor60
                      : AppColors.grayscaleColor20,
              width: 1.r,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 1.r,
                offset: Offset(0.w, 1.h),
              ),
            ],
          ),
          child: Row(
            children: [
              CachedImage(
                url: AssetConstants.atmCard,
                width: 24.w,
                height: 24.w,
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Text(
                  'Thanh toán qua ngân hàng',
                  style: AppTextStyles.medium14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
