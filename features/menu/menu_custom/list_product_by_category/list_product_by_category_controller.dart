import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

class ListProductByCategoryController extends GetxController {
  final ApiClient client = ApiClient();
  final categoryId = ''.obs;
  final categoryName = ''.obs;

  final listProduct = <ProductModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['categoryId'] != null) {
      categoryId.value = Get.arguments['categoryId'];
    }
    if (Get.arguments != null && Get.arguments['name'] != null) {
      categoryName.value = Get.arguments['name'];
    }
    fetchListProductByCategory();
  }

  Future<void> fetchListProductByCategory() async {
    EasyLoading.show();
    await client
        .fetchListProductByCategory(categoryId: categoryId.value)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            listProduct.assignAll(
              (response.data["resultApi"] as List)
                  .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
                  .toList(),
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    if (newIndex < 0) newIndex = 0;
    if (newIndex > listProduct.length) newIndex = listProduct.length;
    final category = listProduct.removeAt(oldIndex);
    listProduct.insert(newIndex, category);
    update();
  }

  // Future<void> updateProduct(ProductModel category, int index) async {
  //   final data = {"id": category.id, "index": index};
  //   await client
  //       .updateCategory(data: data, id: category.id ?? "")
  //       .then((response) {
  //         if (response.statusCode == 200) {}
  //         fetchListCategory();
  //       })
  //       .catchError((error, trace) {
  //         ErrorUtil.catchError(error, trace);
  //       });
  // }
}
