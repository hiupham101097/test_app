import 'dart:convert';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/bank_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/add_bank/view/bottomsheet_bank.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/security_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class AddBankController extends GetxController {
  final ApiClient client = ApiClient();
  final selectedBank = Rx<BankModel?>(null);
  final branchFocusNode = FocusNode();
  final numberAccountFocusNode = FocusNode();
  final nameAccountFocusNode = FocusNode();
  final branchController = TextEditingController();
  final numberAccountController = TextEditingController();
  final nameAccountController = TextEditingController();
  final bankList = RxList<BankModel>();
  final formKey = GlobalKey<FormState>();
  final storeModel = StoreModel().obs;
  final walletModel = WalletModel().obs;
  final total = 0.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final page = 1.obs;
  @override
  void onInit() {
    super.onInit();
    storeModel.value = StoreDB().currentStore() ?? StoreModel();
    walletModel.value = WalletDB().currentWallet() ?? WalletModel();
    getListBank();
  }

  Future<void> getListBank() async {
    try {
      EasyLoading.show();
      final headers = await WalletService().buildWalletHeaders();
      await client
          .getListBank(headers: headers)
          .then((response) {
            if (response.data != null) {
              final bank = response.data['resultApi']['payload'];
              final bankData = jsonDecode(bank);
              bankList.value =
                  (bankData as List).map((e) => BankModel.fromJson(e)).toList();
              total.value = response.data['total'];
              print(total.value);
            }
            EasyLoading.dismiss();
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    } catch (e) {
      EasyLoading.dismiss();
      ErrorUtil.catchError(e, StackTrace.current);
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    getListBank();
    page.value = 1;
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> addBank() async {
    EasyLoading.show();
    final headers = await WalletService().buildWalletHeaders();
    final time = await WalletService().getRealTime();
    final payload = {
      "walletId": walletModel.value.walletId,
      "bankId": selectedBank.value?.bankId,
      "accountHolderName": nameAccountController.text.trim(),
      "cardNumber": numberAccountController.text.trim(),
    };
    final base64Encrypted = SecurityUtil.encryptAES(
      payload,
      DateTime.parse(time).millisecondsSinceEpoch,
      AppConstants.securityKey,
    );

    await client
        .addBank(headers: headers, data: base64Encrypted)
        .then((response) async {
          if (response.statusCode == 200) {
            EasyLoading.dismiss();
            await WalletService().getWallet(
              phone: storeModel.value.phone,
              store: storeModel.value,
            );
            walletModel.value = WalletDB().currentWallet() ?? WalletModel();
            eventBus.fire(BankEvent());
            Get.back();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPage() async {
    final nextPage = page.value + 1;
    final headers = await WalletService().buildWalletHeaders();
    await client
        .getListBank(headers: headers, pageSize: 20, pageCurrent: nextPage)
        .then((response) async {
          if (response.statusCode == 200) {
            if (response.data['resultApi'] != null) {
              final data = jsonDecode(response.data['resultApi']['payload']);
              final newData =
                  (data as List)
                      .map((e) => BankModel.fromJson(e as Map<String, dynamic>))
                      .toList();
              bankList.addAll(newData);
              page.value = nextPage;
            }
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: bankList.length >= total.value);
  }

  void showBottomSheetBank() {
    Get.bottomSheet(
      BottomsheetBank(
        controller: controller,
        onRefresh: onRefresh,
        onLoading: onLoadingPage,
        total: total.value,
        dataCustom: bankList,
        onTap: (index) {
          selectedBank.value = index;
        },
        selectedItem: selectedBank.value ?? BankModel(),
        title: "Danh mục ngân hàng",
      ),
      isScrollControlled: true,
    );
  }
}
