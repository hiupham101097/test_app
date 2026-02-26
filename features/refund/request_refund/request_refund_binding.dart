import 'package:get/get.dart';
import 'request_refund_controller.dart';

class RequestRefundBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestRefundController>(() => RequestRefundController());
  }
}
