import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/utils/dialog_util.dart';

class FogotPassController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode confirmPasswordFocusNode = FocusNode();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final isPasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final passwordStrength = false.obs;
  final passwordLowerCase = false.obs;
  final passwordUpperCase = false.obs;
  final key = ''.obs;
  final isEnable = false.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['key'] != null) {
        key.value = Get.arguments['key'];
      }
    }
    ever(passwordStrength, (value) {
      isValidate();
    });
    ever(passwordLowerCase, (value) {
      isValidate();
    });
    ever(passwordUpperCase, (value) {
      isValidate();
    });
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void onChangePassword(String value) {
    passwordStrength.value = value.length >= 8;
    passwordLowerCase.value = value.contains(
      RegExp(r'^(?=.*[a-z])(?=.*[A-Z]).+$'),
    );
    passwordUpperCase.value = value.contains(RegExp(r'^(?=.*(\d|[@#])).+$'));

    if (confirmPasswordController.text.isNotEmpty) {
      formKey.currentState?.validate();
    }
  }

  Future<void> changePassword() async {
    EasyLoading.show();
    client
        .changePassword(key: key.value, password: passwordController.text)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data['resultApi']['status'] == true) {
            successChangePassword();
          } else {
            DialogUtil.showErrorMessage(response.data['resultApi']['message']);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void onAction() {
    if ((formKey.currentState?.validate() ?? false) &&
        passwordStrength.value &&
        passwordLowerCase.value &&
        passwordUpperCase.value) {
      changePassword();
    }
  }

  bool isValidate() {
    if (passwordStrength.value &&
        passwordLowerCase.value &&
        passwordUpperCase.value) {
      return isEnable.value = true;
    }
    return isEnable.value = false;
  }

  Future<void> successChangePassword() async {
    DialogUtil.showConfirmDialog(
      Get.context!,
      image: AssetConstants.icSuccess,
      title: "success_change_password".tr,
      description: "please_login_to_continue".tr,
      button: "continue".tr,
      action: () {
        Get.offAllNamed(Routes.login);
      },
      isShowCancel: false,
    );
  }
}
