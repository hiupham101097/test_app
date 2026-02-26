import 'dart:ui';

import 'package:merchant/domain/data/models/transaction_model.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/data/models/transaction_wallet_in_model.dart';
import 'package:merchant/style/app_colors.dart';

enum DetailTransactionCondition { deposit, withdraw, convert }

class DetailTransactionController extends GetxController {
  final ApiClient client = ApiClient();

  final detailTransactionDiscount = TransactionModel().obs;
  final detailTransactionIn = TransactionWalletInModel().obs;
  final type = Rxn<String>();

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null && Get.arguments['transactionIn'] != null) {
      detailTransactionIn.value = Get.arguments['transactionIn'];
    }
    if (Get.arguments != null && Get.arguments['transactionDiscount'] != null) {
      detailTransactionDiscount.value = Get.arguments['transactionDiscount'];
    }
    if (Get.arguments != null && Get.arguments['type'] != null) {
      type.value = Get.arguments['type'];
    }
    print('detailTransactionIn: ${detailTransactionIn.value.transId}');
    print('type: ${type.value}');
  }

  String getTitleTransaction() {
    switch (type.value.toString().toLowerCase()) {
      case 'deposit':
        return 'Nạp tiền';
      case 'withdraw':
        return 'Rút tiền';
      case 'internalwithdraw' || 'internaldeposit':
        return 'Chuyển đổi';
      case 'refundcommission':
        return 'Chiết khấu';
      case 'income':
        return 'Thanh toán đơn hàng';
      case 'commission':
        return 'Chiết khấu đơn hàng';
      default:
        return '';
    }
  }

  String getStatusTransaction(String status) {
    switch (status.toString().toLowerCase()) {
      case 'success':
        return 'Thành công';
      case 'pending':
        return 'Chờ xác nhận';
      case 'failed' || 'faild':
        return 'Thất bại';
      case 'cancelled':
        return 'Từ chối duyệt';
      default:
        return '';
    }
  }

  Color getColorStatusTransaction(String status) {
    switch (status.toString().toLowerCase()) {
      case 'success':
        return AppColors.successColor;
      case 'pending':
        return AppColors.grayscaleColor40;
      case 'failed' || 'faild':
        return AppColors.warningColor;
      case 'cancelled':
        return AppColors.warningColor;
      default:
        return AppColors.grayscaleColor40;
    }
  }
}
