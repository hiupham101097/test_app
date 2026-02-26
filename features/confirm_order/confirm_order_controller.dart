import 'dart:convert';

import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/oder_detail/view/bottomsheet_cancel_oder.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/utils/dialog_util.dart';

class ConfirmOrderController extends GetxController {
  final ApiClient client = ApiClient();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final currentPage = 0.obs;
  final isLoading = false.obs;
  final oderDetail = OderDetailModel().obs;
  final reason = ''.obs;
  final orderData = <OderDetailModel>[].obs;
  final cancelReason = <String>[].obs;
  final orderId = ''.obs;
  final WalletService walletService = WalletService();
  @override
  void onInit() {
    getCancelOrderReasons();
    super.onInit();
    if (Get.arguments != null && Get.arguments['orderId'] != null) {
      orderId.value = Get.arguments['orderId'];
      fetchOderDetail(orderId.value);
    }
    // eventBus.on<OderEvent>().listen((event) {
    //   fetchData();
    // });
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    EasyLoading.show();
    final store = StoreDB().currentStore() ?? StoreModel();
    final data = [
      {
        "key": "orderStatus",
        "value": StatusOrderEnum.PENDING.name.toUpperCase(),
      },
      {"key": "system", "value": store.system},
    ];
    await client
        .fetchListMyOrders(status: jsonEncode(data))
        .then((response) {
          isLoading.value = false;
          EasyLoading.dismiss();
          if (response.data["resultApi"]["data"] != null) {
            orderData.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map(
                    (e) => OderDetailModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            if (orderData.isNotEmpty) {
              fetchOderDetail(orderData.first.orderId);
            }
          }
        })
        .catchError((error, trace) {
          isLoading.value = false;
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<OderDetailModel?> fetchOderDetail(String orderId) async {
    try {
      isLoading.value = true;

      final response = await client.oderDetail(idOder: orderId);
      if (response.data["resultApi"] != null) {
        final detail = OderDetailModel.fromJson(response.data['resultApi']);
        oderDetail.value = detail;
        orderData.add(detail);
        return detail;
      }
      return null;
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
      return null;
    } finally {
      isLoading.value = false;
    }
  }

  confirmOder(String status, String orderId, String userId) async {
    EasyLoading.show();
    final system = orderId.split('-')[0];
    final data = {
      "userId": userId,
      "status": status,
      "system": system.toUpperCase() == "MKT" ? "2" : "1",
    };
    client
        .confirmOder(idOder: orderId, data: data)
        .then((response) {
          if (response.statusCode == 200) {
            fetchData();
            eventBus.fire(OderEvent());
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  cancelOder({String? reason}) async {
    EasyLoading.show();
    client
        .cancelOder(
          idOder: oderDetail.value.id,
          reason: reason,
          orderId: orderId.value,
        )
        .then((response) async {
          if (response.statusCode == 200) {
            fetchData();
            showDialogCancelSucess();
            eventBus.fire(OderEvent());
            await walletService.getWalletUser();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  getCancelOrderReasons() async {
    client
        .getCancelOrderReasons()
        .then((response) {
          if (response.statusCode == 200) {
            final List<String> cancelReasonModel =
                (response.data as List<dynamic>)
                    .map((item) => item as String)
                    .toList();
            cancelReason.assignAll(cancelReasonModel);
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetCancelOrder() {
    Get.bottomSheet(
      BottomSheetCancelOrder(
        selectedValue: reason.value,
        onConfirm: (reason) {
          this.reason.value = reason;
          Get.back();
          cancelOder(reason: reason);
        },
        reasons: cancelReason,
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
    );
  }

  void showDialogCancelSucess() {
    DialogUtil.showDialogSucess(
      Get.context!,
      oderDetail.value.orderId,
      reason.value,
      close: () {
        Get.back();
        Get.back();
      },
    );
  }
}
