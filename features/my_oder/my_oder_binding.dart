import 'package:get/get.dart';
import 'my_oder_controller.dart';

class MyOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MyOrderController());
  }
}
