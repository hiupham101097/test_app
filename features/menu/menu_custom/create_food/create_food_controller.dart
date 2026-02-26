import 'package:merchant/commons/types/status_enum_food.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/bottomsheet_custom_mutil.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/domain/data/models/variant_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/menu/menu_custom/create_food/widget/bottomsheet_add_variant.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

enum ProductType { create, edit }

class CreateFoodController extends GetxController {
  final ApiClient client = ApiClient();
  final FocusNode nameFocusNode = FocusNode();
  final FocusNode descriptionFocusNode = FocusNode();
  final FocusNode priceFocusNode = FocusNode();
  final FocusNode priceSaleFocusNode = FocusNode();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController priceSaleController = TextEditingController();
  final imageUrl = Rx<String?>(null);
  final isValidate = false.obs;
  final type = ProductType.create.obs;
  final listCategory = <CategoryModel>[].obs;
  final isLoading = false.obs;
  final total = 0.obs;
  final selectedCategory = Rx<CategoryModel?>(null);
  final optionProductData = <OptionProductModel>[].obs;
  final selectedOptionProducts = <OptionProductModel>[].obs;
  final optionProductFocusNode = FocusNode();
  final optionProductController = TextEditingController();
  final product = Rx<ProductModel?>(null);
  final pickedImages = Rx<XFile?>(null);
  final formKey = GlobalKey<FormState>();
  final selectedStatus = Rx<StatusEnumFood?>(StatusEnumFood.on);
  final listVariant = <VariantModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    nameController.addListener(() => actionValidate());
    descriptionController.addListener(() => actionValidate());
    priceController.addListener(() => actionValidate());
    priceSaleController.addListener(() => actionValidate());
    ever(selectedOptionProducts, (_) => actionValidate());
    ever(selectedCategory, (_) => actionValidate());
    ever(imageUrl, (_) => actionValidate());
    ever(pickedImages, (_) => actionValidate());
    initData();
  }

  void initData() async {
    await fetchListCategory();
    await fetchListOptionProduct();
    if (Get.arguments != null && Get.arguments['type'] != null) {
      type.value = Get.arguments['type'];
    }
    if (Get.arguments != null && Get.arguments['product'] != null) {
      product.value = Get.arguments['product'];
      nameController.text = product.value!.name;
      descriptionController.text = AppUtil().convertHtmlToPlainText(
        product.value!.description,
      );
      priceController.text = AppUtil.formatNumber(
        product.value!.price.toDouble(),
      );
      priceSaleController.text = AppUtil.formatNumber(
        product.value!.priceSale.toDouble(),
      );
      imageUrl.value = product.value!.imageUrlMap;
      selectedCategory.value =
          listCategory
              .where((e) => e.id == product.value!.categoryId)
              .firstOrNull;
      selectedOptionProducts.value = product.value!.productOptionFood;
      optionProductController.text = selectedOptionProducts
          .map((e) => e.name)
          .join(", ");
      selectedStatus.value = StatusEnumFood.values.firstWhere(
        (e) => e.getCode() == product.value!.availability,
      );
      listVariant.value = product.value!.variants;
    }
  }

  Future<void> fetchListCategory() async {
    EasyLoading.show();
    await client
        .fetchListCategory()
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

  Future<void> fetchListOptionProduct() async {
    EasyLoading.show();
    await client
        .fetchListOptionProduct(page: 1, limit: 200)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"]['optionFood'] != null) {
            optionProductData.assignAll(
              (response.data["resultApi"]['optionFood'] as List)
                  .map(
                    (e) =>
                        OptionProductModel.fromJson(e as Map<String, dynamic>),
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

  Future<void> getImageUrl({
    required XFile pickedImages,
    required String name,
  }) async {
    final image = await dio.MultipartFile.fromFile(
      pickedImages.path,
      filename: pickedImages.path.split('/').last,
    );

    final store = StoreDB().currentStore();
    final folderPath =
        'store/${store?.id ?? ""}/product/${AppUtil.generateSlug(name)}-${store?.slug ?? ""}';
    final formData = dio.FormData.fromMap({
      'file': image,
      'folderPath': folderPath,
      'organizationId': 1,
    });

    await client
        .getImageUrl(data: formData)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["folderPath"] != null) {
            imageUrl.value = response.data["folderPath"];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> addProduct() async {
    EasyLoading.show();
    if (pickedImages.value != null) {
      await getImageUrl(
        pickedImages: pickedImages.value!,
        name: nameController.text,
      );
    }
    if (imageUrl.value != null && imageUrl.value != "") {
      final data = {
        "name": nameController.text,
        "description": descriptionController.text,
        "short_description": descriptionController.text,
        "image_url": imageUrl.value?.split('/').last,
        "meta_title": nameController.text,
        "meta_keywords": nameController.text,
        "meta_description": descriptionController.text,
        "meta_slug": AppUtil.generateSlug(nameController.text),
        "price": double.tryParse(priceController.text.replaceAll(',', '')) ?? 0,
        "categoryId": selectedCategory.value?.id ?? "",
        "priceSale":
            double.tryParse(priceSaleController.text.replaceAll(',', '')) ?? 0,
        "system": selectedCategory.value?.system ?? "",
        "sale":
            ((1 -
                        ((double.tryParse(
                                  priceSaleController.text.replaceAll(',', ''),
                                ) ??
                                0) /
                            (double.tryParse(
                                  priceController.text.replaceAll(',', ''),
                                ) ??
                                1))) *
                    100)
                .toInt(),

        "availability": selectedStatus.value?.getCode() ?? false,
        "productoptionfood": [
          ...selectedOptionProducts.map((e) => {"id": e.id}).toList(),
        ],
        "variants": [...listVariant.map((e) => e.toJson()).toList()],
      };

      if (type.value == ProductType.create) {
        await client
            .createProduct(data: data)
            .then((response) {
              if (response.data["status"] == 200) {
                eventBus.fire(ProductEvent());
                DialogUtil.showSuccessMessage("add_product_success".tr);
                Get.back();
              }
              EasyLoading.dismiss();
            })
            .catchError((error, trace) {
              EasyLoading.dismiss();
              ErrorUtil.catchError(error, trace);
            });
      } else {
        await client
            .updateProduct(data: data, id: product.value!.id)
            .then((response) {
              if (response.data["status"] == 200) {
                eventBus.fire(ProductEvent());
                DialogUtil.showSuccessMessage("update_product_success".tr);
                Get.back();
              }
              EasyLoading.dismiss();
            })
            .catchError((error, trace) {
              EasyLoading.dismiss();
              ErrorUtil.catchError(error, trace);
            });
      }
    } else {
      DialogUtil.showErrorMessage("Vui lòng thử lại sau");
    }
  }

  Future<void> deleteProduct() async {
    EasyLoading.show();

    await client
        .deleteProduct(id: product.value!.id)
        .then((response) {
          if (response.data["status"] == 200) {
            eventBus.fire(ProductEvent());
            DialogUtil.showSuccessMessage("delete_product_success".tr);
            Get.back();
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetCategory() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "category".tr,
        dataCustom: listCategory.map((e) => e.name ?? "").toList(),
        onTap: (index) {
          selectedCategory.value = listCategory[index];
        },
        selectedItem: selectedCategory.value?.name ?? "",
      ),
      isScrollControlled: true,
    );
  }

  void showBottomSheetStatus() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "status".tr,
        dataCustom: StatusEnumFood.values.map((e) => e.getLabel()).toList(),
        onTap: (index) {
          selectedStatus.value = StatusEnumFood.values[index];
        },
        selectedItem: selectedStatus.value?.getLabel() ?? "",
      ),
      isScrollControlled: true,
    );
  }

  void showBottomSheetOptionProduct() {
    Get.bottomSheet(
      BottomsheetCustomMutilWidget(
        title: "Món ăn kèm".tr,
        dataCustom: optionProductData.map((e) => e.name).toList(),
        onConfirm: (indexes) {
          selectedOptionProducts.value =
              optionProductData
                  .where((e) => indexes.contains(optionProductData.indexOf(e)))
                  .toList();
          optionProductController.text = selectedOptionProducts
              .map((e) => e.name)
              .join(", ");
        },
        selectedItem: selectedOptionProducts.map((e) => e.name).toList(),
      ),
      isScrollControlled: true,
    );
  }

  void showBottomSheetAddVariant() {
    Get.bottomSheet(
      BottomsheetAddVariant(
        onConfirm: (variant) {
          listVariant.add(variant);
        },
      ),
      isScrollControlled: true,
    );
  }

  void deleteVariant(VariantModel variant) {
    listVariant.remove(variant);
  }

  void editVariant(VariantModel variant) {
    Get.bottomSheet(
      BottomsheetAddVariant(
        onConfirm: (variantItem) {
          listVariant.removeWhere((e) => e.title == variant.title);
          listVariant.add(variantItem);
        },
        variant: variant,
      ),
      isScrollControlled: true,
    );
  }

  void actionDelete() {
    if (product.value?.isDeleted ?? false) {
      DialogUtil.showConfirmDialog(
        Get.context!,
        image: AssetConstants.icWarning,
        title: "you_cannot_delete_product".tr,
        titleColor: AppColors.warningColor,
        description: "product_is_in_the_display_or_out_of_stock".tr,
        button: "back".tr,
        typeButton: AppButtonType.remove,
        action: () {
          Get.back();
        },
        isShowCancel: false,
      );
    } else {
      DialogUtil.showConfirmDialog(
        Get.context!,
        image: null,
        title: "delete_product".tr,
        titleColor: AppColors.grayscaleColor80,
        description: "are_you_sure_you_want_to_delete_this_product".tr,
        button: "delete_product".tr,
        action: () {
          deleteProduct();
        },
        isShowCancel: true,
      );
    }
  }

  void actionValidate() {
    final hasImage = imageUrl.value != null || pickedImages.value != null;
    final hasRequiredFields =
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty &&
        selectedCategory.value != null;

    if (hasImage && hasRequiredFields) {
      isValidate.value = true; // hợp lệ
    } else {
      isValidate.value = false; // không hợp lệ
    }
  }
}
