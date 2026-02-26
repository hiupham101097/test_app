import 'dart:convert';

import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/domain/data/models/revenue_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final ApiClient client = ApiClient();
  final orderData = <OrderModel>[].obs;
  final listVoucher = <PromotionModel>[].obs;
  bool isOpenStatus = false;
  final store = StoreModel().obs;
  final loadingToggleStatus = false.obs;
  final revenueData = RevenueModel().obs;
  final todayUpdate = "".obs;
  final yesterdayUpdate = "".obs;
  final EasyRefreshController controller = EasyRefreshController();
  final totalUseMotion = 0.obs;
  final totalNotification = 0.obs;
  final page = 1.obs;
  final total = 0.obs;
  @override
  void onInit() {
    super.onInit();
    store.value = StoreDB().currentStore() ?? StoreModel();
    eventBus.on<UpdateStoreEvent>().listen((event) {
      store.value = StoreDB().currentStore() ?? StoreModel();
      isOpenStatus = store.value.closeOpenStatus == AppConstants.close;
    });
    isOpenStatus = store.value.closeOpenStatus == AppConstants.close;
    eventBus.on<OderEvent>().listen((event) {
      fetchData();
      fetchDataRevenue();
    });
    fetchData();
    fetchDataVoucher();
    eventBus.on<PromotionEvent>().listen((event) {
      fetchDataVoucher();
    });
    fetchDataRevenue();
    eventBus.on<NotificationEvent>().listen((event) {
      fetchDataNotification();
    });
    fetchDataNotification();
    fetchDataSetting();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
    store.value = StoreDB().currentStore() ?? StoreModel();
    print("store123123: ${store.value.imageUrlMap}");
    isOpenStatus = store.value.closeOpenStatus == AppConstants.close;
    fetchData();
    fetchDataVoucher();
    fetchDataRevenue();
    fetchDataNotification();
    fetchDataSetting();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchData() async {
    EasyLoading.show();
    final data = [
      {
        "key": "orderStatus",
        "value": StatusOrderEnum.PENDING.name.toUpperCase(),
      },
      {"key": "system", "value": store.value.system},
    ];
    await client
        .fetchListMyOrders(status: jsonEncode(data))
        .then((response) {
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
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPage() async {
    final nextPage = page.value + 1;
    final data = [
      {
        "key": "orderStatus",
        "value": StatusOrderEnum.PENDING.name.toUpperCase(),
      },
      {"key": "system", "value": store.value.system},
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
    controller.finishLoad(noMore: orderData.length >= total.value);
  }

  Future<void> fetchDataVoucher() async {
    EasyLoading.show();
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
            totalUseMotion.value = response.data["resultApi"]["total"];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchDataRevenue() async {
    final today = DateTime.now();
    final yesterday = today.subtract(const Duration(days: 1));
    final todayStr = DateUtil.formatDate(today, format: "yyyy-MM-dd");
    final yesterdayStr = DateUtil.formatDate(yesterday, format: "yyyy-MM-dd");
    todayUpdate.value = today.toIso8601String();
    yesterdayUpdate.value = yesterday.toIso8601String();
    await client
        .fetchListRevenue(
          currentStart: todayStr,
          currentEnd: todayStr,
          compareStart: yesterdayStr,
          compareEnd: yesterdayStr,
        )
        .then((response) {
          if (response.data["resultApi"] != null) {
            revenueData.value = RevenueModel.fromJson(
              response.data["resultApi"] as Map<String, dynamic>,
            );
            print("revenueData ${revenueData.value}");
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
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
          if (response.data['resultApi']['status'] == 200) {
            DialogUtil.showSuccessMessage("join_voucher_success".tr);
            fetchDataVoucher();
          } else {
            DialogUtil.showErrorMessage("join_voucher_failed".tr);
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  toggleStatus() async {
    loadingToggleStatus.value = true;
    client
        .toggleStatus()
        .then((response) {
          if (response.data['resultApi']['statusCode'] == 200) {
            final storeJson =
                response.data['resultApi']['store'] as Map<String, dynamic>?;
            if (storeJson != null) {
              final parsedStore = StoreModel.fromJson(storeJson);
              store.value = parsedStore;
              StoreDB().save(parsedStore);
              isOpenStatus = parsedStore.closeOpenStatus == AppConstants.close;
            }
            loadingToggleStatus.value = false;
          }
        })
        .catchError((error, trace) {
          loadingToggleStatus.value = false;
          ErrorUtil.catchError(error, trace);
        });
  }

  void onTapMenu(int index) {
    switch (index) {
      case 0:
        Get.toNamed(Routes.menu);
        break;
      case 1:
        Get.toNamed(Routes.refund);
        break;
      case 2:
        Get.toNamed(Routes.incomeStatistics);
        break;
      case 3:
        Get.toNamed(Routes.myWallet);
        break;
      case 4:
        Get.toNamed(Routes.settingTime);
        break;
    }
  }

  Future<void> fetchDataNotification() async {
    await client
        .fetchListNotification(receiverId: store.value.id, limit: 100)
        .then((response) {
          if (response.data["resultApi"]['data'] != null) {
            totalNotification.value =
                response.data["resultApi"]['data']
                    .where((element) => element["isRead"] == false)
                    .length;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchDataSetting() async {
    await client
        .fetchDataSetting()
        .then((response) {
          final listData = response.data["listData"] as List<dynamic>;
          final amountSetting =
              listData.firstWhere(
                (element) => element["codeName"] == "WALLET",
              )["value"] ??
              "";
          sl<LocalClient>().setAmountSetting(amountSetting);
          final walletUser =
              WalletDB().currentWalletUser() ?? WalletUserModel();
          if (sl<LocalClient>().amountSetting.isNotEmpty) {
            if (walletUser.wallet != null &&
                walletUser.wallet! <
                    int.parse(sl<LocalClient>().amountSetting)) {
              if (store.value.closeOpenStatus == AppConstants.open) {
                toggleStatus();
              }
            }
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }
}
