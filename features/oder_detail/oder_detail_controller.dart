import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/cancel_model.dart';
import 'package:merchant/domain/data/models/driver_model.dart';
import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/transport_order_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/features/oder_detail/view/bottomsheet_cancel_oder.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/service/socket_service.dart';

class OrderDetailController extends GetxController {
  final ApiClient client = ApiClient();
  final SocketService socketService = SocketService();
  final CarouselSliderController carouselController =
      CarouselSliderController();
  final currentPage = 0.obs;
  final oderDetail = OderDetailModel().obs;
  final orderId = ''.obs;
  final reason = ''.obs;
  final nextPoint = NextPointModel().obs;
  final driver = DriverModel().obs;
  final socketConnected = false.obs;
  final statusFindDriver = ''.obs;
  final cancelReason = <String>[].obs;
  final isLoading = false.obs;
  final isLoadingSocket = false.obs;
  final WalletService walletService = WalletService();

  String _normalizeString(String? value) {
    return (value ?? "").trim().toUpperCase();
  }

  String normalizeDriverStatus(String? status) {
    final s = _normalizeString(status);
    switch (s) {
      case "PENDING":
        return "PENDING";
      case "SEARCHING_FOR_DRIVER":
        return "SEARCHING_FOR_DRIVER";
      case "DRIVER_ACCEPTED":
        return "DRIVER_ACCEPTED";
      case "DRIVER_ARRIVED_RECEIVE_POINT":
        return "DRIVER_ARRIVED_RECEIVE_POINT";
      case "DRIVER_GOING_TO_SEND_POINT":
        return "DRIVER_GOING_TO_SEND_POINT";
      case "DELIVERED":
        return "DELIVERED";
      case "CANCELLED":
        return "CANCELLED";
      case "COMPLETED":
        return "COMPLETED";
      case "DRIVER_GOING_TO_REFUND_POINT":
        return "DRIVER_COMPLETED_REFUND";
      case "DRIVER_ARRIVED_REFUND_POINT":
        return "DRIVER_ARRIVED_REFUND_POINT";
      case "DRIVER_COMPLETED_REFUND":
        return "DRIVER_COMPLETED_REFUND";
      case "ALL_BUSY_FOR_DRIVER":
      case "ALL_DRIVER_BUSY":
        return "ALL_BUSY_FOR_DRIVER";
      case "IN_RECIEVE":
        return "IN_RECIEVE";
      case "IN_REFUND":
        return "IN_REFUND";
      case "REFUNDED":
        return "REFUNDED";
      case "DRIVER_COMPLETED_REFUND_POINT":
        return "DRIVER_COMPLETED_REFUND";
      default:
        return s;
    }
  }

  @override
  void onInit() {
    EasyLoading.show();
    isLoading.value = true;
    initData();
    super.onInit();
  }

  Future<void> initData() async {
    await connectSocket();
    if (Get.arguments != null && Get.arguments['orderId'] != null) {
      orderId.value = Get.arguments['orderId'];
      await fetchOderDetail();
      await reloadCurrentOrder(oderDetail.value.transportOrderId);
      handleStatusFindDriver(oderDetail.value.statusDriver);
      await getCancelOrderReasons();
    }
  }

  Future<void> connectSocket() async {
    try {
      isLoadingSocket.value = true;
      EasyLoading.show();
      await socketService.connect();
      socketConnected.value = true;
      await Future.delayed(Duration(seconds: 1));
      _setupSocketListeners();
      isLoadingSocket.value = false;
      EasyLoading.dismiss();
    } catch (e) {
      isLoadingSocket.value = false;
      EasyLoading.dismiss();
      print("⚠️ Không thể connect socket: $e");
    } finally {
      isLoadingSocket.value = false;
      EasyLoading.dismiss();
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<OderDetailModel?> fetchOderDetail() async {
    try {
      final response = await client.oderDetail(idOder: orderId.value);
      oderDetail.value = OderDetailModel();
      if (response.data["resultApi"] != null) {
        final newDetail = OderDetailModel.fromJson(response.data['resultApi']);
        oderDetail.value = newDetail; // cập nhật data mới
        isLoading.value = false;
        EasyLoading.dismiss();
        eventBus.fire(OderEvent());
        return newDetail;
      }

      return null;
    } catch (error, trace) {
      isLoading.value = false;
      EasyLoading.dismiss();
      ErrorUtil.catchError(error, trace);
      return null;
    }
  }

  void handleStatusFindDriver(String statusDriver) {
    statusFindDriver.value = normalizeDriverStatus(statusDriver);
  }

  confirmOder(String status) async {
    if (oderDetail.value.orderStatus == "PREPARING") {
      findDriverForOrder(oderDetail.value.transportOrderId);
    } else {
      final system = orderId.value.split('-')[0];
      EasyLoading.show();
      final data = {
        "userId": oderDetail.value.userId,
        "status": status,
        "system": system.toUpperCase() == "MKT" ? "2" : "1",
      };
      client
          .confirmOder(idOder: orderId.value, data: data)
          .then((response) {
            if (response.statusCode == 200) {
              fetchOderDetail();
              eventBus.fire(OderEvent());
            }
            EasyLoading.dismiss();
          })
          .catchError((error, trace) {
            EasyLoading.dismiss();
            ErrorUtil.catchError(error, trace);
          });
    }
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
            cancelTransportOrder();
            cancelFindDriver();
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

  upDateStatusDriver({required String statusDriver}) async {
    final system = orderId.value.split('-')[0];
    final data = {
      "organizationId": system.toUpperCase() == "MKT" ? "2" : "1",
      "statusDriver": statusDriver,
    };
    client
        .upDateStatusDriver(idOder: oderDetail.value.id, data: data)
        .then((response) {
          eventBus.fire(OderEvent());
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetCancelOrder(Function() onConfirm) {
    Get.bottomSheet(
      BottomSheetCancelOrder(
        onConfirm: (reason) {
          this.reason.value = reason;
          Get.back();
          onConfirm();
        },
        reasons: cancelReason,
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      isScrollControlled: true,
    );
  }

  String getTitleFindDriver(String status) {
    switch (status) {
      case "PENDING":
        return "find_driver".tr;
      case "SEARCHING_FOR_DRIVER":
        return "finding_driver".tr;
      case "DRIVER_ACCEPTED":
        return "driver_accepted_order".tr;
      case "DRIVER_ARRIVED_RECEIVE_POINT":
        return "driver_coming_to_store".tr;
      case "DRIVER_GOING_TO_SEND_POINT":
        return "driver_coming_to_delivery".tr;
      case "DELIVERED":
        return "driver_delivered".tr;
      case "IN_DELIVERY":
        return "driver_delivering".tr;
      case "IN_RECIEVE":
        return "driver_coming_to_store".tr;
      case "CANCELLED":
        return "continue_find_driver".tr;
      case "COMPLETED":
        return "completed".tr;
      case "DRIVER_GOING_TO_REFUND_POINT":
        return "driver_coming_to_return".tr;
      case "DRIVER_ARRIVED_REFUND_POINT":
        return "driver_arrived_return".tr;
      case "DRIVER_COMPLETED_REFUND":
        return "driver_completed_return".tr;
      case "ALL_BUSY_FOR_DRIVER":
        return "continue_find_driver".tr;
      case "IN_REFIUND":
        return "driver_returning".tr;
      case "REFUNDED":
        return "driver_returned_success".tr;
      case "DRIVER_COMPLETED_REFUND_POINT":
        return "Tài xế đã hoàn trả thành công";
      default:
        return status;
    }
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

  void findDriverForOrder(String transportOrderId) {
    socketService.findDriverForOrder(transportOrderId, (data) async {
      await upDateStatusDriver(statusDriver: "SEARCHING_FOR_DRIVER");
      statusFindDriver.value = "SEARCHING_FOR_DRIVER";
      Future.delayed(Duration(milliseconds: 1000), () async {
        await fetchOderDetail();
      });
      print("📤 Đã gửi yêu cầu tìm tài xế: $data");
    });
  }

  Future<void> reloadCurrentOrder(String transportOrderId) async {
    socketService.reloadCurrentOrder(transportOrderId);
  }

  Future<void> cancelFindDriver() async {
    await upDateStatusDriver(statusDriver: "PENDING");
    socketService.cancelFindDriver(
      transportOrderId: oderDetail.value.transportOrderId,
      cancelOrderReasonId: reason.value,
      cancelOrderReasonName: reason.value,
    );
    await fetchOderDetail();
    statusFindDriver.value = "PENDING";
  }

  void cancelTransportOrder() {
    socketService.cancelTransportOrder(
      transportOrderId: oderDetail.value.transportOrderId,
      cancelOrderReasonId: reason.value,
      cancelOrderReasonName: reason.value,
    );
  }

  /// Setup socket listeners
  void _setupSocketListeners() {
    socketService.onDriverAcceptOrder((data) {
      _handleTransportOrderUpdate(data, "✅ ${"driver_received_order".tr}");
    });

    socketService.onAllDriverBusy((data) {
      _handleTransportOrderUpdate(data, "❌ ${"all_drivers_busy".tr}");
    });

    socketService.onOrderCompleted((data) async {
      await walletService.getWalletUser();
      await walletService.getWallet(
        phone: StoreDB().currentStore()?.phone ?? '',
        store: StoreDB().currentStore() ?? StoreModel(),
      );
      // _handleTransportOrderUpdate(data, "🏁 ${"order_completed".tr}");

      // });
    });

    socketService.onHasError((data) {
      _handleTransportOrderUpdate(data, "❗ ${"error_occurred".tr}");
    });

    // 🔁 Reload lại đơn đang xử lý
    socketService.onTransportOrderLoad((data) {
      _handleTransportOrderUpdate(data, "🔁 ${"reload_order".tr}");
    });

    socketService.driverRejectOrder((data) {
      findDriverForOrder(oderDetail.value.transportOrderId);
    });

    // 📍 Vị trí tài xế thay đổi
    socketService.onDriverLocationChanged((data) {
      _handleTransportOrderUpdate(data, "📍 ${"driver_location_changed".tr}");
    });

    // 🛵 Đang đến điểm nhận hàng
    socketService.onDriverGoingToReceivePoint((data) {
      _handleTransportOrderUpdate(data, "🛵 ${"going_to_pickup".tr}");
    });

    // 📍 Đã đến điểm nhận hàng
    socketService.onDriverArrivedReceivePoint((data) {
      _handleTransportOrderUpdate(data, "📍 ${"arrived_pickup".tr}");
    });

    // ✅ Hoàn tất nhận hàng
    socketService.onDriverCompletedReceivePoint((data) {
      _handleTransportOrderUpdate(data, "✅ ${"pickup_completed".tr}");
    });

    // 🚚 Đang đến điểm giao hàng
    socketService.onDriverGoingToSendPoint((data) {
      _handleTransportOrderUpdate(data, "🚚 ${"going_to_delivery".tr}");
    });

    // 📍 Đã đến điểm giao hàng
    socketService.onDriverArrivedSendPoint((data) {
      _handleTransportOrderUpdate(data, "📍 ${"arrived_delivery".tr}");
    });

    // ✅ Hoàn tất 1 điểm giao hàng
    socketService.onDriverCompletedDelivery((data) {
      _handleTransportOrderUpdate(data, "✅ ${"delivery_completed".tr}");
    });

    // ❌ Hủy giao hàng
    socketService.onDriverCancelDelivery((data) {
      _handleTransportOrderUpdate(data, "❌ ${"cancel_delivery".tr}");
    });

    // 🧭 Chuyển sang điểm tiếp theo
    socketService.onNextPoint((data) {
      _handleTransportOrderUpdate(data, "🧭 ${"next_point".tr}");
    });

    // 💸 Đang hoàn trả
    socketService.onDriverGoingRefundPoint((data) {
      _handleTransportOrderUpdate(data, "💸 ${"returning".tr}");
    });

    // 💸 Hoàn trả thành công
    socketService.onDriverCompletedRefundPoint((data) {
      _handleTransportOrderUpdate(data, "💸 ${"return_completed".tr}");
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

  Future<void> _handleTransportOrderUpdate(
    Map<String, dynamic> data,
    String eventDescription,
  ) async {
    try {
      String extractTransportStatus(Map<String, dynamic> data) {
        return data["status"] ??
            data["transportOrder"]?['transportOrderStatus'] ??
            ((data['transports'] is List && data['transports'].isNotEmpty)
                ? data['transports'][0]['transportStatus']
                : null) ??
            data["currentTransportStatus"] ??
            '';
      }

      statusFindDriver.value = normalizeDriverStatus(
        extractTransportStatus(data),
      );
      nextPoint.value = NextPointModel.fromJson(data);
      driver.value = DriverModel.fromJson(data['driver']);
      print("statusFindDriver.value: ${statusFindDriver.value}");
    } catch (e) {
      print("❌ ${"error_processing_transport".tr}: $e");
    }
  }
}
