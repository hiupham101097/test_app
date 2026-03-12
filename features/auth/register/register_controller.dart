import 'dart:async';
import 'package:merchant/commons/types/method_enum.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/features/auth/otp/otp_controller.dart';
import 'package:merchant/features/auth/reset_password/widget/bottomsheet_method_send.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/navigations/app_pages.dart';

class RegisterController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode phoneFocusNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode referralCodeFocusNode = FocusNode();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController referralCodeController = TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final isFormValid = false.obs;
  final errorMessage = ''.obs;
  final isAgree = false.obs;
  final method = MethodEnum.sms.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_validateForm);
    passwordController.addListener(_validateForm);
    confirmPasswordController.addListener(_validateForm);
    emailController.addListener(_validateForm);
    // referralCodeController.addListener(_validateForm);
    ever(isAgree, (value) {
      _validateForm();
    });
  }

  void _validateForm() {
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
    final phoneValid = phoneController.text.trim().isNotEmpty;
    final passwordValid = passwordController.text.trim().isNotEmpty;
    final confirmPasswordValid =
        confirmPasswordController.text.trim().isNotEmpty;
    final emailValid = emailController.text.trim().isNotEmpty;
    // final referralCodeValid = referralCodeController.text.trim().isNotEmpty;
    isFormValid.value =
        phoneValid &&
        passwordValid &&
        confirmPasswordValid &&
        emailValid &&
        isAgree.value;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void onAction() {
    Get.bottomSheet(
      BottomSheetMethodSend(
        selectedMethod: method.value,
        onTap: (method) {
          Get.back();
          this.method.value = method;
          sendOtp();
        },
      ),
    );
  }

  Future<void> singInConfirm() async {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        'Đăng nhập hệ thống'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.primaryColor),
        textAlign: TextAlign.center,
      ),
      description: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: "Số điện thoại ", style: AppTextStyles.regular14()),
            TextSpan(
              text: phoneController.text,
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text:
                  " đã tồn tại trong hệ thống. Vui lòng đăng nhập để tiếp tục.",
              style: AppTextStyles.regular14(),
            ),
          ],
        ),
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Đăng nhập'.tr,
      typeButtonLeft: AppButtonType.nomal,
      typeButtonRight: AppButtonType.outline,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        Get.back();
        Get.back();
      },
    );
  }

  Future<void> checkPhone() async {
    errorMessage.value = '';
    if (formKey.currentState?.validate() ?? false) {
      EasyLoading.show();

      client
          .checkExisted(phoneOrEmail: phoneController.text)
          .then((response) async {
            EasyLoading.dismiss();
            if (response.statusCode == 200) {
              if (response.data['resultApi']['user']['id'] != null) {
                singInConfirm();
              } else {
                onAction();
              }
            }                                                                                              
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    }
  }

  Future<void> sendOtp() async {
    EasyLoading.show();
    client
        .sendOtp(channel: method.value.getCode(), key: phoneController.text)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            Get.toNamed(
              Routes.otp,
              arguments: {
                'key': phoneController.text,
                'channel': method.value.getCode(),
                'otpType': OtpType.register,
                'email': emailController.text,
                'password': passwordController.text,
                'introduceCode ': referralCodeController.text,
              },
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
