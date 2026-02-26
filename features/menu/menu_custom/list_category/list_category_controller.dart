import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/meta_data_model.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ListCategoryController extends GetxController {
  final ApiClient client = ApiClient();
  final EasyRefreshController controller = EasyRefreshController();
  final listCategory = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final page = 1.obs;
  final total = 0.obs;

  @override
  void onInit() {
    super.onInit();
    eventBus.on<CategoryEvent>().listen((event) {
      fetchListCategory();
    });
    fetchListCategory();
  }

  Future<void> onRefresh() async {
    controller.resetLoadState();
    controller.finishRefresh();
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    total.value = 0;
    fetchListCategory();
  }

  Future<void> fetchListCategory() async {
    EasyLoading.show();
    isLoading.value = true;
    await client
        .fetchListCategory()
        .then((response) {
          EasyLoading.dismiss();
          isLoading.value = false;
          if (response.data["resultApi"]['categories'] != null) {
            listCategory.assignAll(
              (response.data["resultApi"]['categories'] as List)
                  .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            total.value = response.data["resultApi"]['totalCategories'];
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
        .fetchListCategory(page: nextPage, limit: 20)
        .then((response) async {
          if (response.data['resultApi']['categories'] != null) {
            listCategory.addAll(
              (response.data['resultApi']['categories'] as List)
                  .map((e) => CategoryModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listCategory.length >= total.value);
  }

  void toggleSubCategory(CategoryModel category) {
    category.showSubCategory.value = !category.showSubCategory.value;
    update();
  }
}
