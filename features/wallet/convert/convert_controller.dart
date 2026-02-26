import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/wallet_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ConvertController extends GetxController {
  final ApiClient client = ApiClient();
  final TextEditingController moneyEditingController = TextEditingController();
  final FocusNode moneyFocusNode = FocusNode();
  final RxInt selectedRadio = 2.obs;
  final TextEditingController allMoneyEditingController =
      TextEditingController();
  final FocusNode allMoneyFocusNode = FocusNode();
  final formKey = GlobalKey<FormState>();
  final walletModel = WalletModel().obs;
  final walletUser = WalletUserModel().obs;
  @override
  void onInit() {
    super.onInit();
    eventBus.on<WalletUserRefreshEvent>().listen((event) {
      walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    });
    eventBus.on<WalletStoreRefreshEvent>().listen((event) {
      walletModel.value = WalletDB().currentWallet() ?? WalletModel();
    });
    walletModel.value = WalletDB().currentWallet() ?? WalletModel();
    walletUser.value = WalletDB().currentWalletUser() ?? WalletUserModel();
    allMoneyEditingController.text = AppUtil.formatMoney(
      double.tryParse(
            walletModel.value.withdrawableBalance?.toString() ?? '0',
          ) ??
          0,
    );
  }

  void onAction() async {
    Get.toNamed(
      Routes.confirmConvert,
      arguments: {
        'amount':
            selectedRadio.value == 0
                ? moneyEditingController.text.replaceAll(",", "")
                : allMoneyEditingController.text.replaceAll(
                  RegExp(r'[,đ]'),
                  "",
                ),
        'time': await WalletService().getRealTime(),
      },
    );
  }
}
