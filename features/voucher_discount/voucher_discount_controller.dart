import 'dart:async';

import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/voucher_discount_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_controller.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_page.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/domain/data/models/store_model.dart';

class VoucherDiscountController extends GetxController {
  final ApiClient client = ApiClient();
  final store = StoreModel().obs;
  final loading = false.obs;
  final listVoucher = <VoucherDiscountModel>[].obs;
  final total = 0.obs;

  bool get isEmpty => listVoucher.isEmpty;

  late StreamSubscription createSub;
  late StreamSubscription updateSub;

  @override
  void onInit() {
    super.onInit();
    store.value = StoreDB().currentStore() ?? StoreModel();
    fetchData();

    createSub = eventBus.on<CreateVoucherDiscountEvent>().listen((event) {
      fetchData();
    });

    updateSub = eventBus.on<UpdateVoucherDiscountEvent>().listen((event) {
      fetchData();
    });
  }

  @override
  void onClose() {
    createSub.cancel();
    updateSub.cancel();
    super.onClose();
  }

  /// ==========================
  /// FETCH LIST
  /// ==========================

  Future<void> fetchData() async {
    try {
      loading.value = true;
      EasyLoading.show();

      final response = await client.fetchListVoucherDiscount(storeId: store.value.id);

      final data = response.data["resultApi"];

      if (data != null && data["data"] != null) {
        listVoucher.assignAll(
          (data["data"] as List)
              .map(
                (e) => VoucherDiscountModel.fromJson(e as Map<String, dynamic>),
              )
              .toList(),
        );

        total.value = data["total"] ?? 0;
      }
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
    } finally {
      loading.value = false;
      EasyLoading.dismiss();
    }
  }

  /// ==========================
  /// CREATE
  /// ==========================

  void createVoucher() {
    Get.toNamed(Routes.createVoucher);
  }

  /// ==========================
  /// EDIT
  /// ==========================

  void openVoucher(VoucherDiscountModel voucher) {
    Get.to(
      () => const CreateVoucherPage(),
      arguments: {"voucher": voucher},
      binding: BindingsBuilder(() {
        Get.put(CreateVoucherController());
      }),
    );
  }

  /// ==========================
  /// DELETE
  /// ==========================

  Future<void> deleteVoucher(String id) async {
    try {
      EasyLoading.show();

      final response = await client.deleteVoucherDiscount(id: id);

      if (response.data["resultApi"]["status"] == 200) {
        DialogUtil.showSuccessMessage("Xóa voucher thành công");

        fetchData();
      } else {
        DialogUtil.showErrorMessage("Xóa voucher thất bại");
      }
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
    } finally {
      EasyLoading.dismiss();
    }
  }
}
