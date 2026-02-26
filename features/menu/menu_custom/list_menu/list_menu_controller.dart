import 'dart:async';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/commons/views/bottomsheet_update_voucher.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/view/bottomsheet_selected_category.dart';
import 'package:merchant/features/menu/menu_custom/list_menu/view/change_status_bottomshet.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

enum ListMenuType { all, promotion }

enum MenuStatusType { deleted, active }

class ListMenuController extends GetxController {
  final ApiClient client = ApiClient();
  final EasyRefreshController controller = EasyRefreshController();
  final RxBool isShowHeaderSearch = false.obs;
  final FocusNode searchFocusNode = FocusNode();
  final TextEditingController searchController = TextEditingController();
  final isShowSelect = false.obs;
  final promotion = PromotionModel().obs;
  final listProductData = <ProductModel>[].obs;
  final total = 0.obs;
  final listProductGroupByCategory = <ProductGroupCategoryModel>[].obs;
  final listProductSelected = <ProductModel>[].obs;
  final searchText = ''.obs;
  final page = 1.obs;
  final isLoading = false.obs;
  final listMenuType = ListMenuType.all.obs;
  final menuStatusType = MenuStatusType.active.obs;
  final listCategory = <CategoryModel>[].obs;
  final selectedCategory = Rx<List<CategoryModel>>([]);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['listMenuType'] != null) {
      listMenuType.value = Get.arguments['listMenuType'];
      toggleStatus();
    }
    if (Get.arguments != null && Get.arguments['promotion'] != null) {
      promotion.value = Get.arguments['promotion'];
    }
    eventBus.on<ProductEvent>().listen((event) {
      fetchData();
    });
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
    fetchData();
    eventBus.on<CategoryEvent>().listen((event) {
      fetchListCategory();
    });
    fetchListCategory();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
    isLoading.value = true;
    page.value = 1;
    total.value = 0;
    listProductData.clear();
    listProductSelected.clear();
    listProductGroupByCategory.clear();
    fetchData();
  }

  Timer? _debounce;

  void onSearch({String search = ''}) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      fetchData(search: search);
    });
  }

  Future<void> fetchData({String search = ''}) async {
    EasyLoading.show();
    isLoading.value = true;
    await client
        .fetchListProduct(
          search: search,
          categoryId: selectedCategory.value.map((e) => e.id ?? '').toList(),
          systemSettings:
              listMenuType.value == ListMenuType.promotion
                  ? [promotion.value.system]
                  : null,
        )
        .then((response) {
          EasyLoading.dismiss();
          isLoading.value = false;
          if (response.data["resultApi"]['products'] != null) {
            total.value = response.data["resultApi"]['total'];
            listProductData.assignAll(
              (response.data["resultApi"]['products'] as List)
                  .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            listProductGroupByCategory.value = AppUtil.groupByCategory(
              listProductData,
            );
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
        .fetchListProduct(
          page: nextPage,
          limit: 20,
          categoryId: selectedCategory.value.map((e) => e.id ?? '').toList(),
          systemSettings:
              listMenuType.value == ListMenuType.promotion
                  ? [promotion.value.system]
                  : null,
        )
        .then((response) async {
          if (response.data['resultApi']['products'] != null) {
            listProductData.addAll(
              (response.data['resultApi']['products'] as List)
                  .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
            listProductGroupByCategory.value = AppUtil.groupByCategory(
              listProductData,
            );
            page.value = nextPage;
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
    controller.finishLoad(noMore: listProductData.length >= total.value);
  }

  void toggleStatus({MenuStatusType? status}) {
    isShowHeaderSearch.value = !isShowHeaderSearch.value;
    isShowSelect.value = !isShowSelect.value;
    listProductSelected.clear();
    searchController.text = '';
    searchText.value = '';
    menuStatusType.value = status ?? MenuStatusType.active;
  }

  void onSelectItem(ProductModel item) {
    if (listMenuType.value == ListMenuType.promotion) {
      if (!item.availability ||
          item.keyPromotion.isNotEmpty ||
          item.status != "APPROVE") {
        return;
      }
    }
    item.selected.value = !item.selected.value;
    if (item.selected.value) {
      listProductSelected.add(item);
    } else {
      listProductSelected.remove(item);
    }
  }

  void showChangeStatusBottomsheet() {
    Get.bottomSheet(
      ChangeStatusBottomsheet(
        onTap: (bool availability) {
          toggleProductStatus(availability: availability);
          Get.back();
        },
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  Future<void> addProductPromotion(
    List<ProductModel> listProductSelectedPromotion,
  ) async {
    if (listProductSelectedPromotion.isEmpty) {
      DialogUtil.showErrorMessage("select_product_promotion".tr);
      return;
    }
    EasyLoading.show();
    final data = {
      "promotionId": promotion.value.id,
      "system": promotion.value.system,
      "listProductIds":
          listProductSelectedPromotion
              .map(
                (e) => {
                  "productId": e.id,
                  "sale_promotion":
                      ((1 -
                                  ((double.tryParse(
                                            e.priceSalePromotion.value
                                                .toString()
                                                .replaceAll(',', ''),
                                          ) ??
                                          0) /
                                      (double.tryParse(
                                            e.price.toString().replaceAll(
                                              ',',
                                              '',
                                            ),
                                          ) ??
                                          1))) *
                              100)
                          .toInt(),
                  "quantity_promotion": e.quantity.value,
                  "priceSale_promotion": e.priceSalePromotion.value,
                },
              )
              .toList(),
    };
    await client
        .addProductPromotion(data: data)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["status"] == 200) {
            eventBus.fire(ProductPromotionEvent());
            DialogUtil.showSuccessMessage("add_product_success".tr);
            Get.back();
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  selectedAllProduct() {
    for (var element in listProductData) {
      element.selected.value = true;
      listProductSelected.add(element);
    }
  }

  Future<void> deletedProduct() async {
    EasyLoading.show();
    final data = {
      "products": listProductSelected.map((e) => {"id": e.id}).toList(),
    };
    print(data);
    await client
        .deleteProductPromotions(data: data)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["statusCode"] == 200) {
            fetchData();
            listProductSelected.clear();
            DialogUtil.showSuccessMessage(
              response.data["resultApi"]["message"],
            );
            toggleStatus();
          } else {
            DialogUtil.showErrorMessage(response.data["resultApi"]["message"]);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> toggleProductStatus({required bool availability}) async {
    EasyLoading.show();
    final data = {
      "productIds": listProductSelected.map((e) => e.id).toList(),
      "availability": availability,
    };
    print(data);
    await client
        .toggleProductPromotion(data: data)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["statusCode"] == 200) {
            fetchData();
            listProductSelected.clear();
            DialogUtil.showSuccessMessage(
              response.data["resultApi"]["message"],
            );
            toggleStatus();
          } else {
            DialogUtil.showErrorMessage(response.data["resultApi"]["message"]);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void diaLogDeletedProduct() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      title: Text(
        'Xoá sản phẩm'.tr,
        style: AppTextStyles.bold20().copyWith(
          color: AppColors.grayscaleColor80,
        ),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "confirm_delete_product".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Xoá sản phẩm'.tr,
      typeButtonLeft: AppButtonType.remove,
      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
        toggleStatus();
      },
      actionRight: () {
        deletedProduct();
      },
    );
  }

  Future<void> fetchListCategory() async {
    EasyLoading.show();
    await client
        .fetchListCategory(limit: 100)
        .then((response) {
          EasyLoading.dismiss();
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
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetCategory() {
    Get.bottomSheet(
      BottomsheetSelectedCategory(
        title: "category".tr,
        dataCustom: listCategory,
        onTap: (selectedItem) {
          selectedCategory.value = selectedItem;
          fetchData();
        },
        selectedItem: selectedCategory.value,
        onCancel: () {
          if (selectedCategory.value.isNotEmpty) {
            selectedCategory.value = [];
            fetchData();
          }
        },
      ),
      isScrollControlled: true,
    );
  }
}
