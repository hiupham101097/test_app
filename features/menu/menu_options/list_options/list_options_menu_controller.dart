import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ListOptionsMenuController extends GetxController {
  final ApiClient client = ApiClient();
  final EasyRefreshController controller = EasyRefreshController();
  final isShowSelect = false.obs;
  final page = 1.obs;
  final total = 0.obs;
  final optionProductData = <OptionProductModel>[].obs;
  final isLoading = false.obs;
  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    total.value = 0;
    optionProductData.clear();
    controller.resetLoadState();
    controller.finishRefresh();
    fetchData();
  }

  @override
  void onInit() {
    super.onInit();
    eventBus.on<OptionProductEvent>().listen((event) {
      fetchData();
    });
    fetchData();
  }

  Future<void> fetchData() async {
    isLoading.value = true;
    EasyLoading.show();
    await client
        .fetchListOptionProduct()
        .then((response) {
          EasyLoading.dismiss();
          isLoading.value = false;
          if (response.data["resultApi"]['optionFood'] != null) {
            optionProductData.assignAll(
              (response.data["resultApi"]['optionFood'] as List)
                  .map(
                    (e) =>
                        OptionProductModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            total.value = response.data["resultApi"]['totalOptionFood'];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          isLoading.value = false;
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> onLoadingPage() async {
    final nextPage = page.value + 1;
    await client
        .fetchListOptionProduct(page: nextPage, limit: 20)
        .then((response) async {
          if (response.data['resultApi']['optionFood'] != null) {
            optionProductData.addAll(
              (response.data['resultApi']['optionFood'] as List)
                  .map(
                    (e) =>
                        OptionProductModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: optionProductData.length >= total.value);
  }
}
