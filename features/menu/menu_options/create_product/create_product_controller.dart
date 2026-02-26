import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/domain/data/models/option_product_model.dart';
import 'package:merchant/domain/database/store_db.dart';
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

enum CreateOptionProductType { create, edit }

class CreateProductController extends GetxController {
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
  final type = CreateOptionProductType.create.obs;
  final formKey = GlobalKey<FormState>();
  final optionProduct = Rx<OptionProductModel?>(null);
  final pickedImages = Rx<XFile?>(null);

  @override
  void onInit() {
    super.onInit();
    ever(imageUrl, (_) => actionValidate());
    nameController.addListener(() => actionValidate());
    descriptionController.addListener(() => actionValidate());
    priceController.addListener(() => actionValidate());
    ever(pickedImages, (_) => actionValidate());
    final args = Get.arguments;
    if (args != null && args['type'] != null) {
      type.value = args['type'];
    }
    if (args != null && args['optionProduct'] != null) {
      optionProduct.value = args['optionProduct'];
      nameController.text = optionProduct.value!.name;
      descriptionController.text = optionProduct.value!.description;
      priceController.text = AppUtil.formatNumber(
        optionProduct.value!.price.toDouble(),
      );
      priceSaleController.text = AppUtil.formatNumber(
        optionProduct.value!.priceSale.toDouble(),
      );
      imageUrl.value = optionProduct.value!.imageUrl;
      actionValidate();
    }
  }

  Future<void> getImageUrl({required XFile pickedImages}) async {
    final image = await dio.MultipartFile.fromFile(
      pickedImages.path,
      filename: pickedImages.path.split('/').last,
    );
    final id = StoreDB().currentStore()!.id;
    final folderPath =
        'store/$id/option_product/${AppUtil.generateSlug(nameController.text)}';
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

  Future<void> actionOptionProduct() async {
    EasyLoading.show();
    if (pickedImages.value != null) {
      await getImageUrl(pickedImages: pickedImages.value!);
    }
    if (imageUrl.value != null && imageUrl.value != "") {
      final data = {
        "name": nameController.text,
        "description": descriptionController.text,
        "image_url": imageUrl.value,
        "price": priceController.text.replaceAll(',', ''),
        "priceSale": priceSaleController.text.replaceAll(',', ''),
      };
      if (type.value == CreateOptionProductType.create) {
        await client
            .createOptionProduct(data: data)
            .then((response) {
              if (response.statusCode == 200) {
                eventBus.fire(OptionProductEvent());
                DialogUtil.showSuccessMessage("add_option_product_success".tr);
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
            .updateOptionProduct(data: data, id: optionProduct.value!.id)
            .then((response) {
              if (response.statusCode == 200 &&
                  response.data["status"] == 200) {
                eventBus.fire(OptionProductEvent());
                DialogUtil.showSuccessMessage(
                  "update_option_product_success".tr,
                );
                Get.back();
              } else {
                DialogUtil.showErrorMessage(response.data["message"]);
              }
              EasyLoading.dismiss();
            })
            .catchError((error, trace) {
              EasyLoading.dismiss();
              ErrorUtil.catchError(error, trace);
            });
      }
    } else {
      DialogUtil.showErrorMessage("Thất bại, Vui lòng thử lại sau");
    }
  }

  Future<void> deleteOptionProduct() async {
    EasyLoading.show();

    await client
        .deleteOptionProduct(id: optionProduct.value!.id)
        .then((response) {
          if (response.statusCode == 200 && response.data["status"] == 200) {
            eventBus.fire(OptionProductEvent());
            DialogUtil.showSuccessMessage("delete_option_product_success".tr);
            Get.back();
          } else {
            DialogUtil.showErrorMessage(response.data["message"]);
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void actionDelete() {
    DialogUtil.showConfirmDialog(
      Get.context!,
      image: null,
      title: "delete_product".tr,
      titleColor: AppColors.grayscaleColor80,
      description: "are_you_sure_you_want_to_delete_this_product".tr,
      button: "delete_product".tr,
      action: () {
        deleteOptionProduct();
        Get.back();
      },
      isShowCancel: true,
    );
  }

  void actionValidate() {
    final hasImage = imageUrl.value != null || pickedImages.value != null;
    final hasRequiredFields =
        nameController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        priceController.text.isNotEmpty;

    if (hasImage && hasRequiredFields) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }
}
