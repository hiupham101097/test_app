import 'package:get/get.dart';
import 'package:merchant/features/voucher_discount/voucher_discount_controller.dart';

class VoucherDiscountBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(VoucherDiscountController());
  }
}
