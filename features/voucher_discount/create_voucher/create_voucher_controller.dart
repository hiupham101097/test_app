import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merchant/commons/views/bottomsheet_custom_widget.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/category_sestym_model.dart';
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
  final _moneyFormat = NumberFormat("#,###");
  final _dateFormat = DateFormat('dd/MM/yyyy');

  /// TEXT CONTROLLERS
  final typeController = TextEditingController();
  final codeController = TextEditingController();
  final nameController = TextEditingController();
  final discountController = TextEditingController();
  final usageCountController = TextEditingController();
  final usagePerUserController = TextEditingController();
  final minOrderController = TextEditingController();
  final systemController = TextEditingController();
  final startDateController = TextEditingController();
  final expiryDateController = TextEditingController();
  final TextEditingController categoryNameController = TextEditingController();

  final typeFocusNode = FocusNode();
  final codeFocusNode = FocusNode();
  final nameFocusNode = FocusNode();
  final discountFocusNode = FocusNode();
  final usageCountFocusNode = FocusNode();
  final usagePerFocusNode = FocusNode();
  final minOrderFocusNode = FocusNode();
  final startDateFocusNode = FocusNode();
  final expiryDateFocusNode = FocusNode();
  final systemFocusNode = FocusNode();

  /// DATE
  final startDate = Rxn<DateTime>();
  final expiryDate = Rxn<DateTime>();

  final listCategorySestym = <CategorySestymModel>[].obs;
  final selectedCategorySestym = Rx<CategorySestymModel?>(null);

  /// STATUS
  final isActive = true.obs;
  final listSystem = <String>[].obs;
  final system = Rx<String?>(null);

  /// CONSTANT
  final String code = "DISC-";
  final String type = "discount";
  final bool isShow = true;

  final isValidate = false.obs;
  bool get isUpdate => voucher != null;

  @override
  void onInit() {
    super.onInit();

    voucher = Get.arguments?["voucher"];
    store.value = StoreDB().currentStore() ?? StoreModel();
    typeController.text = "Giảm giá";
    codeController.text = "DISC-";
    if (voucher != null) {
      _fillData();
    }
    listSystem.value = StoreDB().getSystem();

    formatNumber(discountController);
    formatNumber(usageCountController);
    formatNumber(usagePerUserController);
    formatNumber(minOrderController);

    ever(selectedCategorySestym, (_) => checkValid());
  }

  void _fillData() {
    typeController.text = "Giảm giá";
    codeController.text = "DISC-";
    nameController.text = voucher?.name ?? "";
    discountController.text = "${voucher?.discountAmount ?? 0}";
    usageCountController.text = "${voucher?.usageCount ?? 0}";
    usagePerUserController.text = "${voucher?.usagePerUser ?? 1}";
    minOrderController.text = "${voucher?.minOrderValue ?? 0}";

    startDate.value = voucher!.startDate;
    expiryDate.value = voucher!.endDate!;

    if (voucher!.startDate != null) {
      startDateController.text = _dateFormat.format(voucher!.startDate!);
    }

    if (voucher!.endDate != null) {
      expiryDateController.text = _dateFormat.format(voucher!.endDate!);
    }

    /// SYSTEM
    if (store.value.system.length > 1) {
      final voucherSystem = voucher?.system;

      if (voucherSystem != null && voucherSystem.isNotEmpty) {
        system.value = voucherSystem;
        systemController.text = gettitleSystem(voucherSystem);
      }
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

  Future<void> onSubmit() async {
    if (!_validate()) return;

    EasyLoading.show();

    final data = {
      "name": nameController.text,
      "code": generateVoucherCode(),
      "type": type,
      "startDate": startDate.value!.toIso8601String(),
      "expiryDate": expiryDate.value!.toIso8601String(),
      "usageCount":
          int.tryParse(usageCountController.text.replaceAll(",", "")) ?? 0,
      "usagePerUser":
          int.tryParse(usagePerUserController.text.replaceAll(",", "")) ?? 1,
      "minOrderValue":
          int.tryParse(minOrderController.text.replaceAll(",", "")) ?? 0,
      "discountAmount":
          int.tryParse(discountController.text.replaceAll(",", "")) ?? 0,
      "status": isActive.value ? "active" : "inactive",
      "isShow": isShow,
      "system":
          system.value ??
          (store.value.system.isNotEmpty ? store.value.system[0] : ["1"]),
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
        startDateController.text = _dateFormat.format(picked);
      } else {
        expiryDate.value = picked;
        expiryDateController.text = _dateFormat.format(picked);
      }
    }
  }

  void onChangeStatus(bool value) {
    isActive.value = value;
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

  void formatNumber(TextEditingController controller) {
    controller.addListener(() {
      String text = controller.text.replaceAll(",", "");

      if (text.isEmpty) return;

      final number = int.tryParse(text);
      if (number == null) return;

      final newText = _moneyFormat.format(number);

      if (controller.text != newText) {
        controller.value = TextEditingValue(
          text: newText,
          selection: TextSelection.collapsed(offset: newText.length),
        );
      }
    });
  }
}
