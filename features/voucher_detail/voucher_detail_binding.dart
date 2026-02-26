import 'package:get/get.dart';
import 'voucher_detail_controller.dart';

class VoucherDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoucherDetailController());
  }
}
