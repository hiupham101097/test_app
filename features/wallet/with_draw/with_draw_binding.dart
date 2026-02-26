import 'package:get/get.dart';
import 'with_draw_controller.dart';

class WithDrawBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WithDrawController>(() => WithDrawController());
  }
}
