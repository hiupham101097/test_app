import 'package:get/get.dart';
import 'dispose_controller.dart';

class DisposeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DisposeController>(() => DisposeController());
  }
}
