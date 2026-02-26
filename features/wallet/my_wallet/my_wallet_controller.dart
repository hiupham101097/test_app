import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/utils/error_util.dart';

enum MyWalletType { discountWallet, walletIn }

class MyWalletController extends GetxController {
  final ApiClient client = ApiClient();
  final myWallet = WalletModel().obs;
  final walletUser = WalletUserModel().obs;
  final totalPending = 0.0.obs;
  final moneyDiscount = ''.obs;
  final EasyRefreshController controller = EasyRefreshController();

  @override
  void onInit() {
    super.onInit();
    eventBus.on<WalletStoreRefreshEvent>().listen((event) {
      myWallet.value = WalletDB().currentWallet() ?? WalletModel();
    });
    eventBus.on<WalletUserRefreshEvent>().listen((event) {
      walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    });
    walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    myWallet.value = WalletDB().currentWallet() ?? WalletModel();
    refreshWallet();
    fetchData();
  }

  void refreshWallet() {
    WalletService().getWalletUser();
    WalletService().getWallet(
      phone: StoreDB().currentStore()?.phone ?? '',
      store: StoreDB().currentStore() ?? StoreModel(),
    );
  }

  Future<void> fetchData() async {
    await client
        .fetchdeposit()
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            moneyDiscount.value = response.data["resultApi"]["data"];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    refreshWallet();
    fetchData();
    controller.resetLoadState();
    controller.finishRefresh();
  }
}
