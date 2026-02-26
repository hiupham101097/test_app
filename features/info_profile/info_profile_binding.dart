import 'package:get/get.dart';
import 'info_profile_controller.dart';

class InfoProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InfoProfileController>(() => InfoProfileController());
  }
}
