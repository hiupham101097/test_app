import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';

import '../../constants/asset_constants.dart';

class VoucherDetailController extends GetxController {
  final ApiClient client = ApiClient();
  final idVoucher = 0.obs;
  final voucherDetail = PromotionModel().obs;
  final store = StoreModel().obs;
  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments['idVoucher'] != null) {
      idVoucher.value = Get.arguments['idVoucher'];
    }
    store.value = StoreDB().currentStore() ?? StoreModel();

    getDetailVoucher();
    super.onInit();
  }

  Future<void> getDetailVoucher() async {
    EasyLoading.show();

    client
        .getDetailVoucher(id: idVoucher.value)
        .then((response) {
          EasyLoading.dismiss();
          if (response.data['resultApi'] != null) {
            voucherDetail.value = PromotionModel.fromJson(
              response.data['resultApi'] as Map<String, dynamic>,
            );
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  onJoinVoucher() async {
    EasyLoading.show();
    final data = {
      "listPromotionIds": [
        {"id": idVoucher.value},
      ],
      "system": store.value.system[0]
    };
    client
        .joinVoucher(data: data)
        .then((response) async {
          if (response.data['resultApi']['status'] == 200) {
            eventBus.fire(PromotionEvent());
            DialogUtil.showSuccessMessage("join_voucher_success".tr);
            await getDetailVoucher();

            const highlightSlugs = {
              'quan-an-noi-bat',
              'deal-chop-nhoang',
              'deals-chop-nhoang',
              'bach-hoa-noi-bat',
            };

            final checkSlug = highlightSlugs.contains(voucherDetail.value.slug);
            if (checkSlug) {
              DialogUtil.showConfirmDialog(
                Get.context!,
                image: AssetConstants.icSuccess,
                title: "${"participated".tr} ${voucherDetail.value.name}",
                button: "close".tr,
                action: () {
                  Get.back();
                },
                isShowCancel: false,
              );
            } else {
              Get.toNamed(
                Routes.addProductPromotion,
                arguments: {'promotionId': idVoucher.value},
              );
            }
          } else {
            DialogUtil.showErrorMessage("join_voucher_failed".tr);
          }
          EasyLoading.dismiss();
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }
}
