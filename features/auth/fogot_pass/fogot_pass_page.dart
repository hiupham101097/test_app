import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'fogot_pass_controller.dart';

class FogotPassPage extends GetView<FogotPassController> {
  const FogotPassPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScreen(
        title: "create_new_password".tr,

        resizeToAvoidBottomInset: false,
        child: Column(
          spacing: 39,
          children: [_buildBody(), const Spacer(), _buildBottom()],
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12).copyWith(top: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "please_enter_new_password".tr,
                style: AppTextStyles.semibold12().copyWith(
                  color: AppColors.grayscaleColor90,
                ),
              ),
              const SizedBox(height: 24),
              TitleDefaultTextField(
                focusNode: controller.passwordFocusNode,
                controller: controller.passwordController,
                title: "password_label".tr,
                hintText: "password_placeholder".tr,
                obscureText: !controller.isPasswordVisible.value,
                suffix: IconButton(
                  onPressed: controller.togglePasswordVisibility,
                  icon: Icon(
                    controller.isPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                onChanged: (value) => controller.onChangePassword(value),
              ),
              const SizedBox(height: 16),
              _buildWarningPassword(),
              const SizedBox(height: 24),
              TitleDefaultTextField(
                focusNode: controller.confirmPasswordFocusNode,
                controller: controller.confirmPasswordController,
                title: "password_label".tr,
                hintText: "confirm_password_placeholder".tr,
                obscureText: !controller.isConfirmPasswordVisible.value,
                validator:
                    (value) => Validator.confirmPasswordValidation(
                      value,
                      controller.passwordController.text,
                    ),
                suffix: IconButton(
                  onPressed: controller.toggleConfirmPasswordVisibility,
                  icon: Icon(
                    controller.isConfirmPasswordVisible.value
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
                onChanged: (value) {
                  // Trigger validation when confirm password changes
                  controller.formKey.currentState?.validate();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWarningPassword() {
    return Obx(
      () => Column(
        spacing: 8,
        children: [
          _buildWarningText(
            text: "password_must_be_at_least_8_characters".tr,
            success: controller.passwordStrength.value,
          ),
          _buildWarningText(
            text: "password_must_contain_lowercase_letters".tr,
            success: controller.passwordLowerCase.value,
          ),
          _buildWarningText(
            text: "password_must_contain_uppercase_letters".tr,
            success: controller.passwordUpperCase.value,
          ),
        ],
      ),
    );
  }

  Widget _buildWarningText({required String text, required bool success}) {
    return Row(
      spacing: 8,
      children: [
        Icon(
          success ? Icons.check_circle_outline : Icons.error_outline,
          size: 16,
          color: success ? AppColors.successColor : AppColors.warningColor,
        ),
        Text(text, style: AppTextStyles.regular12()),
      ],
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          Obx(
            () => AppButton(
              title: "continue".tr,
              onPressed: controller.onAction,
              isEnable: controller.isEnable.value,
            ),
          ),
        ],
      ),
    );
  }
}
