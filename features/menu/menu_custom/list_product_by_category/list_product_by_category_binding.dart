import 'package:get/get.dart';
import 'list_product_by_category_controller.dart';

class ListProductByCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(ListProductByCategoryController());
  }
}
