import 'dart:convert';

import 'package:get/get.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/home_page/home.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/security_util.dart';
import 'package:flutter/services.dart';

class WalletService {
  ApiClient apiClient = ApiClient();
  Future<Map<String, String>> buildWalletHeaders() async {
    final serverTimestamp = await getRealTime();
    final String securityKey = AppConstants.securityKey;
    final String clientId = AppConstants.clientID;

    // final String securityKey = AppConstants.securityKeyDev;
    // final String clientId = AppConstants.clientIDDev;
    final publicKeyPem = await rootBundle.loadString(
      "assets/private_key/key-wallet.pem",
      // "assets/private_key/key-wallet_dev.pem",
    );

    final timestampMs = DateTime.parse(serverTimestamp).millisecondsSinceEpoch;
    final cipherRaw = "$timestampMs#$clientId";
    final rawToSign = "$cipherRaw#$securityKey";
    final signature = SecurityUtil.encryptRSA(rawToSign, publicKeyPem);

    return {
      'Content-Type': 'application/json',
      'X-Cipher': base64Encode(utf8.encode(cipherRaw)),
      'X-Signature': signature,
    };
  }

  Future<String> getRealTime() async {
    try {
      final response = await apiClient.getRealTime();
      if (response.data != null) {
        final timestamp = response.data?['utcNow']?.toString() ?? '';
        return timestamp;
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<void> getWallet({
    required String phone,
    required StoreModel store,
  }) async {
    final headers = await buildWalletHeaders();
    await apiClient
        .getByPhone(headers: headers, phone: phone)
        .then((response) async {
          if (response.statusCode == 200) {
            final data = jsonDecode(response.data['resultApi']['payload']);
            if (data != null) {
              final wallet = WalletModel.fromJson(data);
              await WalletDB().save(wallet);
            } else {
              await createWallet(store);
            }
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> getWalletUser() async {
    await apiClient
        .getWalletUser()
        .then((response) async {
          if (response.statusCode == 200 &&
              response.data['resultApi'] != null) {
            final walletUser = WalletUserModel.fromJson(
              response.data['resultApi'],
            );
            await WalletDB().saveWalletUser(walletUser);
            final amountSetting = sl<LocalClient>().amountSetting;
            if (walletUser.wallet != null &&
                walletUser.wallet! < int.parse(amountSetting)) {
              final store = StoreDB().currentStore() ?? StoreModel();
              if (store.closeOpenStatus == AppConstants.open) {
                Get.find<HomeController>().toggleStatus();
              }
              return;
            }
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> createWallet(StoreModel store) async {
    final headers = await buildWalletHeaders();
    final time = await getRealTime();
    final payload = {
      "fullName": store.name,
      "email": store.ownerEmail,
      "phoneNumber": store.phone,
      "bankList": [],
    };

    final base64Encrypted = SecurityUtil.encryptAES(
      payload,
      DateTime.parse(time).millisecondsSinceEpoch,
      AppConstants.securityKey,
    );
    await apiClient
        .createWallet(headers: headers, data: base64Encrypted)
        .then((response) async {
          if (response.statusCode == 200 && response.data['status'] == 200) {
            final data = jsonDecode(response.data['resultApi']['payload']);
            final wallet = WalletModel.fromJson(data[0]);
            await WalletDB().save(wallet);
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }
}
