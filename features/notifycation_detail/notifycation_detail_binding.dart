import 'package:get/get.dart';
import 'notifycation_detail_controller.dart';

class NotifycationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(NotifycationDetailController());
  }
}
