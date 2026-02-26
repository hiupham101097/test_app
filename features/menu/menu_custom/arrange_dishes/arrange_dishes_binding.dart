import 'package:get/get.dart';
import 'arrange_dishes_controller.dart';

class ArrangeDishesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArrangeDishesController>(() => ArrangeDishesController());
  }
}
