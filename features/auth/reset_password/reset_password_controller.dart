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

class ResetPasswordController extends GetxController {
  final ApiClient client = ApiClient();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  final isEnable = false.obs;
  final isPhone = true.obs;
  final formKey = GlobalKey<FormState>();
  final method = MethodEnum.sms.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      isEnable.value = phoneController.text.isNotEmpty;
    });
  }

  @override
  void onClose() {
    super.onClose();
  }

  void togglePhone() {
    formKey.currentState?.reset();
    phoneController.text = '';
    isPhone.value = !isPhone.value;
    phoneFocusNode.unfocus();
  }

  void onAction() {
    if (isPhone.value) {
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
    } else {
      sendOtp();
    }
  }

  Future<void> confirmResetPassword() async {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        'Xác nhận đặt lại mật khẩu'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.primaryColor),
        textAlign: TextAlign.center,
      ),
      description: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(
              text: isPhone.value ? "Số điện thoại " : "Email ",
              style: AppTextStyles.regular14(),
            ),
            TextSpan(
              text: phoneController.text,
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text:
                  " không tồn tại trong hệ thống. Vui lòng xác nhận lại thông tin để tiếp tục.",
              style: AppTextStyles.regular14(),
            ),
          ],
        ),
      ),
      isShowLeft: false,
      titleRight: 'Tiếp tục'.tr,
      typeButtonRight: AppButtonType.outline,
      outlineColor: AppColors.primaryColor,
    );
  }

  Future<void> checkExisted() async {
    if (formKey.currentState?.validate() ?? false) {
      EasyLoading.show();

      client
          .checkExisted(phoneOrEmail: phoneController.text)
          .then((response) async {
            EasyLoading.dismiss();
            if (response.statusCode == 200) {
              if (response.data['resultApi']['data']['status'] == false) {
                confirmResetPassword();
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
        .sendOtp(
          channel: isPhone.value ? method.value.getCode() : null,
          key: phoneController.text,
        )
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            Get.toNamed(
              Routes.otp,
              arguments: {
                'key': phoneController.text,
                'channel': isPhone.value ? method.value.getCode() : null,
                'otpType': OtpType.resetPassword,
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
