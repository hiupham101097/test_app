import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'login_controller.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      builder: (controller) {
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
                    spacing: 39.h,
                    children: [
                      Image.asset(
                        AssetConstants.imgBackgroundAuth,
                        width: Get.width,
                        fit: BoxFit.contain,
                      ),
                      Expanded(child: _buildBody(controller)),
                      _buildBottom(controller),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(LoginController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Obx(
        () => Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "welcome_message".tr,
                  style: AppTextStyles.bold16().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: 20.h),
              Row(
                spacing: 5.w,
                children: [
                  Image.asset(
                    AssetConstants.icVerified,
                    width: 20.w,
                    height: 20.h,
                  ),
                  Expanded(
                    child: Text(
                      "smart_market_is_committed_to_account_security".tr,
                      style: AppTextStyles.medium12().copyWith(
                        color: AppColors.grayscaleColor70,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              TitleDefaultTextField(
                focusNode: controller.phoneFocusNode,
                controller: controller.phoneController,
                title: "account_label".tr,
                hintText: "account_placeholder".tr,
                textInputType: TextInputType.emailAddress,
                validator: (value) => Validator.userValidation(value),
              ),
              SizedBox(height: 24.h),
              Obx(
                () => TitleDefaultTextField(
                  focusNode: controller.passwordFocusNode,
                  controller: controller.passwordController,
                  title: "password_label".tr,
                  hintText: "password_placeholder".tr,
                  obscureText: !controller.isPasswordVisible.value,
                  validator: (value) => Validator.formValidation(value),
                  suffix: IconButton(
                    onPressed: controller.togglePasswordVisibility,
                    icon: Icon(
                      controller.isPasswordVisible.value
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                    ),
                  ),
                ),
              ),
              if (controller.errorMessage.value.isNotEmpty)
                Text(
                  "${controller.errorMessage.value}, ${"please_try_again".tr}",
                  style: AppTextStyles.regular12().copyWith(
                    color: AppColors.warningColor,
                  ),
                ),
              SizedBox(height: 8.h),
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.resetPassword);
                },
                child: Text(
                  "forgot_password".tr,
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

  Widget _buildBottom(LoginController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        children: [
          Obx(
            () => AppButton(
              title: "login".tr,
              onPressed: controller.onAction,
              isEnable: controller.isFormValid.value,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5.w,
            children: [
              Text("no_account".tr, style: AppTextStyles.regular12()),
              GestureDetector(
                onTap: () {
                  final store = StoreDB().currentStore();
                  if (store?.id != null) {
                    Get.toNamed(Routes.infoStore);
                  } else {
                    Get.toNamed(Routes.register);
                  }
                },
                child: Text(
                  "sign_up".tr,
                  style: AppTextStyles.medium12().copyWith(
                    color: AppColors.infomationColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
