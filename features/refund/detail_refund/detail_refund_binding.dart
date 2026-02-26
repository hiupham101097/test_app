import 'package:get/get.dart';
import 'detail_refund_controller.dart';

class DetailRefundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailRefundController>(() => DetailRefundController());
  }
}
