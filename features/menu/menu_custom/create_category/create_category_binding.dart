import 'package:get/get.dart';
import 'create_category_controller.dart';

class CreateCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateCategoryController>(() => CreateCategoryController());
  }
}
