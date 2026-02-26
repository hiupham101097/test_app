import 'package:get/get.dart';
import 'detail_convert_controller.dart';

class DetailConvertBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailConvertController>(() => DetailConvertController());
  }
}
