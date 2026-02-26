import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/auth/widget/webview.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'register_controller.dart';

class RegisterPage extends GetView<RegisterController> {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: CustomScreen(
        resizeToAvoidBottomInset: true,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                AssetConstants.imgBackgroundAuth,
                width: Get.width,
                fit: BoxFit.contain,
              ),
              _buildBody(),
              _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Obx(
        () => GestureDetector(
          onTap: () => FocusScope.of(Get.context!).unfocus(),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    "Đăng ký bán hàng tại \nChợ Thông Minh!".tr,
                    style: AppTextStyles.bold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 24.h),
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
                  hintText: "phone_placeholder".tr,
                  textInputType: TextInputType.phone,
                  validator: (value) => Validator.phoneValidation(value),
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
                SizedBox(height: 24.h),
                Obx(
                  () => TitleDefaultTextField(
                    focusNode: controller.confirmPasswordFocusNode,
                    controller: controller.confirmPasswordController,
                    title: "Nhập lại mật khẩu".tr,
                    hintText: "Nhập lại mật khẩu".tr,
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
                  ),
                ),
                SizedBox(height: 24.h),
                TitleDefaultTextField(
                  focusNode: controller.emailFocusNode,
                  controller: controller.emailController,
                  title: "Email".tr,
                  hintText: "Email của bạn".tr,
                  textInputType: TextInputType.emailAddress,
                  validator: (value) => Validator.emailValidation(value),
                ),
                SizedBox(height: 24.h),
                TitleDefaultTextField(
                  focusNode: controller.referralCodeFocusNode,
                  controller: controller.referralCodeController,
                  title: "referral_code".tr,
                  hintText: "Mã giới thiệu của bạn".tr,
                  textInputType: TextInputType.text,
                ),
                SizedBox(height: 8.h),
                if (controller.errorMessage.value.isNotEmpty)
                  Text(
                    "${controller.errorMessage.value}, ${"please_try_again".tr}",
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.warningColor,
                    ),
                  ),
                SizedBox(height: 24.h),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GestureDetector(
                      onTap: () {
                        controller.isAgree.value = !controller.isAgree.value;
                      },
                      child: Icon(
                        controller.isAgree.value
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color:
                            controller.isAgree.value
                                ? AppColors.infomationColor
                                : AppColors.grayscaleColor70,
                        size: 18.r,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              text: "Bằng cách tiếp tục, bạn chấp nhận ",
                              style: AppTextStyles.regular12(),
                            ),
                            TextSpan(
                              text: "Điều khoản ",
                              style: AppTextStyles.regular12().copyWith(
                                color: AppColors.infomationColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        Get.context!,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => InAppWebViewPage(
                                                url:
                                                    'https://chothongminh.com/chi-tiet-tin-tuc/dieu-khoan-bao-mat-cho-thong-minh',
                                                title: 'Điều khoản bảo mật',
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            TextSpan(text: "và "),
                            TextSpan(
                              text: "Chính sách bảo mật ",
                              style: AppTextStyles.regular12().copyWith(
                                color: AppColors.infomationColor,
                              ),
                              recognizer:
                                  TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        Get.context!,
                                        MaterialPageRoute(
                                          builder:
                                              (context) => InAppWebViewPage(
                                                url:
                                                    'https://chothongminh.com/chi-tiet-tin-tuc/chinh-sach-bao-mat',
                                                title: 'Chính sách bảo mật',
                                              ),
                                        ),
                                      );
                                    },
                            ),
                            TextSpan(text: "của "),
                            TextSpan(
                              text: "Chợ Thông Minh.",
                              style: AppTextStyles.medium12().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                          ],
                        ),
                        textAlign: TextAlign.start,
                        style: AppTextStyles.medium12(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
      child: Column(
        children: [
          Obx(
            () => AppButton(
              title: "TIẾP THEO".tr,
              onPressed: controller.checkPhone,
              isEnable: controller.isFormValid.value,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 5.w,
            children: [
              Text("Bạn đã có tài khoản?".tr, style: AppTextStyles.regular12()),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  " Đăng nhập".tr,
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
