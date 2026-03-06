import 'package:get/get.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_controller.dart';

class CreateVoucherBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CreateVoucherController());
  }
}
