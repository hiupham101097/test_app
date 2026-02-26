import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/features/auth/login/login_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

import 'dialog_util.dart';
import 'object_util.dart';

class ErrorUtil {
  static ErrorUtil instance = ErrorUtil();

  static String? getError(error, trace) {
    String? errorMsg;
    if (error is DioException) {
      if (kDebugMode) {
        print(
          'Error api: ${error.requestOptions.method} ${error.requestOptions.path}',
        );
        print('Error request headers: ${error.requestOptions.headers}');
        print('Error request data: ${error.requestOptions.data}');
        print('Error response: ${error.response?.data}');
        print('Error stauts: ${error.response?.statusCode}');
      }

      if (error.response?.statusCode == 500 ||
          error.response?.statusCode == 501 ||
          error.response?.statusCode == 502 ||
          // error.response?.statusCode == 404 ||
          error.response?.statusCode == 503) {
        return 'Xin vui lòng thử lại sau';
      }
      if (error.response?.statusCode == 401) {
        sl<LocalClient>().clearAccessToken();
        StoreDB().clear();
        UserDB().clear();
        WalletDB().clear();
        WalletDB().clearWalletUser();
        sl<LocalClient>().clearPassword();

        if (Get.isRegistered<LoginController>()) {
          Get.delete<LoginController>(force: true);
        }

        Get.offAllNamed(Routes.login);
        return 'Phiên đăng nhập hết hạn';
      }
      if (error.response?.statusCode == 403) {
        return DialogUtil.showDialogSuccessTransaction(
          Get.context!,
          isDisablePop: false,
          image: Lottie.asset(
            AssetConstants.lottieError,
            width: 100.w,
            height: 100.h,
            fit: BoxFit.contain,
          ),
          title: Text(
            'Không có quyền truy cập'.tr,
            style: AppTextStyles.bold20().copyWith(
              color: AppColors.warningColor,
            ),
            textAlign: TextAlign.center,
          ),
          description: Text(
            "Bạn không có quyền truy cập vào trang này.\nVui lòng liên hệ admin để được hỗ trợ."
                .tr,
            style: AppTextStyles.regular14(),
            textAlign: TextAlign.center,
          ),
          titleRight: 'Về trang chủ'.tr,
          isShowLeft: false,
          typeButtonRight: AppButtonType.remove,
          actionRight: () {
            Get.offAllNamed(Routes.root);
          },
        );
      }

      if (error.response?.statusCode == 429) {
        return 'Bạn đang thao tác nhanh quá';
      }
      if (error.response?.statusCode == 404) {
        return 'Không tìm thấy dữ liệu';
      }

      if (error.response?.data is String) {
        // errorMsg =
        // '${error.requestOptions.path}\n${error.response?.data?.toString() ?? ''}';
        try {
          final parsed = jsonDecode(
            error.response?.data,
          ); // cần import 'dart:convert';
          if (parsed is Map<String, dynamic>) {
            print('Message: ${parsed['message']}');
            errorMsg = parsed['message'];
          } else {
            print('Dữ liệu không hợp lệ: $parsed');
          }
        } catch (e) {
          print('Không parse được JSON: $e');
          errorMsg = 'Lỗi không xác định. Vui lòng thử lại sau';
        }
      } else {
        if (error.response?.data != null &&
            error.response?.data['message'] != null) {
          errorMsg = error.response?.data['message'];
          if (errorMsg == 'INVALID_TOKEN') {}
        } else {
          if (error.response?.data == null) {
            errorMsg = 'SERVER_NOT_RESPONDING';
          } else {
            errorMsg = '${error.requestOptions.path}\n$error';
          }
        }
      }
    } else {
      errorMsg = error.toString();
    }

    return errorMsg;
  }

  static FutureOr<void> catchError(error, trace) {
    if (kDebugMode) {
      print(error);
      print(trace);
    }
    String? msg = ErrorUtil.getError(error, trace);
    if (ObjectUtil.isNotEmpty(msg)) {
      if (error.response?.statusCode != 403) {
        DialogUtil.showErrorMessage(msg!.tr);
      }
    } else {
      if (error.response?.statusCode != 403) {
        DialogUtil.showErrorMessage(error.toString());
      }
    }

    return Future.value(null);
  }
}
