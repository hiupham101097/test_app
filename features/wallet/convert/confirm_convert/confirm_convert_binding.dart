import 'package:get/get.dart';
import 'confirm_convert_controller.dart';

class ConfirmConvertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConfirmConvertController>(() => ConfirmConvertController());
  }
}
