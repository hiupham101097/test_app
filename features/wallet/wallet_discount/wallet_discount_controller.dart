import 'dart:convert';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/transaction_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';

class WalletDiscountController extends GetxController {
  final ApiClient client = ApiClient();
  final walletUser = WalletUserModel().obs;
  final total = 0.obs;
  final listTransaction = <TransactionModel>[].obs;
  final EasyRefreshController controller = EasyRefreshController();
  final loading = false.obs;
  final page = 1.obs;
  final totalPage = 0.obs;

  @override
  void onInit() async {
    super.onInit();
    eventBus.on<WalletUserRefreshEvent>().listen((event) {
      walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
      Future.delayed(Duration(seconds: 3), () async {
        getHistoryTransaction();
      });
    });
    walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    getHistoryTransaction();
  }

  void refreshWallet() {
    WalletService().getWalletUser();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    getHistoryTransaction();
    refreshWallet();
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> getHistoryTransaction() async {
    EasyLoading.show();
    await client
        .getHistoryWallet()
        .then((response) async {
          if (response.statusCode == 200) {
            if (response.data['resultApi'] != null) {
              listTransaction.assignAll(
                (response.data['resultApi']['listData'] as List)
                    .map(
                      (e) =>
                          TransactionModel.fromJson(e as Map<String, dynamic>),
                    )
                    .toList(),
              );
              total.value = response.data['resultApi']['total'];
            }
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

    await client
        .getHistoryWallet(pageCurrent: nextPage, pageSize: 20)
        .then((response) async {
          if (response.data['resultApi']['listData'] != null) {
            listTransaction.addAll(
              (response.data['resultApi']['listData'] as List)
                  .map(
                    (e) => TransactionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );

            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listTransaction.length >= total.value);
  }
}
