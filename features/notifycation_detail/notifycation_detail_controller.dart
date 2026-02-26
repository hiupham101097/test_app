import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/notifi_model.dart';
import 'package:merchant/utils/error_util.dart';

class NotifycationDetailController extends GetxController {
  final ApiClient client = ApiClient();
  final notification = NotifiModel().obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['notification'] != null) {
      notification.value = Get.arguments['notification'];
      if (notification.value.isRead == false) {
        updateNotification();
      }
    }
  }

  Future<void> updateNotification() async {
    final data = {"expireAt": DateTime.now().toIso8601String(), "isRead": true};
    await client
        .fetchDetailNotification(
          notificationId: notification.value.notificationId ?? "",
          data: data,
        )
        .then((response) {
          eventBus.fire(NotificationEvent());
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }
}
