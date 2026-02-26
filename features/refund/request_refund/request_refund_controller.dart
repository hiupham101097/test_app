import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/domain/data/models/order_refund_detail_model.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart' as dio;

enum RequestRefundTabEnum { sentRequest, result, confirm }

class RequestRefundController extends GetxController {
  final ApiClient client = ApiClient();
  final codeFocusNode = FocusNode();
  final codeController = TextEditingController();
  final titleFocusNode = FocusNode();
  final titleController = TextEditingController();
  final descriptionFocusNode = FocusNode();
  final descriptionController = TextEditingController();
  final serviceItems = ['Giao đồ ăn', 'Đi chợ'];

  final selectedservice = Rx<String?>(null);
  final pickedImages = <XFile>[].obs;
  final formKey = GlobalKey<FormState>();
  final isDisable = false.obs;
  final order = OrderModel().obs;
  final orderRefundDetail = OrderRefundDetailModel().obs;
  final listImages = <String>[].obs;
  final type = RequestRefundTabEnum.result.obs;
  final isReadonly = false.obs;
  final listReason = <String>[].obs;
  final selectedProblem = Rx<String?>(null);

  @override
  void onInit() {
    super.onInit();
    codeController.addListener(() {
      isValidate();
    });

    descriptionController.addListener(() {
      isValidate();
    });

    titleController.addListener(() {
      isValidate();
    });
    ever(selectedProblem, (value) {
      isValidate();
    });

    if (Get.arguments != null) {
      order.value = Get.arguments['order'];
      type.value = Get.arguments['type'];
      isReadonly.value = type.value == RequestRefundTabEnum.sentRequest;
      print(type.value);
      initData();
    }
  }

  Future<void> initData() async {
    await fetchReason();
    codeController.text = '#${order.value.orderId}';
    selectedservice.value = serviceItems[0];
    if (type.value != RequestRefundTabEnum.sentRequest) {
      await fetchData();
      titleController.text = orderRefundDetail.value.title;
      descriptionController.text = orderRefundDetail.value.description;
      listImages.value = orderRefundDetail.value.images;
      selectedProblem.value =
          listReason
              .where(
                (element) => element.contains(orderRefundDetail.value.problem),
              )
              .firstOrNull;
    }
  }

  Future<void> fetchReason() async {
    EasyLoading.show();
    await client
        .oderRefundReason()
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            listReason.value =
                (response.data["resultApi"] as List<dynamic>?)
                    ?.map((e) => e as String)
                    .toList() ??
                [];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> fetchData() async {
    EasyLoading.show();
    await client
        .oderRefundDetail(idOder: order.value.orderId)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            orderRefundDetail.value = OrderRefundDetailModel.fromJson(
              response.data["resultApi"],
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> createRequestRefund() async {
    EasyLoading.show();
    try {
      final images = await Future.wait(
        pickedImages.map(
          (e) async => await dio.MultipartFile.fromFile(
            e.path,
            filename: e.path.split('/').last,
          ),
        ),
      );

      final formData = dio.FormData.fromMap({
        'userId': UserDB().currentUser()!.id.toString(),
        'orderId': order.value.orderId,
        'system_type': '1',
        'title': titleController.text,
        'description': descriptionController.text,
        'problem': selectedProblem.value,
      });

      for (var file in images) {
        formData.files.add(MapEntry('images', file));
      }
      final response = await client.createRequestRefund(data: formData);

      if (response.statusCode == 200) {
        eventBus.fire(OrderRefundUpdateEvent());
        DialogUtil.showSuccessMessage("create_request_refund_success".tr);
        Get.back();
      }
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
    } finally {
      EasyLoading.dismiss();
    }
  }

  void actionValidate() {
    isValidate();
  }

  void actionBack() {
    if (!isReadonly.value) {
      Get.back();
    } else {
      DialogUtil.showConfirmDialog(
        Get.context!,
        image: null,
        title: "you_have_not_completed_information".tr,
        titleColor: AppColors.grayscaleColor80,
        description: "you_have_not_completed_information_desc".tr,
        button: 'continue_text'.tr,
        action: () {
          Get.back();
        },
        isShowCancel: true,
      );
    }
  }

  Future<void> updateRequestRefund({required String status}) async {
    EasyLoading.show();
    await client
        .updateRequestRefund(idOder: order.value.orderId, status: status)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            eventBus.fire(OrderRefundUpdateEvent());
            DialogUtil.showSuccessMessage("update_request_refund_success".tr);
            Get.back();
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void showBottomSheetCustom() {
    Get.bottomSheet(
      BottomsheetCustomWidget(
        title: "problem".tr,
        dataCustom: listReason,
        onTap: (index) {
          selectedProblem.value = listReason[index];
        },
        selectedItem: selectedProblem.value ?? '',
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }

  bool isValidate() {
    if (codeController.text.isNotEmpty &&
        selectedProblem.value != null &&
        selectedservice.value != null &&
        titleController.text.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        selectedProblem.value != null &&
        pickedImages.isNotEmpty) {
      isDisable.value = true;
    } else {
      isDisable.value = false;
    }
    return isDisable.value;
  }
}
