import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dio;
import 'package:merchant/domain/database/store_db.dart';

import 'base_client.dart';

class ApiClient extends BaseClient {
  final client = BaseClient.instance;
  final system = StoreDB().getSystem();
  Future<Response> fetchListMyOrders({
    required String status,
    int? limit = 20,
    int? page = 1,
  }) async {
    final params = <String, String>{};
    if (limit != null) params['pageSize'] = limit.toString();
    if (page != null) params['pageCurrent'] = page.toString();
    params['optionExtend'] = status;
    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return client.get('$apiHostOrder/api/mobile/order?$query');
  }

  Future<Response> fetchOrderRefundByStore({
    List<String>? status,
    int? limit = 20,
    int? page = 1,
  }) async {
    final sort = [
      {"key": "organizationId", "value": 1},
      {"key": "orderStatus", "value": status},
    ];
    final optionExtend = jsonEncode(sort);
    return client.get(
      '$apiHostOrder/api/mobile/order/getOrderRefundByStoreIdV1?pageSize=$limit&pageCurrent=$page&optionExtend=$optionExtend',
    );
  }

  Future<Response> oderDetail({required String idOder}) async {
    final system = idOder.split('-')[0];
    return client.get(
      '$apiHostOrder/api/mobile/order/details/$idOder?system=${system.toUpperCase() == "MKT" ? "2" : "1"}',
    );
  }

  Future<Response> oderRefundDetail({required String idOder}) async {
    return client.get('$apiHostOrder/api/mobile/order/order-refund/$idOder');
  }

  Future<Response> registerStoreFormData({
    required dio.FormData formData,
  }) async {
    return client.post(
      '$apiHostPartner/api/v1/mobile/stores/storeRegister',
      data: formData,
      extraHeaders: <String, dynamic>{},
    );
  }

  Future<Response> updateRejectStore({
    required dio.FormData formData,
    required String idStore,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/stores/update-reject/$idStore',
      data: formData,
    );
  }

  Future<Response> updateStore({
    required dio.FormData formData,
    required String idStore,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/stores/update-store/$idStore',
      data: formData,
    );
  }

  Future<Response> fetchListCategorySestym({
    int? limit = 20,
    int? page = 1,
    int? system,
  }) async {
    return client.get(
      '$apiHostPartner/api/mobile-app/systemcategories?pageCurrent=$page&pageSize=$limit&sortList=[{"key":"system","value":"$system"}]',
    );
  }

  Future<Response> fetchListCategoryByStore({
    int? limit = 20,
    int? page = 1,
    int? system,
  }) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/system-categories?pageCurrent=$page&pageSize=$limit&system=$system',
    );
  }

  Future<Response> fetchCategoryDetail({required String id}) async {
    return client.get('$apiHostPartner/api/v1/mobile/category/$id');
  }

  Future<Response> fetchListLocation({required String search}) async {
    final searchKeyword = Uri.encodeComponent(search);

    return client.get(
      '$apiHostSso/api/v1/mobile/location/search?keyword=$searchKeyword',
    );
  }

  Future<Response> fetchListVoucher({int? limit = 20, int? page = 1}) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/promotionMerchant?pageCurrent=$page&pageSize=$limit&system=[{"key": "system", "value": $system}]',
    );
  }

  Future<Response> fetchdeposit() async {
    return client.get('$apiHostSso/api/v1/mobile/employ/get-wallet');
  }

  Future<Response> fetchListCategory({int? limit = 20, int? page = 1}) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/category?pageCurrent=$page&pageSize=$limit&index=desc&sortList=[{"key":"system","value":$system}]',
    );
  }

  Future<Response> fetchListProductByCategory({
    required String categoryId,
  }) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/product/categoryId/$categoryId',
    );
  }

  Future<Response> fetchOverviewEvaluate({
    int? limit = 20,
    int? page = 1,
    List<String>? listProductId,
  }) async {
    final params = <String, String>{};

    if (page != null) params['pageCurrent'] = page.toString();
    if (limit != null) params['pageSize'] = limit.toString();
    if (listProductId != null && listProductId.isNotEmpty) {
      params['listProductId'] = jsonEncode(listProductId);
    }

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    return client.get(
      '$apiHostPartner/api/v1/mobile/commentMerchant/storeComment?$query',
    );
  }

  Future<Response> addCategory({required Map<String, dynamic> data}) async {
    return client.post('$apiHostPartner/api/v1/mobile/category', data: data);
  }

  Future<Response> createProduct({required Map<String, dynamic> data}) async {
    return client.post('$apiHostPartner/api/v1/mobile/product', data: data);
  }

  Future<Response> updateProduct({
    required Map<String, dynamic> data,
    required String id,
  }) async {
    return client.put('$apiHostPartner/api/v1/mobile/product/$id', data: data);
  }

  Future<Response> deleteProduct({required String id}) async {
    return client.delete('$apiHostPartner/api/v1/mobile/product/$id');
  }

  Future<Response> createOptionProduct({
    required Map<String, dynamic> data,
  }) async {
    return client.post(
      '$apiHostPartner/api/v1/mobile/optionFoodMerchant',
      data: data,
    );
  }

  Future<Response> updateOptionProduct({
    required Map<String, dynamic> data,
    required String id,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/optionFoodMerchant/$id',
      data: data,
    );
  }

  Future<Response> deleteOptionProduct({required String id}) async {
    return client.delete(
      '$apiHostPartner/api/v1/mobile/optionFoodMerchant/hard/$id',
    );
  }

  Future<Response> deleteCategory({required String id}) async {
    return client.delete('$apiHostPartner/api/v1/mobile/category/$id');
  }

  Future<Response> updateCategory({
    required Map<String, dynamic> data,
    required String id,
  }) async {
    return client.put('$apiHostPartner/api/v1/mobile/category/$id', data: data);
  }

  Future<Response> cancelOder({
    required String idOder,
    String? reason,
    required String orderId,
  }) async {
    final system = orderId.split('-')[0];
    return client.put(
      '$apiHostOrder/api/mobile/order/cancel/$idOder?reason=$reason&system=${system.toUpperCase() == "MKT" ? "2" : "1"}',
    );
  }

  Future<Response> upDateStatusDriver({
    required String idOder,
    Map<String, dynamic>? data,
  }) async {
    return client.put(
      '$apiHostOrder/api/order/updateOrderStatusDriver/updateStatusDriver/$idOder',
      data: data,
    );
  }

  Future<Response> upDateStatusTransportOrder({
    required String transportOrderId,
    required String statusDriver,
  }) async {
    return client.put(
      '$apiHostOrder/api/mobile/order/update-driver-status?transportOrderId=$transportOrderId&statusDriver=$statusDriver',
    );
  }

  Future<Response> confirmOder({
    required String idOder,
    Map<String, dynamic>? data,
  }) async {
    final system = idOder.split('-')[0];
    return client.put(
      '$apiHostOrder/api/mobile/order/updateOrderStatus/$idOder?system=${system.toUpperCase() == "MKT" ? "2" : "1"}',
      data: data,
    );
  }

  Future<Response> getRealTime() async {
    return client.get('$apiHostWallet/api/client/v1/Security/current-time');
  }

  Future<Response> getCancelOrderReasons() async {
    return client.get('$apiHostOrder/api/mobile/order/getCancelReasons');
  }

  Future<Response> getListChanel({required dynamic headers}) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Brand/get-list-chanel',
      extraHeaders: headers,
    );
  }

  Future<Response> addBank({
    required dynamic headers,
    required String data,
  }) async {
    return client.post(
      '$apiHostWallet/api/client/v1/WalletBank/create',
      extraHeaders: headers,
      data: {'data': data},
    );
  }

  Future<Response> getListBank({
    required dynamic headers,
    int? pageSize = 100,
    int? pageCurrent = 1,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Bank/get-list-bank?pageSize=$pageSize&pageCurrent=$pageCurrent',
      extraHeaders: headers,
    );
  }

  Future<Response> getByPhone({
    required dynamic headers,
    required String phone,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Wallet/get-by-phone?phoneNumber=$phone',
      extraHeaders: headers,
    );
  }

  Future<Response> login({
    required String phone,
    required String password,
    required String device,
    required String fcmToken,
  }) async {
    return client.post(
      '$apiHostSso/api/v1/mobile/employ/login',
      data: {
        "emailOrPhone": phone,
        "password": password,
        "fcm_token": fcmToken,
        "device": device,
      },
    );
  }

  Future<Response> getInfoUser({required String token}) async {
    return client.get(
      '$apiHostSso/api/v1/mobile/employ/verify-merchant',
      extraHeaders: {'Authorization': 'Bearer $token'},
    );
  }

  Future<Response> createWallet({
    required dynamic headers,
    required String data,
  }) async {
    return client.post(
      '$apiHostWallet/api/client/v1/Wallet/create',
      extraHeaders: headers,
      data: {'data': data},
    );
  }

  Future<Response> sendOtp({required String key, String? channel}) async {
    return client.post(
      '$apiHostSso/api/v1/mobile/employ/send-otp',
      data: {if (channel != null) 'channel': channel, 'key': key},
    );
  }

  Future<Response> changePassword({
    required String key,
    String? password,
  }) async {
    return client.put(
      '$apiHostSso/api/v1/mobile/employ/forgot-password/$key',
      data: {'newPassword': password},
    );
  }

  Future<Response> verifyOtp({
    required String key,
    String? channel,
    required String otp,
  }) async {
    return client.post(
      '$apiHostSso/api/v1/mobile/employ/verify-otp',
      data: {
        if (channel != null && channel != '') 'channel': channel,
        'key': key,
        'otp': otp,
      },
    );
  }

  Future<Response> registerUser(Map<String, dynamic> data) async {
    return client.post('$apiHostSso/api/v1/mobile/employ/register', data: data);
  }

  Future<Response> deleteBank({
    required dynamic headers,
    required String walletBankId,
  }) async {
    return client.delete(
      '$apiHostWallet/api/client/v1/WalletBank/delete?walletBankId=$walletBankId',
      extraHeaders: headers,
    );
  }

  Future<Response> getHistoryTransaction({
    required dynamic headers,
    required String walletId,
    int page = 0,
    int pageSize = 20,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Transaction/get-transaction-by-walletId?walletId=$walletId&skip=$page&limit=$pageSize',
      extraHeaders: headers,
    );
  }

  Future<Response> getHistoryWallet({
    int pageCurrent = 1,
    int pageSize = 20,
  }) async {
    return client.get(
      '$apiHostSso/api/v1/mobile/walletHistory?pageCurrent=$pageCurrent&pageSize=$pageSize',
    );
  }

  Future<Response> confirmTransaction({
    required dynamic headers,
    required String referenceCode,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Transaction/verify-transaction?referenceCode=$referenceCode',
      extraHeaders: headers,
    );
  }

  Future<Response> getHistoryWalletIn({
    required dynamic headers,
    required String walletId,
    int skip = 0,
    int limit = 20,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/History/get-history-wallet?walletId=$walletId&skip=$skip&limit=$limit',
      extraHeaders: headers,
    );
  }

  Future<Response> withdraw({
    required dynamic headers,
    required String data,
  }) async {
    return client.post(
      '$apiHostWallet/api/client/v1/Transaction/withdraw',
      extraHeaders: headers,
      data: {'data': data},
    );
  }

  Future<Response> deposit({
    required dynamic headers,
    required String data,
  }) async {
    return client.post(
      '$apiHostWallet/api/client/v1/Transaction/deposit',
      extraHeaders: headers,
      data: {'data': data},
    );
  }

  Future<Response> verifyDeposit({
    required String transId,
    required dynamic headers,
  }) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Transaction/verify?transId=$transId',
      extraHeaders: headers,
    );
  }

  Future<Response> testComplete({required String transactionId}) async {
    return client.get(
      '$apiHostWallet/api/client/v1/Pay/complete-transaction?transactionId=$transactionId',
    );
  }

  Future<Response> confirmConvert({Map<String, dynamic>? data}) async {
    return client.post('$apiHostSso/api/v1/mobile/wallet/withdraw', data: data);
  }

  Future<Response> getWalletUser() async {
    return client.get('$apiHostSso/api/v1/mobile/employ/getById');
  }

  Future<Response> createRequestRefund({required dio.FormData data}) async {
    return client.post(
      '$apiHostOrder/api/mobile/order/order-refund',
      data: data,
    );
  }

  Future<Response> getImageUrl({required dio.FormData data}) async {
    return client.post(
      '$apiHostPartner/api/files/upload/single-async',
      data: data,
    );
  }

  Future<Response> getImageUrlMultiple({required dio.FormData data}) async {
    return client.post(
      '$apiHostPartner/api/files/upload/multiple-async',
      data: data,
    );
  }

  Future<Response> fetchListOptionProduct({
    int? limit = 20,
    int? page = 1,
  }) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/optionFoodMerchant?pageCurrent=$page&pageSize=$limit',
    );
  }

  Future<Response> fetchListProduct({
    int? limit = 20,
    int? page = 1,
    String? search,
    List<String>? categoryId,
    List<String>? systemSettings,
  }) async {
    // build query params
    final List<String> extraQuery = [];
    if (categoryId != null && categoryId.isNotEmpty) {
      for (final id in categoryId) {
        extraQuery.add('listCategory=$id');
      }
    }
    if (systemSettings == null || systemSettings.isEmpty) {
      systemSettings = system;
    } else {
      systemSettings = systemSettings;
    }

    final query = [
      if (search != null && search.isNotEmpty) 'search=$search',
      if (extraQuery.isNotEmpty) extraQuery.join('&'),
    ].where((e) => e.isNotEmpty).join('&');

    return client.get(
      '$apiHostPartner/api/v1/mobile/product?pageCurrent=$page&pageSize=$limit&system=[{"key": "system", "value": $systemSettings}]${query.isNotEmpty ? '&$query' : ''}',
    );
  }

  Future<Response> joinVoucher({Map<String, dynamic>? data}) async {
    return client.post(
      '$apiHostPartner/api/v1/mobile/promotionMerchant/createStorePromotion',
      data: data,
    );
  }

  Future<Response> withdrawWalletDiscount({Map<String, dynamic>? data}) async {
    return client.post('$apiHostSso/api/v1/mobile/wallet/payout', data: data);
  }

  Future<Response> getDetailVoucher({required int id}) async {
    return client.get('$apiHostPartner/api/v1/mobile/promotionMerchant/$id');
  }

  Future<Response> addProductPromotion({
    required Map<String, dynamic> data,
  }) async {
    return client.post(
      '$apiHostPartner/api/v1/mobile/promotionMerchant/createProductPromotion',
      data: data,
    );
  }

  Future<Response> toggleProductPromotion({
    required Map<String, dynamic> data,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/product/changeToggle/status',
      data: data,
    );
  }

  Future<Response> deleteProductPromotions({
    required Map<String, dynamic> data,
  }) async {
    return client.delete(
      '$apiHostPartner/api/v1/mobile/product/deleteMany/data',
      data: data,
    );
  }

  Future<Response> fetchProductPromotionDetail({
    required int id,
    int? limit = 20,
    int? page = 1,
  }) async {
    return client.get(
      '$apiHostPartner/api/v1/mobile/promotionMerchant/$id?pageCurrent=$page&pageSize=$limit',
    );
  }

  Future<Response> sendFeedback({
    required String id,
    required String feedback,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/commentMerchant/$id',
      data: {'feedBack': feedback},
    );
  }

  Future<Response> fetchDetailEvaluate({required String id}) async {
    return client.get('$apiHostPartner/api/v1/mobile/commentMerchant/$id');
  }

  Future<Response> toggleStatus() async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/stores/changeToggle/status',
    );
  }

  Future<Response> fetchListRevenue({
    required String currentStart,
    required String currentEnd,
    required String compareStart,
    required String compareEnd,
  }) async {
    final query =
        'currentStart=$currentStart&currentEnd=$currentEnd&compareStart=$compareStart&compareEnd=$compareEnd&system=[{"key": "system", "value": $system}]';
    return client.get('$apiHostOrder/api/mobile/order/revenue?$query');
  }

  Future<Response> fetchOrderRefundByStoreComplaint({
    int page = 1,
    int pageSize = 20,
    String? status,
  }) async {
    final sort = [
      {"key": "status", "value": status},
    ];
    final sortList = jsonEncode(sort);
    return client.get(
      '$apiHostOrder/api/mobile/order/getOrderRefundUserByStoreId?pageCurrent=$page&pageSize=$pageSize&optionExtend=$sortList',
    );
  }

  Future<Response> updateRequestRefund({
    required String idOder,
    required String status,
  }) async {
    return client.put(
      '$apiHostOrder/api/mobile/order/status/$idOder?status=$status',
    );
  }

  Future<Response> oderRefundReason() async {
    return client.get(
      '$apiHostOrder/api/mobile/order/reason-cancel?refundType=Merchant',
    );
  }

  Future<Response> setDateTime({required Map<String, dynamic> data}) async {
    return client.put('$apiHostPartner/api/v1/mobile/stores', data: data);
  }

  Future<Response> deleteProductPromotion({Map<String, dynamic>? data}) async {
    return client.delete(
      '$apiHostPartner/api/v1/mobile/promotionMerchant/deleteProductPromotion',
      data: data,
    );
  }

  Future<Response> updateProductPromotion({Map<String, dynamic>? data}) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/promotionMerchant/updateProductPromotion',
      data: data,
    );
  }

  Future<Response> getProcessRefund({required String idOder}) async {
    return client.get(
      '$apiHostOrder/api/mobile/order/getProcessOrderRefund/$idOder',
    );
  }

  Future<Response> logout() async {
    return client.post('$apiHostSso/api/v1/mobile/employ/logout');
  }

  Future<Response> deleteAccount() async {
    return client.delete('$apiHostPartner/api/v1/mobile/stores/delete-store');
  }

  Future<Response> getOrderStatistic({required String organizationId}) async {
    return client.get(
      '$apiHostOrder/api/mobile/order/get-order-statistic?organizationId=$organizationId',
    );
  }

  Future<Response> getStoreByUserEmail({required String email}) async {
    final emailKey = Uri.encodeComponent(email);
    return client.get(
      '$apiHostPartner/api/v1/mobile/stores/getStoreByUserEmail?email=$emailKey',
    );
  }

  Future<Response> fetchDataIncomeStatistics({required String filter}) async {
    return client.get(
      '$apiHostOrder/api/mobile/order/get-revenue-statistic?filter=$filter&system=[{"key":"system","value":$system}]',
    );
  }

  Future<Response> fetchStatisticOrder({
    required String type,
    required String date,
  }) async {
    return client.get(
      '$apiHostOrder/api/mobile/order/statistic/day?date=$date&type=$type&system=[{"key": "system", "value": $system}]',
    );
  }

  Future<Response> confirmOders({required Map<String, dynamic> data}) async {
    return client.put(
      '$apiHostOrder/api/mobile/order/updateOrders?system=[{"key": "system", "value": $system}]',
      data: data,
    );
  }

  Future<Response> fetchListNotification({
    int? page = 1,
    int? limit = 20,
    String? receiverId,
  }) async {
    return client.get(
      '$apiHostContent/api/mobile-app/notification/getByReceiver/$receiverId?page=$page&limit=$limit&sortList=[{"key":"system","value":$system}]',
    );
  }

  Future<Response> fetchDataSetting() async {
    return client.get(
      'https://setting-api.chothongminh.com/api/SystemSettings/getSystemByTenantvsCodeName/getdata?tenant_id=0&codeName=GENERAL-CONFIG',
    );
  }

  Future<Response> fetchDetailNotification({
    required String notificationId,
    required Map<String, dynamic>? data,
  }) async {
    return client.put(
      '$apiHostContent/api/mobile-app/notification/update/$notificationId',
      data: data,
    );
  }

  Future<Response> updateNotification({required String receiverId}) async {
    return client.put(
      '$apiHostContent/api/mobile-app/notification/markAllAsRead/$receiverId?sortList=[{"key":"system","value":$system}]',
    );
  }

  Future<Response> confirmAllOrders({
    required List<Map<String, dynamic>> data,
    required String system,
  }) async {
    return client.put(
      '$apiHostOrder/api/mobile/order/bulkUpdateOrderStatus?system=$system&status=PREPARING',
      data: data,
    );
  }

  Future<Response> fetchDetailOrderStatistics({
    required String type,
    required String date,
    required String dateType,
    int? page = 1,
    int? limit = 20,
  }) async {
    return client.get(
      '$apiHostOrder/api/mobile/order/getListOrderByDateAndStatus?date=$date&type=$dateType&status=$type&pageCurrent=$page&pageSize=$limit&system=[{"key": "system", "value": $system}]',
    );
  }

  Future<Response> checkExisted({required String phoneOrEmail}) async {
    return client.get(
      '$apiHostSso/api/v1/mobile/employ/check-existed?phoneOrEmail=$phoneOrEmail',
    );
  }

  Future<Response> createVoucher({required Map<String, dynamic> data}) async {
    return client.post(
      '$apiHostPartner/api/v1/mobile/public/vouchers',
      data: data,
    );
  }

  Future<Response> fetchListVoucherDiscount({
    int? limit = 20,
    int? page = 1,
    String? storeId,
  }) async {
    final params = <String, String>{};

    if (limit != null) params['pageSize'] = limit.toString();
    if (page != null) params['pageCurrent'] = page.toString();

    if (storeId != null) {
      final sortJson = jsonEncode([
        {
          "key": "storeId",
          "value": [storeId],
        },
      ]);

      params['sortList'] = Uri.encodeComponent(sortJson);
    }

    final query = params.entries.map((e) => '${e.key}=${e.value}').join('&');
    final url = '$apiHostPartner/api/v1/mobile/public/vouchers?$query';

    return client.get(url);
  }

  Future<Response> deleteVoucherDiscount({required String id}) async {
    return client.delete('$apiHostPartner/api/v1/mobile/public/vouchers/$id');
  }

  Future<Response> updateVoucherDiscount({
    required Map<String, dynamic> data,
    required String id,
  }) async {
    return client.put(
      '$apiHostPartner/api/v1/mobile/public/vouchers/$id',
      data: data,
    );
  }
}
