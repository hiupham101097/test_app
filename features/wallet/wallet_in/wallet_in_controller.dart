import 'dart:convert';
import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/transaction_wallet_in_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';

import '../../../domain/data/models/store_model.dart';

class WalletInController extends GetxController {
  final ApiClient client = ApiClient();
  final total = 0.obs;
  final listTransaction = <TransactionWalletInModel>[].obs;
  final EasyRefreshController controller = EasyRefreshController();
  final loading = false.obs;
  final walletUser = WalletModel().obs;
  StreamSubscription? _walletStoreRefreshSub;

  @override
  void onInit() async {
    super.onInit();
    _walletStoreRefreshSub = eventBus.on<WalletStoreRefreshEvent>().listen((
      event,
    ) {
      walletUser.value = WalletDB().currentWallet() ?? WalletModel();
      getHistoryWalletIn();
    });
    walletUser.value = WalletDB().currentWallet() ?? WalletModel();
    getHistoryWalletIn();
  }

  @override
  void onClose() {
    super.onClose();
    _walletStoreRefreshSub?.cancel();
    controller.dispose();
  }

  void refreshWallet() {
    WalletService().getWallet(
      phone: StoreDB().currentStore()?.phone ?? '',
      store: StoreDB().currentStore() ?? StoreModel(),
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    listTransaction.clear();
    refreshWallet();
    if (!isClosed) {
      controller.resetLoadState();
      controller.finishRefresh();
    }
  }

  Future<void> getHistoryWalletIn() async {
    try {
      EasyLoading.show();
      final headers = await WalletService().buildWalletHeaders();
      await client
          .getHistoryWalletIn(
            headers: headers,
            walletId: WalletDB().currentWallet()?.walletId ?? '',
            skip: 0,
            limit: 10,
          )
          .then((response) async {
            if (response.statusCode == 200) {
              if (response.data['resultApi'] != null) {
                final data = jsonDecode(response.data['resultApi']['payload']);
                listTransaction.assignAll(
                  (data as List)
                      .map(
                        (e) => TransactionWalletInModel.fromJson(
                          e as Map<String, dynamic>,
                        ),
                      )
                      .toList(),
                );
                total.value = response.data['total'];
                if (listTransaction.length < 10 && !isClosed) {
                  controller.finishLoad(noMore: true);
                }
              }
            }
            EasyLoading.dismiss();
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    } catch (error, trace) {
      EasyLoading.dismiss();
      ErrorUtil.catchError(error, trace);
    } finally {
      EasyLoading.dismiss();
    }
  }

  Future<void> onLoadingPage() async {
    final skip = listTransaction.length;
    final headers = await WalletService().buildWalletHeaders();
    await client
        .getHistoryWalletIn(
          headers: headers,
          walletId: WalletDB().currentWallet()?.walletId ?? '',
          skip: skip,
          limit: 10,
        )
        .then((response) async {
          if (response.statusCode == 200) {
            if (response.data['resultApi'] != null) {
              final data = jsonDecode(response.data['resultApi']['payload']);
              final newData =
                  (data as List)
                      .map(
                        (e) => TransactionWalletInModel.fromJson(
                          e as Map<String, dynamic>,
                        ),
                      )
                      .toList();
              listTransaction.addAll(newData);
              if (!isClosed) {
                controller.finishLoad(noMore: (newData.length < 10));
              }
            }
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
