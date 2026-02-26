import 'package:get/get.dart';
import 'detail_order_statistics_controller.dart';

class DetailOrderStatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DetailOrderStatisticsController());
  }
}
