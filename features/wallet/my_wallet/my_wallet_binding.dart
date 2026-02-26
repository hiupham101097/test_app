import 'package:get/get.dart';
import 'my_wallet_controller.dart';

class MyWalletBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyWalletController());
  }
}
