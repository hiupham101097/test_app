import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/evaluate_overview_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/user_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/auth/login/login_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';

class ProfileController extends GetxController {
  final store = StoreModel().obs;
  final ApiClient client = ApiClient();
  final evaluateOverview = EvaluateOverviewModel().obs;
  final canCelOrder = 0.obs;
  final completedOrder = 0.obs;
  final canceledByDriver = 0.obs;
  final EasyRefreshController controller = EasyRefreshController();

  @override
  void onInit() {
    super.onInit();
    store.value = StoreDB().currentStore() ?? StoreModel();
    if (store.value.id != 0) {
      getOrderStatistic();
    }
    eventBus.on<OderEvent>().listen((event) {
      getOrderStatistic();
    });
    eventBus.on<UpdateStoreEvent>().listen((event) {
      store.value = StoreDB().currentStore() ?? StoreModel();
    });
    fetchDataEvaluate();
  }

  Future<void> onRefresh() async {
    await Future.delayed(Duration(milliseconds: 1000));
    fetchDataEvaluate();
    getOrderStatistic();
    controller.resetLoadState();
    controller.finishRefresh();
  }

  Future<void> logout() async {
    EasyLoading.show();
    await client
        .logout()
        .then((response) {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            sl<LocalClient>().clearAccessToken();
            StoreDB().clear();
            UserDB().clear();
            WalletDB().clear();
            WalletDB().clearWalletUser();
            sl<LocalClient>().clearEmail();
            sl<LocalClient>().clearPassword();
            if (Get.isRegistered<LoginController>()) {
              Get.delete<LoginController>();
            }
            Get.offAllNamed(Routes.login);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> deleteAccount() async {
    EasyLoading.show();
    await client
        .deleteAccount()
        .then((response) {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            sl<LocalClient>().clearAccessToken();
            StoreDB().clear();
            UserDB().clear();
            WalletDB().clear();
            WalletDB().clearWalletUser();
            sl<LocalClient>().clearEmail();
            sl<LocalClient>().clearPassword();
            if (Get.isRegistered<LoginController>()) {
              Get.delete<LoginController>();
            }
            Get.offAllNamed(Routes.login);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> deleteAccountConfirm() async {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        'Xoá tài khoản'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Bạn có chắc chắn muốn xoá tài khoản không?".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),

      titleLeft: 'Hủy'.tr,
      titleRight: 'Xoá'.tr,
      typeButtonLeft: AppButtonType.remove,
      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        deleteAccount();
      },
    );
  }

  Future<void> logoutConfirm() async {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: null,
      title: Text(
        'Đăng xuất'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.primaryColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "Bạn có chắc chắn muốn đăng xuất tài khoản khỏi ứng không?".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'Hủy'.tr,
      titleRight: 'Đăng xuất'.tr,
      typeButtonLeft: AppButtonType.nomal,
      typeButtonRight: AppButtonType.outline,
      outlineColor: AppColors.primaryColor,
      actionLeft: () {
        Get.back();
      },
      actionRight: () {
        logout();
      },
    );
  }

  Future<void> fetchDataEvaluate() async {
    await client
        .fetchOverviewEvaluate()
        .then((response) {
          if (response.data["resultApi"] != null) {
            evaluateOverview.value = EvaluateOverviewModel.fromJson(
              response.data["resultApi"],
            );
          }
        })
        .catchError((error, trace) {
          ErrorUtil.catchError(error, trace);
        });
  }

  Future<void> getOrderStatistic() async {
    EasyLoading.show();
    await client
        .getOrderStatistic(organizationId: "1")
        .then((response) {
          EasyLoading.dismiss();
          if (response.statusCode == 200) {
            final data = response.data['resultApi'];
            canCelOrder.value = data['CANCELED'];
            completedOrder.value = data['COMPLETED'];
            canceledByDriver.value = data['DRIVER_CANCELED'];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
