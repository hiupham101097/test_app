import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/transport_order_model.dart';
import 'package:merchant/domain/data/socket_config.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/features/oder_detail/oder_detail_controller.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/rsa_util.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:wakelock_plus/wakelock_plus.dart';

class SocketService {
  late final IO.Socket _socket;
  bool _connecting = false;
  int _retryCount = 0;
  bool _disposed = false;
  final userDB = UserDB().currentUser();
  final int _maxRetryCount = 5;
  final ApiClient client = ApiClient();
  final WalletService walletService = WalletService();

  Future<void> connect() async {
    if (_connecting) return;
    _connecting = true;

    final completer = Completer<void>();
    try {
      final config = await _buildSocketConfig();
      final cipher = base64Encode(utf8.encode(config.cipherRawJson ?? ''));
      final signature = await CoreRsaUtil.sign(
        config.signatureInput ?? '',
        config.privateKeyPem ?? '',
      );

      final uri = "wss://gateway.gober.vn/user-events";
      // final uri = "wss://gateway-dev.gober.vn/user-events";
      final query = {'cipher': cipher, 'signature': signature};

      _socket = IO.io(
        uri,
        IO.OptionBuilder()
            .setTransports(['websocket'])
            .setQuery(query)
            .enableReconnection()
            .enableForceNew()
            .disableAutoConnect()
            .build(),
      );

      _socket.connect();
      _socket.onConnect((_) {
        print('✅ Đã kết nối tới server: ${_socket.id}');
        _connecting = false; // Reset connecting state
        _resetRetryCount();
        if (!completer.isCompleted) completer.complete();
      });

      _socket.onConnectError((err) {
        print('⛔️ Lỗi kết nối: $err');
        _connecting = false; // Reset connecting state
        if (!completer.isCompleted) completer.completeError(err);
        _scheduleReconnect();
      });

      _socket.onDisconnect((reason) {
        print('🔌 Ngắt kết nối: $reason');
        _connecting = false; // Reset connecting state
      });

      // Debug tất cả event
      _socket.onAny((event, data) {
        print("📩 Event nhận: $event");
        print("➡️ Data: $data");
        sendUpdateStatusDriver(data: data);
      });

      await WakelockPlus.enable();
    } catch (e) {
      print("[SocketService] connect error: $e");
      _connecting = false; // Reset connecting state
      if (!completer.isCompleted) completer.completeError(e);
      _scheduleReconnect();
    }

    return completer.future;
  }

  void sendMessage(String msg) {
    if (_socket.connected) {
      _socket.emit('message', msg);
    }
  }

  Future<SocketConfig> _buildSocketConfig() async {
    final timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final rawJson = '{"userId":"${userDB?.userId}","date":"$timestamp"}';
    final signatureInput = "${userDB?.userId}$timestamp";
    final privateKeyPem = await rootBundle.loadString(
      "assets/private_key/private-key.pem",
    );

    return SocketConfig(
      baseUrl: "wss://admin.gober.vn",
      path: "user-events",
      cipherRawJson: rawJson,
      signatureInput: signatureInput,
      privateKeyPem: privateKeyPem,
    );
  }

  void _scheduleReconnect() {
    if (_retryCount >= _maxRetryCount) {
      print("❌ Đã thử kết nối tối đa $_maxRetryCount lần, dừng retry");
      _connecting = false; // Reset connecting state
      return;
    }

    _retryCount++;
    final delaySeconds = _retryCount.clamp(1, 10);
    print(
      "🔄 [SocketService] Retry #$_retryCount/$_maxRetryCount sau $delaySeconds giây...",
    );

    Future.delayed(Duration(seconds: delaySeconds), () {
      if (!_disposed && _retryCount <= _maxRetryCount) {
        print("🔄 [SocketService] Thực hiện retry #$_retryCount...");
        connect();
      }
    });
  }

  /// Reset retry count khi kết nối thành công
  void _resetRetryCount() {
    _retryCount = 0;
  }

  /// Reset hoàn toàn trạng thái kết nối
  void resetConnectionState() {
    _connecting = false;
    _retryCount = 0;
    print("🔄 [SocketService] Đã reset trạng thái kết nối");
  }

  void dispose() {
    _disposed = true;
    _connecting = false;
    _retryCount = 0;
    if (_socket.connected) {
      _socket.disconnect();
    }
    print("🔌 [SocketService] Đã dispose service");
  }

  /// Kiểm tra trạng thái kết nối
  bool get isConnected => _socket.connected;

  /// Lấy số lần retry hiện tại
  int get retryCount => _retryCount;

  /// Kiểm tra xem có đang trong quá trình kết nối không
  bool get isConnecting => _connecting;

  void onDriverLocationChanged(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-location-changed', (data) {
      print('📍 Vị trí tài xế thay đổi: $data');
      callback(data);
    });
  }

  void onOrderRefund(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-order-refund', (data) {
      print('💸 Hoàn tiền đơn hàng: $data');
      callback(data);
    });
  }

  void onDriverAcceptOrder(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-order-accept', (data) {
      print('✅ Có tài xế nhận đơn: $data');
      callback(data);
    });
  }

  void onAllDriverBusy(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-order-all-busy', (data) {
      print('❌ Tất cả tài xế đều bận: $data');
      callback(data);
    });
  }

  void onOrderCompleted(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-order-completed', (data) {
      print('🏁 Hoàn tất toàn bộ đơn hàng: $data');
      callback(data);
    });
  }

  void onDriverGoingToReceivePoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-going-receive-point', (data) {
      print('🛵 Đến điểm nhận hàng: $data');
      callback(data);
    });
  }

  void onDriverArrivedReceivePoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-arrived-receive-point', (data) {
      print('📍 Đã đến điểm nhận hàng: $data');
      callback(data);
    });
  }

  void onDriverCompletedReceivePoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-completed-receive-point', (data) {
      print('✅ Hoàn tất nhận hàng: $data');
      callback(data);
    });
  }

  void onDriverGoingToSendPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-going-send-point', (data) {
      print('🚚 Đến điểm giao hàng: $data');
      callback(data);
    });
  }

  void onDriverArrivedSendPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-transport-arrived-send-point', (data) {
      print('📍 Đã đến điểm giao hàng: $data');
      callback(data);
    });
  }

  void onDriverCompletedSendPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-completed-send-point', (data) {
      print('✅ Hoàn tất điểm giao hàng: $data');
      callback(data);
    });
  }

  void onDriverCompletedDelivery(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-transport-completed-send-point', (data) {
      print('✅ Hoàn tất 1 điểm giao hàng: $data');
      callback(data);
    });
  }

  void onDriverCancelDelivery(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-cancel-send-point', (data) {
      print('❌ Hủy giao hàng: $data');
      callback(data);
    });
  }

  void onNextPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('next-point', (data) {
      print('🧭 Điểm đến tiếp theo: $data');
      callback(data);
    });
  }

  void onDriverGoingRefundPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-going-refund-point', (data) {
      print('↩️ Đang đến điểm trả hàng: $data');
      callback(data);
    });
  }

  void onDriverArrivedRefundPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-arrived-refund-point', (data) {
      print('📍 Đã đến điểm trả hàng: $data');
      callback(data);
    });
  }

  void onDriverCompletedRefundPoint(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-completed-refund-point', (data) {
      print('✅ Trả hàng thành công: $data');
      callback(data);
    });
  }

  void driverRejectOrder(Function(Map<String, dynamic>) callback) {
    _socket.on('driver-order-reject', (data) {
      print('❌ Tài xế từ chối đơn hàng: $data');
      callback(data);
    });
  }

  void onHasError(Function(Map<String, dynamic>) callback) {
    _socket.on('has-error', (data) {
      print('❗ Lỗi đơn hàng: $data');
      callback(data);
    });
  }

  void onTransportOrderLoad(Function(Map<String, dynamic>) callback) {
    _socket.on('user-order-load', (data) {
      print('🔁 Reload đơn hàng: $data');
      callback(data);
    });
  }

  void reloadCurrentOrder(String transportOrderId) {
    final payload = {
      "transportOrderId": transportOrderId,
      "userId": userDB?.userId,
    };
    print('payload payload $payload');
    _socket.emit("user-order-load", payload);
  }

  void findDriverForOrder(
    String transportOrderId,
    Function(Map<String, dynamic>) callback,
  ) {
    final payload = {
      "transportOrderId": transportOrderId,
      "userId": userDB?.userId,
    };
    print("[emit:user-order-find-driver] $payload");
    _socket.emit("user-order-find-driver", payload);
    callback(payload);
  }

  // ==== Emitters ====

  void sendUserLocationChanged({
    required double latitude,
    required double longitude,
  }) {
    final payload = {
      "userId": userDB?.userId,
      "latitude": latitude,
      "longitude": longitude,
    };
    print('[emit:user-location-changed] $payload');
    _socket.emit('user-location-changed', payload);
  }

  void subscribeToDriver(String driverId) {
    final payload = {"userId": userDB?.userId, "driverId": driverId};
    print('[emit:user-subscribe-to-driver] $payload');
    _socket.emit('user-subscribe-to-driver', payload);
  }

  void unsubscribeFromDriver(String driverId) {
    final payload = {"userId": userDB?.userId, "driverId": driverId};
    print('[emit:user-unsubscribe-to-driver] $payload');
    _socket.emit('user-unsubscribe-to-driver', payload);
  }

  void cancelFindDriver({
    required String transportOrderId,
    required String cancelOrderReasonId,
    required String cancelOrderReasonName,
    Function(Map<String, dynamic>)? callback,
  }) {
    final payload = {
      "transportOrderId": transportOrderId,
      "userId": userDB?.userId,
      "cancelOrderReasonId": cancelOrderReasonId,
      "cancelOrderReasonName": cancelOrderReasonName,
    };
    print('[emit:user-order-cancel-find-driver] $payload');
    _socket.emit('user-order-cancel-find-driver', payload);
    if (callback != null) callback(payload);
  }

  void cancelTransportOrder({
    required String transportOrderId,
    required String cancelOrderReasonId,
    required String cancelOrderReasonName,
    Function(Map<String, dynamic>)? callback,
  }) {
    final payload = {
      "transportOrderId": transportOrderId,
      "userId": userDB?.userId,
      "cancelOrderReasonId": cancelOrderReasonId,
      "cancelOrderReasonName": cancelOrderReasonName,
    };
    print('[emit:user-transport-order-cancel] $payload');
    _socket.emit('user-transport-order-cancel', payload);
    if (callback != null) callback(payload);
  }

  sendUpdateStatusDriver({required Map<String, dynamic> data}) async {
    await walletService.getWalletUser();
    final nextPoint = NextPointModel.fromJson(data);
    final transportOrderStatus =
        data["status"] ??
        nextPoint.transportOrder?.transportOrderStatus ??
        ((data['transports'] is List && data['transports'].isNotEmpty)
            ? data['transports'][0]['transportStatus']
            : null) ??
        data["currentTransportStatus"] ??
        '';
    final transportOrderId =
        nextPoint.transportOrder?.transportOrderId ??
        nextPoint.transportOrderId;
    print("transportOrderStatus: $transportOrderStatus");
    print("transportOrderId: $transportOrderId");
    if (transportOrderId != null && transportOrderStatus != null) {
      await Future.delayed(Duration(milliseconds: 1500));
      client
          .upDateStatusTransportOrder(
            transportOrderId: transportOrderId ?? '',
            statusDriver: transportOrderStatus ?? '',
          )
          .then((response) {
            if (response.statusCode == 200) {
              eventBus.fire(OderEvent());
              final detailOrderController = Get.find<OrderDetailController>();
              detailOrderController.fetchOderDetail();
            }
          })
          .catchError((error, trace) {
            ErrorUtil.catchError(error, trace);
          });
    }
  }
}
