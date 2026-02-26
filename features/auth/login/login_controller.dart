import 'dart:async';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/fcm_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/navigations/app_pages.dart';

class LoginController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode phoneFocusNode = FocusNode();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final isFormValid = false.obs;
  final errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(() {
      _validateForm();
      errorMessage.value = '';
    });
    passwordController.addListener(() {
      _validateForm();
      errorMessage.value = '';
    });
  }

  void _validateForm() {
    if (formKey.currentState != null) {
      formKey.currentState!.validate();
    }
    final phoneValid = phoneController.text.trim().isNotEmpty;
    final passwordValid = passwordController.text.trim().isNotEmpty;
    isFormValid.value = phoneValid && passwordValid;
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void onAction() {
    errorMessage.value = '';
    if (formKey.currentState?.validate() ?? false) {
      login();
    }
  }

  Future<void> login() async {
    final fcmToken = await FcmUtil().getFcmToken();
    final deviceId = await AppUtil.getDeviceId();
    EasyLoading.show();
    if (fcmToken != null && deviceId != '') {
      client
          .login(
            phone: phoneController.text.trim(),
            password: passwordController.text.trim(),
            device: deviceId,
            fcmToken: fcmToken,
          )
          .then((response) async {
            EasyLoading.dismiss();
            if (response.data['resultApi']['token'] != null &&
                response.data['resultApi']['employId'] != null) {
              final token = response.data['resultApi']['token'];
              sl<LocalClient>().setAccessToken(token);
              sl<LocalClient>().setPassword(passwordController.text);
              getInfoUser(token);
              sl<LocalClient>().clearEmail();
            } else {
              final email =
                  response.data['resultApi']['userInfo']['emailAddress'];
              final phone =
                  response.data['resultApi']['userInfo']['phoneNumber'];
              print("email: $email");
              print("phone: $phone");
              if (response.data['status'] == 200 &&
                  email != null &&
                  phone != null) {
                registerConfirm(
                  'Đăng ký cửa hàng',
                  "Tài khoản hiện tại chưa được đăng ký của hàng , Vui lòng đăng ký để  tiếp tục",
                  () {
                    Get.toNamed(
                      Routes.infoStore,
                      arguments: {'phone': phone, 'email': email},
                    );
                  },
                );
              }
            }
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            String? msg = ErrorUtil.getError(error, trace);
            errorMessage.value = msg ?? '';

            if (error is dynamic &&
                error.runtimeType.toString().contains('Dio')) {
              try {
                if (error.response?.statusCode == 404) {
                  registerConfirm('Đăng ký tài khoản', errorMessage.value, () {
                    Get.toNamed(Routes.register);
                  });
                }
              } catch (_) {
                // Tránh trường hợp lỗi lồng lỗi khi truy cập response
              }
            }
          });
    } else {
      EasyLoading.dismiss();
      DialogUtil.showErrorMessage('please_try_again_later'.tr);
    }
  }

  Future<void> registerConfirm(
    String title,
    String description,
    Function? actionRight,
  ) async {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        title,
        style: AppTextStyles.bold20().copyWith(color: AppColors.primaryColor),
        textAlign: TextAlign.center,
      ),
      description: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: [
            TextSpan(text: description, style: AppTextStyles.regular14()),
          ],
        ),
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Đăng ký'.tr,
      typeButtonLeft: AppButtonType.nomal,
      typeButtonRight: AppButtonType.outline,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        actionRight?.call();
      },
    );
  }

//   getInfoUser(String token) async {
//   EasyLoading.show();
//   client.getInfoUser(token: token).then((response) async {
//     final resultApi = response.data['resultApi'];

//     if (resultApi != null) {
//       if (resultApi['user'] != null) {
//         final user = UserModel.fromJson(resultApi['user']);
//         await UserDB().save(user);
//       }

//       if (resultApi['storeInfo'] != null) {
//         final store = StoreModel.fromJson(resultApi['storeInfo']);
//         await StoreDB().save(store);
        
//         await WalletService().getWallet(phone: store.phone, store: store);
//       } else {
//         print("Cảnh báo: StoreInfo bị null nhưng vẫn cho vào Home");
        
//       }

//       Get.offAllNamed(Routes.root);

//     } else {
//       sl<LocalClient>().clearAccessToken();
//       sl<LocalClient>().clearPassword();
//     }
//     EasyLoading.dismiss();
//   }).catchError((error, trace) {
//     EasyLoading.dismiss();
//     debugPrint("Lỗi GetInfoUser: $error");
//   });
// }

  getInfoUser(String token) async {
    EasyLoading.show();
    client
        .getInfoUser(token: token)
        .then((response) async {
          if (response.data['resultApi'] != null) {
            final store = StoreModel.fromJson(
              response.data['resultApi']['storeInfo'],
            );
            final user = UserModel.fromJson(response.data['resultApi']['user']);
            print("store: ${store.closeOpenStatus}");
            print("Image Url Map: ${store.imageUrlMap}");
            await StoreDB().save(store);
            await UserDB().save(user);
            await WalletService().getWallet(phone: store.phone, store: store);
            Get.offAllNamed(Routes.root);
            EasyLoading.dismiss();
          } else {
            sl<LocalClient>().clearAccessToken();
            sl<LocalClient>().clearPassword();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
