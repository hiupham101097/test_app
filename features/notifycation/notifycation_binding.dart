import 'package:get/get.dart';
import 'notifycation_controller.dart';

class NotifycationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NotifycationController>(() => NotifycationController());
  }
}
