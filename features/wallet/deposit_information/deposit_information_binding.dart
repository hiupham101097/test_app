import 'package:get/get.dart';
import 'deposit_information_controller.dart';

class DepositInformationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DepositInformationController>(
      () => DepositInformationController(),
    );
  }
}
