import 'package:flutter/material.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/bottomsheet_update_voucher.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class AddProductPromotionController extends GetxController {
  final ApiClient client = ApiClient();
  final promotionId = 0.obs;
  final promotionDetail = PromotionModel().obs;
  final total = 0.obs;
  final isLoading = false.obs;
  final page = 1.obs;
  final listProductData = <ProductModel>[].obs;
  final listProductGroupByCategory = <ProductGroupCategoryModel>[].obs;
  final EasyRefreshController controller = EasyRefreshController();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['promotionId'] != null) {
      promotionId.value = Get.arguments['promotionId'];
      fetchProductPromotionDetail();
    }
    eventBus.on<ProductPromotionEvent>().listen((event) {
      fetchProductPromotionDetail();
    });
  }

  Future<void> deleteProduct(String productId) async {
    EasyLoading.show();
    final data = {
      "promotionId": promotionId.value,
      "listProductIds": [
        {"productId": productId},
      ],
    };
    await client
        .deleteProductPromotion(data: data)
        .then((response) {
          if (response.data["resultApi"] != null) {
            DialogUtil.showSuccessMessage(
              "delete_product_promotion_success".tr,
            );
            fetchProductPromotionDetail();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          isLoading.value = false;
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> updateProduct(
    String productId,
    int quantity,
    int priceSalePromotion,
    int price,
  ) async {
    EasyLoading.show();
    final data = {
      "promotionId": promotionId.value,
      "listProductIds": [
        {
          "productId": productId,
          "sale_promotion":
              (((price - priceSalePromotion) / price) * 100).toInt(),

          "quantity_promotion": quantity,
          "priceSale_promotion": priceSalePromotion,
        },
      ],
    };
    await client
        .updateProductPromotion(data: data)
        .then((response) {
          if (response.data["resultApi"] != null) {
            DialogUtil.showSuccessMessage("update_success".tr);
            fetchProductPromotionDetail();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          isLoading.value = false;
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchProductPromotionDetail() async {
    EasyLoading.show();
    isLoading.value = true;
    await client
        .fetchProductPromotionDetail(id: promotionId.value)
        .then((response) {
          if (response.data["resultApi"] != null) {
            promotionDetail.value = PromotionModel.fromJson(
              response.data["resultApi"],
            );
          }
          listProductData.assignAll(
            (response.data["resultApi"]["products"] as List)
                .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                .toList(),
          );
          listProductGroupByCategory.value = AppUtil.groupByCategory(
            listProductData,
          );
          isLoading.value = false;
          total.value = response.data["resultApi"]["total"];
          EasyLoading.dismiss();
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
        .fetchProductPromotionDetail(id: promotionId.value, page: nextPage)
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

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    controller.resetLoadState();
    controller.finishRefresh();
    isLoading.value = true;
    page.value = 1;
    total.value = 0;
    listProductData.clear();
    listProductGroupByCategory.clear();
    fetchProductPromotionDetail();
  }

  void showBottomSheetUpdateVoucher(ProductModel dataUpdate) {
    Get.bottomSheet(
      BottomsheetUpdateVoucher(
        title: "Nhập thông tin quảng cáo",
        dataUpdate: dataUpdate,
        onTap: (priceSalePromotion, quantityPromotion) {
          updateProduct(
            dataUpdate.id,
            quantityPromotion,
            int.tryParse(priceSalePromotion) ?? 0,
            dataUpdate.price,
          );
          Get.back();
        },
      ),
      isScrollControlled: true,
    );
  }

  void diaLogDeletedProduct(ProductModel dataUpdate) {
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
        "Bạn có chắc chắn muốn xoá sản phẩm này không?",
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Xoá sản phẩm'.tr,
      typeButtonLeft: AppButtonType.nomal,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        deleteProduct(dataUpdate.id);
      },
    );
  }
}
