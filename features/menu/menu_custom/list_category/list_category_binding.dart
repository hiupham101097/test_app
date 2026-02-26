import 'package:get/get.dart';
import 'list_category_controller.dart';

class ListCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListCategoryController());
  }
}
