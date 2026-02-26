import 'package:get/get.dart';
import 'package:merchant/features/menu/menu_options/list_options/list_options_menu_controller.dart';

class ListOptionsMenuBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListOptionsMenuController());
  }
}
