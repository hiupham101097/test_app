import 'package:get/get.dart';
import 'use_voucher_controller.dart';

class UseVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UseVoucherController>(() => UseVoucherController());
  }
}
