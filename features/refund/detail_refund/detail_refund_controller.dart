import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class DetailRefundController extends GetxController {
  final ApiClient client = ApiClient();
  final List<String> listTab = ["Đơn mới", "Đã gửi", "Kết quả"];
  final RxInt currentTab = 0.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final order = OrderModel().obs;
  final approveDate = ''.obs;
  final processRefund = ''.obs;
  final successDate = ''.obs;

  @override
  void onInit() {
    super.onInit();
    processRefund.value = DateTime.now().toString();
    if (Get.arguments != null && Get.arguments['order'] != null) {
      order.value = Get.arguments['order'];
      getProcessRefund();
    }
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> getProcessRefund() async {
    EasyLoading.show();
    await client
        .getProcessRefund(idOder: order.value.orderId)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            approveDate.value = response.data["resultApi"]["approveDate"];
            successDate.value = response.data["resultApi"]["successDate"];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void onTapTab(int index) {
    currentTab.value = index;
  }
}
