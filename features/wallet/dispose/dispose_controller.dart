import 'dart:async';
import 'dart:convert';

import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/channel_model.dart';
import 'package:merchant/domain/data/models/dispose_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/security_util.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class DisposeController extends GetxController {
  final ApiClient client = ApiClient();
  final TextEditingController moneyController = TextEditingController();
  final FocusNode moneyFocusNode = FocusNode();
  final isSelectedMoney = 10.obs;
  final RxList<String> listMoney =
      ['10,000', '20,000', '50,000', '100,000', '200,000', '500,000'].obs;
  final RxBool isValid = false.obs;
  final channelList = <ChannelModel>[].obs;
  final selectedChannel = ChannelModel().obs;
  final myWallet = WalletModel().obs;
  final formKey = GlobalKey<FormState>();
  final loading = false.obs;
  @override
  void onInit() {
    super.onInit();
    getListChanel();
    eventBus.on<WalletUserRefreshEvent>().listen((event) {
      myWallet.value = WalletDB().currentWallet() ?? WalletModel();
    });
    moneyController.addListener(() {
      validate();
    });
    selectedChannel.listen((value) {
      validate();
    });
  }

  Future<void> getListChanel() async {
    EasyLoading.show();
    final headers = await WalletService().buildWalletHeaders();

    await client
        .getListChanel(headers: headers)
        .then((response) {
          if (response.data != null) {
            final channel = response.data['resultApi']['payload'];
            final channelData = jsonDecode(channel);
            print('channelData: $channelData');
            channelList.value =
                (channelData as List)
                    .map((e) => ChannelModel.fromJson(e))
                    .where((e) => e.brandCode == 'PBP')
                    .toList();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> confirmTransaction() async {
    try {
      EasyLoading.show();
      loading.value = true;
      final headers = await WalletService().buildWalletHeaders();
      final time = await WalletService().getRealTime();

      final payloadDeposit = {
        "walletId": WalletDB().currentWallet()?.walletId ?? '',
        "totalPrice": int.tryParse(moneyController.text.replaceAll(",", "")),
        "brandId": selectedChannel.value.brandId ?? '',
        "channelType": "Mobile",
      };

      final base64Encrypted = SecurityUtil.encryptAES(
        payloadDeposit,
        DateTime.parse(time).millisecondsSinceEpoch,
        AppConstants.securityKey,
      );

      await client
          .deposit(headers: headers, data: base64Encrypted)
          .then((response) async {
            if (response.statusCode == 200 && response.data['status'] == 200) {
              final transaction = response.data['resultApi']['payload'];
              final transactionData = jsonDecode(transaction);

              final disposeModel = DisposeModel.fromJson(transactionData);
              if (disposeModel.transactionId != null) {
                Get.toNamed(
                  Routes.depositInformation,
                  arguments: {
                    'transactionData': disposeModel,
                    'walletId': WalletDB().currentWallet()?.walletId,
                  },
                );
              }
            } else {
              DialogUtil.showErrorMessage(response.data['message']);
            }
            loading.value = false;
            EasyLoading.dismiss();
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            loading.value = false;
            ErrorUtil.catchError(error, trace);
          });
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
      EasyLoading.dismiss();
      loading.value = false;
    } finally {
      EasyLoading.dismiss();
      loading.value = false;
    }
  }

  void validate() {
    if (moneyController.text.isEmpty || selectedChannel.value.brandId == null) {
      isValid.value = false;
    } else {
      isValid.value = true;
    }
  }

  String? validateDisposeMoney(String? value) {
    final cleaned = value?.replaceAll(",", "");
    final amount = int.tryParse(cleaned ?? '');
    print('amount: $amount');
    if (Validator.isNullOrEmpty(value)) {
      return "requiredWithdraw".tr;
    }
    if (amount != null && amount < 10000) {
      return "withdraw_amount_must_be_greater_than_100000".tr;
    }
    if (amount != null && amount > 299000000) {
      return "Rút số tiền tối đa là 299.000.000đ".tr;
    }

    return null;
  }
}
