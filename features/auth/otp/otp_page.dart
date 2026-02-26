import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'otp_controller.dart';

class OtpPage extends GetView<OtpController> {
  const OtpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScreen(
        resizeToAvoidBottomInset: true,
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
            ),
            child: IntrinsicHeight(
              child: Column(
                spacing: 14.h,
                children: [
                  Stack(
                    children: [
                      Image.asset(
                        AssetConstants.imgBackgroundAuth,
                        width: Get.width,
                        fit: BoxFit.contain,
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        right: 0,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.white,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                "verify_otp".tr,
                                style: AppTextStyles.bold16().copyWith(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Expanded(child: _buildBody()),
                  _buildBottom(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "otp_desc".tr,
                  style: AppTextStyles.regular14().copyWith(
                    color: AppColors.grayscaleColor90,
                  ),
                ),
                TextSpan(
                  text: " ${controller.key.value} ",
                  style: AppTextStyles.semibold14().copyWith(
                    color: AppColors.grayscaleColor90,
                  ),
                ),
                TextSpan(
                  text: " ${"otp_desc_2".tr}",
                  style: AppTextStyles.regular14().copyWith(
                    color: AppColors.grayscaleColor90,
                  ),
                ),
                TextSpan(
                  text:
                      " ${controller.channel.value == ''
                          ? "Gmail"
                          : controller.channel.value == 'sms'
                          ? "SMS".tr
                          : "ZALO".tr} ",
                  style: AppTextStyles.semibold14().copyWith(
                    color: AppColors.grayscaleColor90,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          TextField(
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            style: AppTextStyles.medium14().copyWith(
              color: AppColors.grayscaleColor90,
              fontSize: 34,
            ),
            controller: controller.otpController,
            focusNode: controller.otpFocusNode,
            maxLength: 6,
            decoration: InputDecoration(
              hintText: "000000".tr,
              hintStyle: AppTextStyles.medium14().copyWith(
                color: AppColors.grayscaleColor40,
                fontSize: 34,
              ),
              counterText: "",
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
              contentPadding: EdgeInsets.zero,
            ),
            onEditingComplete: () {
              controller.onAction();
            },
            onChanged: (value) {
              controller.checkOtp();
            },
          ),
          const SizedBox(height: 20),
          Obx(
            () => Center(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text:
                          controller.time.value.inSeconds > 0
                              ? "otp_desc_4".tr
                              : "otp_desc_7".tr,
                      style: AppTextStyles.regular14().copyWith(
                        color: AppColors.grayscaleColor90,
                      ),
                    ),
                    TextSpan(
                      recognizer:
                          TapGestureRecognizer()
                            ..onTap = () {
                              if (controller.time.value.inSeconds <= 0) {
                                controller.sendOtp();
                              }
                            },
                      text:
                          controller.time.value.inSeconds > 0
                              ? " ${controller.time.value.inMinutes.toString().padLeft(2, '0')}:${(controller.time.value.inSeconds % 60).toString().padLeft(2, '0')}"
                              : " ${"otp_desc_6".tr}",
                      style: AppTextStyles.semibold14().copyWith(
                        color: AppColors.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Obx(
        () => AppButton(
          title: "continue".tr,
          onPressed: controller.onAction,
          isEnable: controller.isEnable.value,
        ),
      ),
    );
  }
}
