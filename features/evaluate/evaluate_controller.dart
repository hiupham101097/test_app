import 'dart:async';

import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/evaluate_overview_model.dart';
import 'package:merchant/domain/data/models/evaluation_item_model.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/features/evaluate/widget/product_bottomsheet.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';

class EvaluateController extends GetxController {
  final ApiClient client = ApiClient();
  final evaluateOverview = EvaluateOverviewModel().obs;
  final listDataEvaluate = <EvaluationItemModel>[].obs;
  final page = 1.obs;
  final pageProduct = 1.obs;
  final EasyRefreshController controller = EasyRefreshController();
  final EasyRefreshController controllerProduct = EasyRefreshController();

  final total = 0.obs;
  final totalProduct = 0.obs;
  final listProductData = <ProductModel>[].obs;
  final listProductGroupByCategory = <ProductGroupCategoryModel>[].obs;
  final listProductSelectedTemp = <String>[].obs;
  final searchFocusNodeProduct = FocusNode();
  final searchControllerProduct = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    eventBus.on<EvaluateEvent>().listen((event) {
      fetchDataEvaluate();
    });
    fetchDataEvaluate();
    fetchDataProduct();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    page.value = 1;
    fetchDataEvaluate();
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> onRefreshProduct() async {
    await Future.delayed(Duration(milliseconds: 1000));
    pageProduct.value = 1;
    fetchDataProduct();
    listProductData.clear();
    listProductGroupByCategory.clear();
    controllerProduct.resetLoadState();
    controllerProduct.finishRefresh();
  }

  Timer? _debounce;

  void onSearchProduct({String search = ''}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchDataProduct(search: search);
    });
  }

  Future<void> fetchDataEvaluate() async {
    EasyLoading.show();
    await client
        .fetchOverviewEvaluate(listProductId: listProductSelectedTemp)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            evaluateOverview.value = EvaluateOverviewModel.fromJson(
              response.data["resultApi"],
            );
            listDataEvaluate.assignAll(
              (response.data["resultApi"]["listData"] as List)
                  .map(
                    (e) =>
                        EvaluationItemModel.fromJson(e as Map<String, dynamic>),
                  )
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
    await client
        .fetchOverviewEvaluate(page: nextPage, limit: 20)
        .then((response) async {
          if (response.data["resultApi"]["listData"] != []) {
            listDataEvaluate.addAll(
              (response.data["resultApi"]["listData"] as List)
                  .map(
                    (e) =>
                        EvaluationItemModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listDataEvaluate.length >= total.value);
  }

  Future<void> fetchDataProduct({String search = ''}) async {
    EasyLoading.show();
    await client
        .fetchListProduct(search: search)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]['products'] != null) {
            listProductData.assignAll(
              (response.data["resultApi"]['products'] as List)
                  .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            groupByCategory(listProductData);
            totalProduct.value = response.data["resultApi"]['total'];
            print('Length: ${listProductData.length}');
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void groupByCategory(List<ProductModel> products) {
    listProductGroupByCategory.clear();

    final grouped = <String, List<ProductModel>>{};

    for (final p in products.where((e) => e.category != null)) {
      final key = p.category!.name ?? '';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    listProductGroupByCategory.addAll(
      grouped.entries.map(
        (e) => ProductGroupCategoryModel(
          category: e.key,
          categoryLength: e.value.length,
          products: e.value,
        ),
      ),
    );
  }

  Future<void> onLoadingPageProduct() async {
    final nextPage = page.value + 1;
    await client
        .fetchListProduct(page: nextPage, limit: 20)
        .then((response) async {
          if (response.data['resultApi']['products'] != null) {
            listProductData.addAll(
              (response.data['resultApi']['products'] as List)
                  .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            groupByCategory(listProductData);
            pageProduct.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controllerProduct.finishLoad(noMore: listProductData.length >= total.value);
  }

  void showProductBottomsheet() {
    Get.bottomSheet(
      ProductBottomsheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void onConfirmProduct(List<String> listProductId) {
    fetchDataEvaluate();
    Get.back();
  }

  void onResetProduct() {
    searchControllerProduct.clear();
    searchFocusNodeProduct.unfocus();
    listProductSelectedTemp.clear();
    fetchDataEvaluate();
    fetchDataProduct();
    Get.back();
  }
}
