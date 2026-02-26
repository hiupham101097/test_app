import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/auth/reset_password/widget/bottomsheet_method_send.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'reset_password_controller.dart';

class ResetPasswordPage extends GetView<ResetPasswordController> {
  const ResetPasswordPage({super.key});

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
                        top: MediaQuery.of(context).padding.top + 16.h,
                        left: 0,
                        right: 0,
                        child: Text(
                          "reset_password".tr.toUpperCase(),
                          style: AppTextStyles.bold16().copyWith(
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Positioned(
                        top: MediaQuery.of(context).padding.top,
                        left: 0,
                        child: IconButton(
                          onPressed: () => Get.back(),
                          icon: Icon(
                            Icons.arrow_back_ios_new_outlined,
                            color: Colors.white,
                          ),
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
    return Obx(
      () => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: "otp_send_description".tr,
                      style: AppTextStyles.regular14().copyWith(
                        color: AppColors.grayscaleColor90,
                      ),
                    ),
                    TextSpan(
                      text:
                          controller.isPhone.value
                              ? "phone_text".tr
                              : "email_text".tr,
                      style: AppTextStyles.semibold14().copyWith(
                        color: AppColors.grayscaleColor90,
                      ),
                    ),
                    TextSpan(
                      text: "otp_confirm_description".tr,
                      style: AppTextStyles.regular14().copyWith(
                        color: AppColors.grayscaleColor90,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TitleDefaultTextField(
                focusNode: controller.phoneFocusNode,
                controller: controller.phoneController,
                title:
                    controller.isPhone.value
                        ? "phone_label".tr
                        : "email_label".tr,
                hintText:
                    controller.isPhone.value
                        ? "phone_placeholder".tr
                        : "email_placeholder".tr,
                textInputType:
                    controller.isPhone.value
                        ? TextInputType.phone
                        : TextInputType.emailAddress,
                validator:
                    (value) =>
                        controller.isPhone.value
                            ? Validator.phoneValidation(value)
                            : Validator.emailValidation(value),
              ),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: () {
                  controller.togglePhone();
                },
                child: Text(
                  controller.isPhone.value
                      ? "otp_send_via_email".tr
                      : "otp_send_via_phone".tr,
                  style: AppTextStyles.medium12().copyWith(
                    color: AppColors.infomationColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Obx(
        () => AppButton(
          title: "continue".tr,
          onPressed: () {
            controller.checkExisted();
          },
          isEnable: controller.isEnable.value,
        ),
      ),
    );
  }
}
