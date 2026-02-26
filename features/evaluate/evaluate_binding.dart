import 'package:get/get.dart';
import 'evaluate_controller.dart';

class EvaluateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EvaluateController>(() => EvaluateController());
  }
}
