import 'dart:async';

import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/user_model.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/navigations/app_pages.dart';

enum OtpType { register, resetPassword }

class OtpController extends GetxController {
  final ApiClient client = ApiClient();
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocusNode = FocusNode();
  final time = Duration(minutes: 1).obs;
  Timer? _timer;
  final isEnable = false.obs;
  final key = ''.obs;
  final channel = ''.obs;
  final otpType = OtpType.register.obs;
  final email = ''.obs;
  final password = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['key'] != null) {
        key.value = Get.arguments['key'];
      }
      if (Get.arguments['channel'] != null) {
        channel.value = Get.arguments['channel'];
      }
      if (Get.arguments['otpType'] != null) {
        otpType.value = Get.arguments['otpType'];
      }
      if (Get.arguments['email'] != null) {
        email.value = Get.arguments['email'];
      }
      if (Get.arguments['password'] != null) {
        password.value = Get.arguments['password'];
      }
    }
    startTimer();
  }

  void checkOtp() {
    isEnable.value = otpController.text.length == 6;
  }

  @override
  void onClose() {
    _timer?.cancel();
    otpController.dispose();
    otpFocusNode.dispose();
    super.onClose();
  }

  void startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (time.value.inSeconds > 0) {
        time.value = Duration(seconds: time.value.inSeconds - 1);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> verifyOtp() async {
    EasyLoading.show();
    client
        .verifyOtp(
          channel: channel.value,
          key: key.value,
          otp: otpController.text,
        )
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            Get.toNamed(Routes.fogotPass, arguments: {'key': key.value});
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> registerUser() async {
    EasyLoading.show();
    final data = {
      "otp": otpController.text,
      "phoneNumber": key.value,
      "password": password.value,
      "emailAddress": email.value,
      "channel": channel.value,
    };
    client
        .registerUser(data)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            Get.offAllNamed(
              Routes.infoStore,
              arguments: {'phone': key.value, 'email': email.value},
            );
            sl<LocalClient>().setEmail(email.value);
            sl<LocalClient>().setPhone(key.value);
            sl<LocalClient>().setAccessToken(response.data["resultApi"]["token"]);
            final user = UserModel.fromJson(
              response.data["resultApi"]['user'] as Map<String, dynamic>,
            );
            await UserDB().save(user);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
          // final Map<String, dynamic> data =
          //     error.response?.data as Map<String, dynamic>;
          // DialogUtil.showErrorMessage(data['message']['message']);
        });
  }

  Future<void> sendOtp() async {
    EasyLoading.show();
    client
        .sendOtp(channel: channel.value, key: key.value)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            time.value = Duration(minutes: 1);
            startTimer();
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void onAction() {
    if (otpType.value == OtpType.register) {
      registerUser();
    } else {
      verifyOtp();
    }
  }
}
