import 'package:get/get.dart';
import 'list_menu_controller.dart';

class ListMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListMenuController());
  }
}
