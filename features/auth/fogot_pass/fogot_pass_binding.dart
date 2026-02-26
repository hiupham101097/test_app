import 'package:get/get.dart';
import 'fogot_pass_controller.dart';

class FogotPassBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FogotPassController>(() => FogotPassController());
  }
}
