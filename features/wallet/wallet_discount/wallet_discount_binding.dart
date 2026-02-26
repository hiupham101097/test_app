import 'package:get/get.dart';
import 'wallet_discount_controller.dart';

class WalletDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WalletDiscountController>(() => WalletDiscountController());
  }
}
