import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ConfirmConvertController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode moneyFocusNode = FocusNode();
  final amount = Rxn<String>();
  final time = Rxn<String>();
  final isSuccess = false.obs;
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['amount'] != null) {
      amount.value = Get.arguments['amount'];
    }
    if (Get.arguments != null && Get.arguments['time'] != null) {
      time.value = Get.arguments['time'];
    }
  }

  Future<void> confirmConvert() async {
    EasyLoading.show();
    final data = {
      "Amount": int.tryParse(amount.value ?? '0'),
      "WalletId": WalletDB().currentWallet()?.walletId ?? '',
    };
    await client
        .confirmConvert(data: data)
        .then((response) async {
          if (response.statusCode == 200) {
            await WalletService().getWallet(
              phone: StoreDB().currentStore()?.phone ?? '',
              store: StoreDB().currentStore() ?? StoreModel(),
            );
            WalletService().getWalletUser();
            isSuccess.value = true;
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
