import 'package:get/get.dart';
import 'info_store_controller.dart';

class InfoStoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoStoreController>(() => InfoStoreController());
  }
}
