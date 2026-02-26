import 'package:merchant/features/splash/splash_controller.dart';
import 'package:get/get.dart';
import 'setting_time_controller.dart';

class SettingTimeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingTimeController>(() => SettingTimeController());
  }
}
