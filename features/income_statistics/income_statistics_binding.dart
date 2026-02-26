import 'package:get/get.dart';
import 'income_statistics_controller.dart';

class IncomeStatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(IncomeStatisticsController());
  }
}
