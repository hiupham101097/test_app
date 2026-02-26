import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/utils/error_util.dart';

class DetailOrderStatisticsController extends GetxController {
  final ApiClient client = ApiClient();
  final type = ''.obs;
  final date = ''.obs;
  final dateType = ''.obs;
  final orderData = <OrderModel>[].obs;
  final total = 0.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final loading = false.obs;
  final page = 1.obs;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments['type'] != null) {
      type.value = Get.arguments['type'];
    }
    if (Get.arguments != null && Get.arguments['date'] != null) {
      date.value = Get.arguments['date'];
    }
    if (Get.arguments != null && Get.arguments['dateType'] != null) {
      dateType.value = Get.arguments['dateType'];
    }
    fetchData();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    fetchData();
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> fetchData() async {
    EasyLoading.show();
    loading.value = true;
    await client
        .fetchDetailOrderStatistics(
          type: type.value.toUpperCase(),
          date: date.value,
          dateType: dateType.value,
        )
        .then((response) {
          loading.value = false;
          EasyLoading.dismiss();
          if (response.data["resultApi"]["data"] != null) {
            orderData.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            total.value = response.data["resultApi"]["total"];
          }
        })
        .catchError((error, trace) {
          loading.value = false;
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPage() async {
    final nextPage = page.value + 1;

    await client
        .fetchDetailOrderStatistics(
          type: type.value.toUpperCase(),
          date: date.value,
          dateType: dateType.value,
          page: nextPage,
          limit: 20,
        )
        .then((response) async {
          if (response.data['resultApi']['data'] != null) {
            orderData.addAll(
              (response.data['resultApi']['data'] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );

            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: orderData.length >= total.value);
  }
}
