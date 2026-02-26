import 'package:get/get.dart';
import 'create_food_controller.dart';

class CreateFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CreateFoodController>(() => CreateFoodController());
  }
}
