import 'package:merchant/features/menu/view/index_controller.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/list_menu_controller.dart';
import 'package:merchant/features/menu/menu_options/list_options/list_options_menu_controller.dart';
import 'package:get/get.dart';

class IndexBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ListOptionsMenuController>(() => ListOptionsMenuController());

    Get.lazyPut<IndexController>(() => IndexController());
    Get.lazyPut<ListMenuController>(
      () => ListMenuController(),
      tag: 'listMenu-default',
    );
  }
}
