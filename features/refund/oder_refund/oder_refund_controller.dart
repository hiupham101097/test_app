import 'dart:ui';

import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/order_group_month_model.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/features/refund/oder_refund/enum/refunt_tab_enum.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class OrderRefundController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiClient client = ApiClient();
  final Rx<StatusRefundEnum> currentTab = StatusRefundEnum.refund_pending.obs;
  final Rx<StatusComplaintEnum> currentTabComplaint =
      StatusComplaintEnum.PENDING.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final EasyRefreshController controllerComplaint = EasyRefreshController();
  final orderData = <OrderModel>[].obs;
  final orderDataComplaint = <OrderModel>[].obs;
  final totalData = 0.obs;
  final totalDataComplaint = 0.obs;
  final page = 1.obs;
  final pageComplaint = 1.obs;
  final listOrderGroupByMonth = <OrderGroupMonthModel>[].obs;
  final listOrderGroupByMonthComplaint = <OrderGroupMonthModel>[].obs;
  final selectedTab = RefuntTabEnum.complaint.obs;
  late TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    eventBus.on<OrderRefundUpdateEvent>().listen((event) {
      // fetchDataReimbursement();
      fetchDataComplaint();
    });
    // fetchDataReimbursement();
    fetchDataComplaint();
  }

  Future<List<OrderGroupMonthModel>> groupByDay(List<OrderModel> orders) async {
    final listOrderGroupByDay = <OrderGroupMonthModel>[];
    final Map<String, List<OrderModel>> grouped = {};

    for (var tx in orders) {
      if (tx.createDate == null) continue;

      final date = DateTime.tryParse(tx.createDate!);
      if (date == null) continue;

      // Key theo ngày: yyyy-MM-dd
      final key =
          '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

      grouped.putIfAbsent(key, () => []);
      grouped[key]!.add(tx);
    }

    // Sắp xếp ngày mới nhất lên đầu
    final sortedKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

    for (var key in sortedKeys) {
      listOrderGroupByDay.add(
        OrderGroupMonthModel(
          month: key, // hoặc đổi tên field trong model thành "day" nếu muốn
          orders: grouped[key]!,
        ),
      );
    }

    return listOrderGroupByDay;
  }

  onChangeTab(int index) {
    selectedTab.value = RefuntTabEnum.values[index];
  }

  Future<void> fetchDataComplaint() async {
    EasyLoading.show();
    await client
        .fetchOrderRefundByStoreComplaint(status: getStatusComplaint())
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["data"] != null) {
            orderDataComplaint.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            totalDataComplaint.value = response.data["resultApi"]["total"];
            listOrderGroupByMonthComplaint.assignAll(
              await groupByDay(orderDataComplaint),
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchDataReimbursement() async {
    EasyLoading.show();
    await client
        .fetchOrderRefundByStore(status: getStatusRefund())
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["data"] != null) {
            orderData.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            totalData.value = response.data["resultApi"]["total"];
            listOrderGroupByMonth.assignAll(await groupByDay(orderData));
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPageReimbursement() async {
    final nextPage = page.value + 1;
    await client
        .fetchOrderRefundByStore(
          status: [currentTab.value.name.toLowerCase()],
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
    controller.finishLoad(noMore: orderData.length >= totalData.value);
  }

  Future<void> onLoadingPageComplaint() async {
    final nextPage = pageComplaint.value + 1;
    await client
        .fetchOrderRefundByStoreComplaint(
          page: nextPage,
          pageSize: 20,
          status: getStatusComplaint(),
        )
        .then((response) async {
          if (response.data['resultApi']['data'] != null) {
            orderDataComplaint.addAll(
              (response.data['resultApi']['data'] as List)
                  .map((e) => OrderModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            pageComplaint.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controllerComplaint.finishLoad(
      noMore: orderDataComplaint.length >= totalDataComplaint.value,
    );
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    totalData.value = 0;
    fetchDataReimbursement();
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> onRefreshComplaint() async {
    await Future.delayed(Duration(milliseconds: 1000));
    pageComplaint.value = 1;
    totalDataComplaint.value = 0;
    controllerComplaint.resetLoadState();
    controllerComplaint.finishRefresh();
    fetchDataComplaint();
  }

  void onTapTab(StatusRefundEnum status) {
    currentTab.value = status;
    orderData.clear();
    totalData.value = 0;
    page.value = 1;
    fetchDataReimbursement();
  }

  void onTapTabComplaint(StatusComplaintEnum status) {
    currentTabComplaint.value = status;
    orderDataComplaint.clear();
    totalDataComplaint.value = 0;
    pageComplaint.value = 1;
    fetchDataComplaint();
  }

  List<String> getStatusRefund() {
    switch (currentTab.value) {
      case StatusRefundEnum.refund_pending:
        return ["DRIVER_CANCELED"];
      case StatusRefundEnum.pending:
        return ['REFUND_PENDING'];
      case StatusRefundEnum.result:
        return ["REFUND_FAILED", "REFUND_SUCCESS"];
    }
  }

  String getStatusComplaint() {
    switch (currentTabComplaint.value) {
      case StatusComplaintEnum.PENDING:
        return 'PENDING';
      case StatusComplaintEnum.APPROVED:
        return 'APPROVED';
      case StatusComplaintEnum.REJECTED:
        return 'REJECTED';
    }
  }
}
