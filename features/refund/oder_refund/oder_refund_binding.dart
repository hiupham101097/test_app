import 'package:get/get.dart';
import 'oder_refund_controller.dart';

class OrderRefundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OrderRefundController>(() => OrderRefundController());
  }
}
