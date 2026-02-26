import 'package:get/get.dart';
import 'wallet_in_controller.dart';

class WalletInBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletInController>(() => WalletInController());
  }
}
