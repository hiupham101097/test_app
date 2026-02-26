import 'dart:convert';

import 'package:merchant/commons/types/status_oder_enum.dart';
import 'dart:async';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/meta_data_model.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class MyOrderController extends GetxController {
  final ApiClient client = ApiClient();
  final selectedTab = StatusOrderEnum.PENDING.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final orderData = <OrderModel>[].obs;
  final metaData = MetaDataModel().obs;
  final loading = false.obs;
  final page = 1.obs;
  final showSelectedItem = false.obs;
  final selectedOrderData = <OrderModel>[].obs;

  Timer? _autoClearTimer;

  @override
  void onInit() {
    super.onInit();
    eventBus.on<OderEvent>().listen((event) {
      fetchData();
    });
    fetchData();
  }

  @override
  void onClose() {
    _autoClearTimer?.cancel();
    super.onClose();
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
    final store = StoreDB().currentStore() ?? StoreModel();
    final data = [
      {
        "key": "orderStatus",
        "value":
            selectedTab.value.name.toUpperCase() == "FAILED"
                ? ["CANCELED", "FAILED", 'DRIVER_CANCELED']
                : selectedTab.value.name.toUpperCase(),
      },
      {"key": "system", "value": store.system},
    ];
    final optionExtend = jsonEncode(data);
    await client
        .fetchListMyOrders(status: optionExtend)
        .then((response) {
          EasyLoading.dismiss();
          loading.value = false;
          if (response.data["resultApi"]["data"] != null) {
            orderData.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            metaData.value = MetaDataModel.fromJson(response.data["resultApi"]);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          loading.value = false;
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPage() async {
    final nextPage = page.value + 1;
    final store = StoreDB().currentStore() ?? StoreModel();
    final data = [
      {
        "key": "orderStatus",
        "value":
            selectedTab.value.name.toUpperCase() == "FAILED"
                ? ["CANCELED", "FAILED", 'DRIVER_CANCELED']
                : selectedTab.value.name.toUpperCase(),
      },
      {"key": "system", "value": store.system},
    ];
    final optionExtend = jsonEncode(data);
    await client
        .fetchListMyOrders(status: optionExtend, page: nextPage, limit: 20)
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
    controller.finishLoad(noMore: orderData.length >= metaData.value.total);
  }

  Future<void> onConfirmAllOrders({required String system}) async {
    await client
        .confirmAllOrders(
          system: system,
          data:
              selectedOrderData.isNotEmpty
                  ? selectedOrderData
                      .map((e) => {"orderId": e.orderId, "userId": e.userId})
                      .toList()
                  : orderData
                      .map((e) => {"orderId": e.orderId, "userId": e.userId})
                      .toList(),
        )
        .then((response) {
          if (response.statusCode == 200) {
            // DialogUtil.showSuccessMessage('Xác nhận đơn hàng thành công'.tr);
            eventBus.fire(OderEvent());
            onClearSelectedItem();
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void onSelectItem(OrderModel item) {
    item.selected.value = !item.selected.value;
    if (item.selected.value) {
      selectedOrderData.add(item);
    } else {
      selectedOrderData.remove(item);
    }
  }

  void onClearSelectedItem() {
    showSelectedItem.value = false;
    selectedOrderData.clear();
    for (var element in orderData) {
      element.selected.value = false;
    }
    orderData.refresh();
  }

  void onChangeTab(StatusOrderEnum status) {
    if (selectedTab.value == status) return;
    selectedTab.value = status;
    orderData.clear();
    metaData.value = MetaDataModel();
    fetchData();
  }

  void onLongPress() {
    showSelectedItem.value = !showSelectedItem.value;
  }
}
