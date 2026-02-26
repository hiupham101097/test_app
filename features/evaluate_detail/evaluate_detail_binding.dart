import 'package:get/get.dart';
import 'evaluate_detail_controller.dart';

class EvaluateDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EvaluateDetailController>(() => EvaluateDetailController());
  }
}
