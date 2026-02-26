import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/notifi_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/utils/error_util.dart';

class NotifycationController extends GetxController {
  final ApiClient client = ApiClient();
  final EasyRefreshController controller = EasyRefreshController();
  final loading = false.obs;
  final listNotification = <NotifiModel>[].obs;
  final total = 0.obs;
  final page = 1.obs;
  final hasReadNotification = false.obs;
  final storeModel = StoreModel().obs;
  @override
  void onInit() {
    super.onInit();
    storeModel.value = StoreDB().currentStore() ?? StoreModel();
    eventBus.on<NotificationEvent>().listen((event) {
      fetchData();
    });
    fetchData();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
    page.value = 1;
    total.value = 0;
    listNotification.clear();
    fetchData();
  }

  Future<void> fetchData() async {
    EasyLoading.show();
    loading.value = true;
    await client
        .fetchListNotification(receiverId: storeModel.value.id)
        .then((response) {
          EasyLoading.dismiss();
          loading.value = false;
          if (response.data["resultApi"]['data'] != null) {
            listNotification.assignAll(
              (response.data["resultApi"]['data'] as List)
                  .map((e) => NotifiModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            total.value = response.data["total"];
            hasReadNotification.value = listNotification.any(
              (element) => element.isRead == false,
            );
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
    await client
        .fetchListNotification(
          receiverId: storeModel.value.id,
          page: nextPage,
          limit: 20,
        )
        .then((response) async {
          if (response.data['resultApi']['data'] != null) {
            listNotification.addAll(
              (response.data['resultApi']['data'] as List)
                  .map((e) => NotifiModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listNotification.length >= total.value);
  }

  Future<void> updateNotification() async {
    await client
        .updateNotification(receiverId: storeModel.value.id)
        .then((response) {
          if (response.data["resultApi"] != null) {
            eventBus.fire(NotificationEvent());
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }
}
