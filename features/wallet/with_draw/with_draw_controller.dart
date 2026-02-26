import 'dart:convert';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_bank_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class WithDrawController extends GetxController {
  final ApiClient client = ApiClient();
  final TextEditingController moneyController = TextEditingController();
  final FocusNode moneyFocusNode = FocusNode();
  final isSelectedMoney = 10.obs;
  final selectedBank = WalletBankModel().obs;
  final RxList<String> listMoney =
      ['10,000', '20,000đ', '50,000đ', '100,000đ', '200,000đ', '500,000đ'].obs;
  final walletModel = WalletModel().obs;
  final walletUser = WalletUserModel().obs;
  final storeModel = StoreModel().obs;
  final formKey = GlobalKey<FormState>();
  final RxBool isValid = false.obs;
  final selectedWithDrawType = MyWalletType.walletIn.obs;
  @override
  void onInit() {
    super.onInit();
    eventBus.on<BankEvent>().listen((event) {
      walletModel.value = WalletDB().currentWallet() ?? WalletModel();
      walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    });
    walletModel.value = WalletDB().currentWallet() ?? WalletModel();
    walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    storeModel.value = StoreDB().currentStore() ?? StoreModel();
    moneyController.addListener(() {
      validate();
    });
    selectedBank.listen((value) {
      validate();
    });
    if (Get.arguments != null) {
      selectedWithDrawType.value = Get.arguments['type'];
    }
  }

  Future<void> deleteBank(String walletBankId) async {
    EasyLoading.show();
    final headers = await WalletService().buildWalletHeaders();
    await client
        .deleteBank(headers: headers, walletBankId: walletBankId)
        .then((response) async {
          if (response.statusCode == 200) {
            await WalletService().getWallet(
              phone: storeModel.value.phone,
              store: storeModel.value,
            );
            walletModel.value = WalletDB().currentWallet() ?? WalletModel();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void withdraw() async {
    Get.toNamed(
      Routes.confirmTransaction,
      arguments: {
        'amount': moneyController.text.replaceAll(",", ""),
        'selectedBank': selectedBank.value,
        'type': selectedWithDrawType.value,
      },
    );
  }

  void validate() {
    if (moneyController.text.isEmpty ||
        selectedBank.value.walletBankId == null) {
      isValid.value = false;
    } else {
      isValid.value = true;
    }
  }

  void diaLogDelete(String walletBankId) {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        'delete_information'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "confirm_delete_information".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'close'.tr,
      titleRight: 'confirm'.tr,
      typeButtonLeft: AppButtonType.remove,
      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        deleteBank(walletBankId);
      },
    );
  }

  String? validateWithdraw(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredWithdraw".tr;
    }
    if (double.tryParse(value!.replaceAll(",", ""))! >
        (selectedWithDrawType.value == MyWalletType.walletIn
            ? walletModel.value.withdrawableBalance!
            : walletUser.value.wallet!)) {
      return "withdraw_amount_must_be_less_than_cash_balance".tr;
    }
    if (double.tryParse(value!.replaceAll(",", ""))! < 100000 &&
        double.tryParse(value!.replaceAll(",", ""))! > 500000000) {
      return "withdraw_amount_must_be_greater_than_100000".tr;
    }

    return null;
  }
}
