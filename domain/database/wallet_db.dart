import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:hive/hive.dart';
import 'package:merchant/constants/app_constants.dart';

import '../client/event_service.dart';

class WalletDB {
  WalletModel? currentWallet() {
    final boxWallet = Hive.box<WalletModel>(AppConstants.BOX_WALLET);
    return boxWallet.get(0);
  }

  Future<WalletModel> save(WalletModel walletModel) async {
    final boxWallet = Hive.box<WalletModel>(AppConstants.BOX_WALLET);
    await boxWallet.put(0, walletModel);
    eventBus.fire(WalletStoreRefreshEvent());
    return boxWallet.get(0)!;
  }

  Future<void> clear() async {
    final boxWallet = Hive.box<WalletModel>(AppConstants.BOX_WALLET);
    await boxWallet.delete(0);
    await boxWallet.clear();
  }

  WalletUserModel? currentWalletUser() {
    final boxWallet = Hive.box<WalletUserModel>(AppConstants.BOX_WALLET_USER);
    return boxWallet.get(0);
  }

  Future<WalletUserModel> saveWalletUser(WalletUserModel walletModel) async {
    final boxWallet = Hive.box<WalletUserModel>(AppConstants.BOX_WALLET_USER);
    await boxWallet.put(0, walletModel);
    eventBus.fire(WalletUserRefreshEvent());
    return boxWallet.get(0)!;
  }

  Future<void> clearWalletUser() async {
    final boxWallet = Hive.box<WalletUserModel>(AppConstants.BOX_WALLET_USER);
    await boxWallet.delete(0);
    await boxWallet.clear();
  }
}
