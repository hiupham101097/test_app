import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/voucher_discount_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/domain/data/models/store_model.dart';

enum VoucherDateType { start, expiry }

class CreateVoucherController extends GetxController {
  final ApiClient client = ApiClient();
  final store = StoreModel().obs;
  VoucherDiscountModel? voucher;

  /// TEXT CONTROLLERS
  final nameController = TextEditingController();
  final discountController = TextEditingController();
  final usageCountController = TextEditingController();
  final usagePerUserController = TextEditingController();
  final minOrderController = TextEditingController();

  /// DATE
  final startDate = Rxn<DateTime>();
  final expiryDate = Rxn<DateTime>();

  /// STATUS
  final isActive = true.obs;

  /// CONSTANT
  final String code = "DISC-";
  final String type = "discount";
  final bool isShow = true;
  final String system = "1";

  bool get isUpdate => voucher != null;

  @override
  void onInit() {
    super.onInit();

    voucher = Get.arguments?["voucher"];
    store.value = StoreDB().currentStore() ?? StoreModel();
    if (voucher != null) {
      _fillData();
    }
  }

  void _fillData() {
    nameController.text = voucher?.name ?? "";
    discountController.text = "${voucher?.discountAmount ?? 0}";
    usageCountController.text = "${voucher?.usageCount ?? 0}";
    usagePerUserController.text = "${voucher?.usagePerUser ?? 1}";
    minOrderController.text = "${voucher?.minOrderValue ?? 0}";

    startDate.value = voucher?.startDate;

    if (voucher?.startDate != null && voucher?.usageCount != null) {
      expiryDate.value = voucher!.startDate!.add(
        Duration(days: voucher!.usageCount!),
      );
    }
  }

  Future<void> onSubmit() async {
    if (!_validate()) return;

    EasyLoading.show();

    final data = {
      "name": nameController.text,
      "code": generateVoucherCode(),
      "type": type,
      "startDate": startDate.value!.toUtc().toIso8601String(),
      "expiryDate": expiryDate.value!.toUtc().toIso8601String(),
      "usageCount": int.tryParse(usageCountController.text) ?? 0,
      "usagePerUser": int.tryParse(usagePerUserController.text) ?? 1,
      "minOrderValue": int.tryParse(minOrderController.text) ?? 0,
      "discountAmount": int.tryParse(discountController.text) ?? 0,
      "status": isActive.value ? "active" : "inactive",
      "isShow": isShow,
      "system": store.value.system.isNotEmpty ? store.value.system[0] : ["1"],
    };

    try {
      final response =
          isUpdate == false
              ? await client.createVoucher(data: data)
              : await client.updateVoucherDiscount(
                data: data,
                id: voucher!.id!,
              );

      if (response.data['status'] == 200) {
        if (isUpdate) {
          eventBus.fire(UpdateVoucherDiscountEvent());
        } else {
          eventBus.fire(CreateVoucherDiscountEvent());
        }
        // Get.back();

        DialogUtil.showSuccessMessage(
          isUpdate ? "Cập nhật voucher thành công" : "Tạo voucher thành công",
        );

        Get.back();
      } else {
        DialogUtil.showErrorMessage("Thao tác thất bại");
      }
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
    }

    EasyLoading.dismiss();
  }

  void actionDelete() {
    DialogUtil.showConfirmDialog(
      Get.context!,
      image: null,
      title: "delete_voucher".tr,
      titleColor: AppColors.grayscaleColor80,
      description: "are_you_sure_you_want_to_delete_this_voucher".tr,
      button: "delete_voucher".tr,
      action: () {
        onDeleteVoucher();
      },
      isShowCancel: true,
    );
  }

  Future<void> onDeleteVoucher() async {
  try {
    EasyLoading.show();
    final response = await client.deleteVoucherDiscount(id: voucher!.id!);
    final isSuccess = response.statusCode == 204 || response.statusCode == 20;
    if (isSuccess) {
      eventBus.fire(DeleteVoucherDiscountEvent());
      EasyLoading.dismiss(); 
      DialogUtil.showSuccessMessage("delete_voucher_discount_success".tr);
      Get.back(); 
    } else {
      EasyLoading.dismiss();
      String msg = response.data?["message"] ?? "Có lỗi xảy ra";
      DialogUtil.showErrorMessage(msg);
    }
  } catch (error, trace) {
    EasyLoading.dismiss();
    ErrorUtil.catchError(error, trace);
  }
}

  String generateVoucherCode({String prefix = "DISC"}) {
    final now = DateTime.now();

    final hour = now.hour.toString().padLeft(2, '0');
    final minute = now.minute.toString().padLeft(2, '0');
    final second = now.second.toString().padLeft(2, '0');

    final timePart = "$hour$minute$second";

    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand =
        List.generate(
          4,
          (index) =>
              chars[(chars.length *
                  (DateTime.now().microsecondsSinceEpoch + index) %
                  chars.length)],
        ).join();

    return "$prefix-$timePart-$rand";
  }

  bool _validate() {
    if (nameController.text.isEmpty) {
      DialogUtil.showErrorMessage("Vui lòng nhập tên voucher");
      return false;
    }

    if (startDate.value == null || expiryDate.value == null) {
      DialogUtil.showErrorMessage("Vui lòng chọn ngày");
      return false;
    }

    return true;
  }

  Future<void> pickDate(VoucherDateType type) async {
    final picked = await showDatePicker(
      context: Get.context!,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      if (type == VoucherDateType.start) {
        startDate.value = picked;
      } else {
        expiryDate.value = picked;
      }
    }
  }

  void onChangeStatus(bool value) {
    isActive.value = value;
  }
}
