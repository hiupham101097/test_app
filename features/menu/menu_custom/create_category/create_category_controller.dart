import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/category_sestym_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/menu/menu_custom/list_category/list_category_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';

enum CreateCategoryType { create, edit }

class CreateCategoryController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode categoryNameFocusNode = FocusNode();
  final TextEditingController categoryNameController = TextEditingController();
  final selectedCategorySestym = Rx<CategorySestymModel?>(null);
  final createCategoryType = CreateCategoryType.create.obs;
  final listCategorySestym = <CategorySestymModel>[].obs;
  final isValidate = false.obs;
  final category = Rx<CategoryModel?>(null);
  final listSystem = <String>[].obs;
  final systemFocusNode = FocusNode();
  final systemController = TextEditingController();
  final system = Rx<String?>(null);
  @override
  void onInit() {
    super.onInit();

    if (Get.arguments != null && Get.arguments['createCategoryType'] != null) {
      createCategoryType.value = Get.arguments['createCategoryType'];
    }
    if (Get.arguments != null && Get.arguments['category'] != null) {
      category.value = Get.arguments['category'];
      categoryNameController.text = category.value!.name ?? "";
    }
    listSystem.value = StoreDB().getSystem();
    if (createCategoryType.value == CreateCategoryType.create) {
      if (listSystem.length == 1) {
        systemController.text = gettitleSystem(listSystem.first);
        system.value = listSystem.first;
        fetchCategoryByStore(int.parse(listSystem.first));
      }
    } else {
      initData();
    }
    categoryNameController.addListener(checkValid);
    ever(selectedCategorySestym, (_) => checkValid());
  }

  Future<void> initData() async {
    systemController.text = gettitleSystem(category.value?.system ?? "");
    system.value = category.value?.system ?? "";
    await fetchCategoryByStore(int.parse(category.value?.system ?? "0"));
    if (Get.arguments != null &&
        Get.arguments['categorySestym'] != null &&
        listCategorySestym.isNotEmpty) {
      selectedCategorySestym.value =
          listCategorySestym
              .where((e) => e.id == Get.arguments['categorySestym'])
              .firstOrNull;
    }
  }

  void checkValid() {
    if (categoryNameController.text.isNotEmpty &&
        selectedCategorySestym.value != null) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }

  Future<void> fetchCategoryByStore(int system) async {
    EasyLoading.show();
    await client
        .fetchListCategoryByStore(system: system, limit: 99)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]['storeSystemCategory'] != null) {
            listCategorySestym.assignAll(
              (response.data["resultApi"]['storeSystemCategory'] as List)
                  .map(
                    (e) =>
                        CategorySestymModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> addCategory() async {
    EasyLoading.show();
    final data = {
      "name": categoryNameController.text,
      "systemcategoryId": selectedCategorySestym.value?.id,
      "system": system.value,
    };
    await client
        .addCategory(data: data)
        .then((response) {
          if (response.statusCode == 200 &&
              response.data["message"] == "Success") {
            eventBus.fire(CategoryEvent());
            DialogUtil.showSuccessMessage("Thêm danh mục thành công".tr);
            Get.offNamed(Routes.listCategory);
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> deleteCategory() async {
    EasyLoading.show();

    await client
        .deleteCategory(id: category.value?.id ?? "")
        .then((response) {
          if (response.statusCode == 200) {
            eventBus.fire(CategoryEvent());
            DialogUtil.showSuccessMessage("Xoá danh mục thành công".tr);
            Get.back();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> updateCategory() async {
    EasyLoading.show();
    final data = {
      "id": category.value?.id,
      "name": categoryNameController.text,
      "systemcategoryId": selectedCategorySestym.value?.id,
      "system": system.value,
    };
    await client
        .updateCategory(data: data, id: category.value?.id ?? "")
        .then((response) {
          if (response.statusCode == 200) {
            eventBus.fire(CategoryEvent());
            DialogUtil.showSuccessMessage("Cập nhật danh mục thành công".tr);
            Get.back();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void diaLogDeleteCategory() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      title: Text(
        'delete_category'.tr,
        style: AppTextStyles.bold20().copyWith(
          color: AppColors.grayscaleColor80,
        ),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Bạn có chắc chắn muốn xoá danh mục này không?",
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'cancel'.tr,
      titleRight: 'delete_category'.tr,
      typeButtonLeft: AppButtonType.nomal,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        deleteCategory();
      },
    );
  }

  void showBottomSheetCategory() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "category".tr,
        dataCustom: listCategorySestym.map((e) => e.name ?? "").toList(),
        onTap: (index) {
          selectedCategorySestym.value = listCategorySestym[index];
        },
        selectedItem: selectedCategorySestym.value?.name ?? "",
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  void showBottomSheetSystem() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "Lĩnh vực hoạt động".tr,
        dataCustom:
            listSystem.map((e) => gettitleSystem(e)).toList().reversed.toList(),
        onTap: (index) {
          systemController.text = gettitleSystem(
            listSystem.reversed.toList()[index],
          );
          system.value = listSystem.reversed.toList()[index];
          listCategorySestym.clear();
          selectedCategorySestym.value = null;
          fetchCategoryByStore(int.parse(listSystem.reversed.toList()[index]));
        },
        selectedItem: gettitleSystem(system.value ?? ""),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  String gettitleSystem(String system) {
    switch (system) {
      case "1":
        return "Quán ăn";
      case "2":
        return "Bách hoá";
      default:
        return "";
    }
  }
}
