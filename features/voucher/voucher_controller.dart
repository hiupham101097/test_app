import 'package:merchant/commons/views/bottomsheet_update_voucher.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class VoucherController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final ApiClient client = ApiClient();
  final RxInt currentIndex = 0.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final tabList = ['Mã khuyến mãi', 'Quản lý khuyến mãi'];
  late TabController tabController;
  final listVoucher = <PromotionModel>[].obs;
  final listVoucherJoined = <PromotionModel>[].obs;
  final total = 0.obs;
  final page = 1.obs;
  final loading = false.obs;

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabList.length, vsync: this);
    fetchData();
    eventBus.on<PromotionEvent>().listen((event) {
      fetchData();
    });
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
    page.value = 1;
    total.value = 0;
    listVoucher.clear();
    fetchData();
  }

  void onChangeTab(int index) {
    tabController.index = index;
    listVoucher.clear();
    listVoucherJoined.clear();
    total.value = 0;
    page.value = 1;
    fetchData();
  }

  onJoinVoucher({int? idVoucher}) async {
    EasyLoading.show();
    print("idVoucher $idVoucher");
    final data = {
      "listPromotionIds": [
        {"id": idVoucher},
      ],
    };
    client
        .joinVoucher(data: data)
        .then((response) {
          if (response.statusCode == 200 && response.data['status'] == 200) {
            DialogUtil.showSuccessMessage(response.data['message']);
            fetchData();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchData() async {
    EasyLoading.show();
    loading.value = true;
    await client
        .fetchListVoucher()
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["listData"] != null) {
            listVoucher.assignAll(
              (response.data["resultApi"]["listData"] as List)
                  .map(
                    (e) => PromotionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            listVoucherJoined.assignAll(
              listVoucher.where((element) => element.isExisted).toList(),
            );

            total.value = response.data["resultApi"]["totalAll"];
            loading.value = false;
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
        .fetchListVoucher(page: nextPage, limit: 20)
        .then((response) async {
          if (response.data['resultApi']['listData'] != null) {
            listVoucher.addAll(
              (response.data['resultApi']['listData'] as List)
                  .map(
                    (e) => PromotionModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listVoucher.length >= total.value);
  }
}
