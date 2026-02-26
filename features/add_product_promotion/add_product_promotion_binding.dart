import 'package:get/get.dart';
import 'add_product_promotion_controller.dart';

class AddProductPromotionBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AddProductPromotionController());
  }
}
