import 'package:get/get.dart';
import 'detail_transaction_controller.dart';

class DetailTransactionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailTransactionController>(
      () => DetailTransactionController(),
    );
  }
}
