import 'dart:async';
import 'dart:convert';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_bank_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/confirm_transaction/widget/bottomsheet_confirm_pass.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/features/wallet/with_draw/with_draw_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/security_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ConfirmTransactionController extends GetxController {
  final ApiClient client = ApiClient();
  final amount = Rxn<String>();
  final selectedBank = WalletBankModel().obs;
  final isLoading = false.obs;
  final walletUser = WalletUserModel().obs;
  final selectedWithDrawType = MyWalletType.walletIn.obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['amount'] != null) {
      amount.value = Get.arguments['amount'];
    }
    if (Get.arguments != null && Get.arguments['selectedBank'] != null) {
      selectedBank.value = Get.arguments['selectedBank'];
    }
    if (Get.arguments != null && Get.arguments['type'] != null) {
      selectedWithDrawType.value = Get.arguments['type'];
      print('selectedWithDrawType: ${selectedWithDrawType.value}');
    }
    walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
  }

  Future<void> withdrawWalletDiscount({int? idVoucher}) async {
    try {
      showLoading();

      final data = {
        "Amount": int.tryParse(amount.value ?? '0') ?? 0,
        "WalletId": WalletDB().currentWalletUser()?.id ?? '',
        "walletBankId": selectedBank.value.walletBankId ?? '',
      };

      final response = await client.withdrawWalletDiscount(data: data);

      Get.back(); // đóng loading

      if (response.statusCode != 200 || response.data['status'] != 200) {
        diaLogError();
        return;
      }

      // Giải mã payload
      final payload = response.data['resultApi']?['payload'];
      if (payload == null) {
        diaLogError();
        return;
      }

      final dataDecoded = jsonDecode(payload);
      final bool isSuccess = dataDecoded['isSuccess'] == true;
      final String status =
          (dataDecoded['status'] ?? '').toString().toLowerCase();

      if (isSuccess) {
        await Future.wait([
          WalletService().getWallet(
            phone: StoreDB().currentStore()?.phone ?? '',
            store: StoreDB().currentStore() ?? StoreModel(),
          ),
          WalletService().getWalletUser(),
        ]);

        walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();

        // Hiển thị dialog theo trạng thái
        if (status == 'pending') {
          diaLogWithdrawPending();
        } else if (status == 'success') {
          diaLogWithdraw();
        }
      } else {
        if (status == 'pending') {
          diaLogWithdrawPending();
        } else {
          diaLogError();
        }
      }
    } catch (error, trace) {
      Get.back(); // đảm bảo đóng loading dù có lỗi
      diaLogError();
      debugPrint('withdrawWalletDiscount error: $error');
      debugPrint('$trace');
    }
  }

  actionWithdraw() async {
    if (selectedWithDrawType.value == MyWalletType.walletIn) {
      confirmTransaction();
    } else {
      withdrawWalletDiscount();
    }
  }

  actionWithdrawBottomSheet() {
    Get.bottomSheet(
      BottomSheetConfirmPass(
        onTap: () {
          Get.back();
          actionWithdraw();
        },
      ),
      isScrollControlled: true,
    );
  }

  Future<void> confirmTransaction() async {
    try {
      showLoading();

      final headers = await WalletService().buildWalletHeaders();
      final time = await WalletService().getRealTime();

      final payloadWithdraw = {
        "walletId":
            selectedWithDrawType.value == MyWalletType.walletIn
                ? WalletDB().currentWallet()?.walletId
                : WalletDB().currentWalletUser()?.id,
        "walletBankId": selectedBank.value.walletBankId,
        "totalPrice": int.tryParse(amount.value ?? '0') ?? 0,
      };

      final encryptedPayload = SecurityUtil.encryptAES(
        payloadWithdraw,
        DateTime.parse(time).millisecondsSinceEpoch,
        AppConstants.securityKey,
      );

      final response = await client.withdraw(
        headers: headers,
        data: encryptedPayload,
      );

      Get.back(); // đóng loading

      if (response.statusCode != 200 || response.data['status'] != 200) {
        diaLogError();
        return;
      }

      final payload = response.data['resultApi']?['payload'];
      if (payload == null) {
        diaLogError();
        return;
      }

      final decodedData = jsonDecode(payload);
      final bool isSuccess = decodedData['isSuccess'] == true;
      final String status =
          (decodedData['status'] ?? '').toString().toLowerCase();
      await WalletService().getWallet(
        phone: StoreDB().currentStore()?.phone ?? '',
        store: StoreDB().currentStore() ?? StoreModel(),
      );
      if (isSuccess) {
        switch (status) {
          case 'pending':
            diaLogWithdrawPending();
            break;
          case 'success':
            diaLogWithdraw();
            break;
          default:
            diaLogError();
        }
      } else {
        if (status == 'pending') {
          diaLogWithdrawPending();
        } else {
          diaLogError();
        }
      }
    } catch (error, trace) {
      Get.back(); // đảm bảo loading luôn được tắt
      diaLogError();
      debugPrint('confirmTransaction error: $error');
      debugPrint('$trace');
    }
  }

  void diaLogErrorWalletNotEnough() {
    final amountSettingDouble = AppUtil.formatMoney(
      double.parse(sl<LocalClient>().amountSetting),
    );
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icWarning,
        width: 68.w,
        height: 68.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'Số dư trong ví không đủ'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Ví phải duy trì số dư tối thiểu $amountSettingDouble. Nếu số dư nhỏ hơn $amountSettingDouble, bạn sẽ không thể nhận đơn mới."
            .tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Tiếp tục',
      typeButtonLeft: AppButtonType.remove,
      typeButtonRight: AppButtonType.outline,
      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
        Get.back();
      },
      actionRight: () {
        Get.back();
        actionWithdrawBottomSheet();
      },
    );
  }

  void diaLogError() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icWarning,
        width: 68.w,
        height: 68.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'confirm_failed'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Giao dịch Rút tiền thất bại".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'retry'.tr,
      titleRight: 'skip'.tr,
      typeButtonLeft: AppButtonType.remove,

      outlineColor: AppColors.warningColor,
      actionLeft: () {
        actionWithdraw();
        Get.back();
      },
      actionRight: () {
        Get.back();
        Get.back();
      },
    );
  }

  void diaLogWithdraw() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      title: Text(
        'Rút tiền thành công'.tr,
        style: AppTextStyles.bold20().copyWith(
          color: AppColors.grayscaleColor80,
        ),
        textAlign: TextAlign.center,
      ),
      description: Text.rich(
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            TextSpan(
              text: "Rút tiền thành công ".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: " ",
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: AppUtil.formatMoney(
                double.tryParse(amount.value?.replaceAll(",", "") ?? '0') ?? 0,
              ),
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text:
                  selectedWithDrawType.value == MyWalletType.walletIn
                      ? " vào ví tiền mặt".tr
                      : " vào ví chiết khấu".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(text: "\n${"Số dư hiện tại ".tr}"),
            TextSpan(
              text: AppUtil.formatMoney(
                double.tryParse(
                      selectedWithDrawType.value == MyWalletType.walletIn
                          ? WalletDB()
                                  .currentWallet()
                                  ?.withdrawableBalance
                                  ?.toString() ??
                              '0'
                          : WalletDB()
                                  .currentWalletUser()
                                  ?.wallet
                                  ?.toString() ??
                              '0',
                    ) ??
                    0,
              ),
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ],
        ),
      ),
      titleLeft: 'Rút Thêm'.tr,
      titleRight: 'Về trang chủ'.tr,
      typeButtonLeft: AppButtonType.nomal,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
        Get.back();
      },
      actionRight: () {
        Get.offAllNamed(Routes.root);
      },
    );
  }

  void diaLogWithdrawPending() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      title: Text(
        'Lệnh chờ duyệt'.tr,
        style: AppTextStyles.bold20().copyWith(
          color: AppColors.grayscaleColor80,
        ),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Lệnh của bạn đang được xử lý.\n Vui lòng đợi trong giây lát.".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'Về ví của tôi'.tr,
      typeButtonLeft: AppButtonType.nomal,
      outlineColor: AppColors.primaryColor,
      isShowRight: false,
      actionLeft: () {
        Get.back();
        Get.back();
        Get.back();
        Get.back();
      },
    );
  }
}

void showLoading() {
  DialogUtil.showDialogLoading(
    Get.context!,
    title: 'confirm_transaction'.tr,
    description: 'confirm_withdraw_description'.tr,
  );
}
