import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:gal/gal.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/client/event_service.dart';
import 'package:merchant/domain/data/models/dispose_model.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/wallet/wallet_service/wallet_service.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:io' show Platform;
import 'package:flutter/services.dart' as services;

class DepositInformationController extends GetxController {
  final transactionData = DisposeModel().obs;
  final ApiClient client = ApiClient();
  final walletId = Rxn<String>();

  Timer? _timer;

  @override
  void onInit() async {
    super.onInit();
    if (Get.arguments != null && Get.arguments['transactionData'] != null) {
      transactionData.value = Get.arguments['transactionData'];
    }
    if (Get.arguments != null && Get.arguments['walletId'] != null) {
      walletId.value = Get.arguments['walletId'];
    }
    _startAutoVerify();
  }

  void _startAutoVerify() {
    verifyDeposit();
    _timer = Timer.periodic(const Duration(seconds: 10), (_) {
      verifyDeposit();
    });
  }

  Future<void> verifyDeposit() async {
    try {
      final headers = await WalletService().buildWalletHeaders();
      final response = await client.verifyDeposit(
        transId: transactionData.value.transactionId ?? '',
        headers: headers,
      );
      if (response.statusCode == 200 && response.data['status'] == 200) {
        final transaction = jsonDecode(response.data['resultApi']['payload']);
        if (transaction['isSuccess'] == true) {
          await WalletService().getWallet(
            phone: StoreDB().currentStore()?.phone ?? '',
            store: StoreDB().currentStore() ?? StoreModel(),
          );
          _timer?.cancel();
          diaLogSuccess();
          return;
        } else if (transaction['isSuccess'] == false &&
            transaction['transactionStatus'] == 'Failed') {
          _timer?.cancel();
          await WalletService().getWallet(
            phone: StoreDB().currentStore()?.phone ?? '',
            store: StoreDB().currentStore() ?? StoreModel(),
          );
          diaLogError();
          return;
        }
      }
    } catch (error, trace) {
      ErrorUtil.catchError(error, trace);
      _timer?.cancel();
      return;
    }
  }

  Future<void> testComplete() async {
    try {
      final response = await client.testComplete(
        transactionId: transactionData.value.transactionId ?? '',
      );
      if (response.statusCode == 200 && response.data['status'] == 200) {}
    } catch (error, trace) {
      return;
    }
  }

  void copyBankNumber() {
    Clipboard.setData(
      ClipboardData(text: transactionData.value.bankData?.bankNumber ?? ''),
    );
    DialogUtil.showSuccessMessage('Số tài khoản đã được copy thành công');
  }

  void diaLogError() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icWarning,
        width: 68.w,
        height: 68.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'confirm_failed'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.warningColor),
        textAlign: TextAlign.center,
      ),
      description: Text(
        "system_not_confirm_transaction".tr,
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
      ),
      titleLeft: 'retry'.tr,
      titleRight: 'skip'.tr,
      typeButtonLeft: AppButtonType.remove,

      outlineColor: AppColors.warningColor,
      actionLeft: () {
        Get.back();
        verifyDeposit();
      },
      actionRight: () {
        Get.back();
      },
    );
  }

  void diaLogSuccess() {
    DialogUtil.showDialogSuccessTransaction(
      Get.context!,
      image: Image.asset(
        AssetConstants.icDisposeSuccess,
        width: 275.w,
        height: 161.h,
        fit: BoxFit.contain,
      ),
      title: Text(
        'topup_success'.tr,
        style: AppTextStyles.bold20().copyWith(color: AppColors.successColor),
        textAlign: TextAlign.center,
      ),
      description: Text.rich(
        style: AppTextStyles.regular14(),
        textAlign: TextAlign.center,
        TextSpan(
          children: [
            TextSpan(
              text: "you_deposited".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: " ",
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: AppUtil.formatMoney(
                double.tryParse(
                      transactionData.value.totalPrice?.toString() ?? '0',
                    ) ??
                    0,
              ),
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(
              text: "into_driver_wallet".tr,
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            TextSpan(text: "\n${"current_balance".tr}"),
            TextSpan(
              text: AppUtil.formatMoney(
                double.tryParse(
                      WalletDB()
                              .currentWallet()
                              ?.withdrawableBalance
                              ?.toString() ??
                          '0',
                    ) ??
                    0,
              ),
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ],
        ),
      ),
      titleLeft: 'back_to_home'.tr,
      titleRight: 'top_up_more'.tr,
      actionLeft: () {
        Get.offAllNamed(Routes.root);
      },
      actionRight: () {
        Get.back();
      },
    );
  }

  Future<void> saveQrToGallery(String qrData) async {
    try {
      // Tạo QrPainter để render mã QR
      final qrPainter = QrPainter(
        data: qrData,
        version: QrVersions.auto,
        gapless: true,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Colors.black,
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Colors.black,
        ),
        emptyColor: Colors.white,
      );

      // Render ảnh PNG từ QR
      final ByteData? imageData = await qrPainter.toImageData(
        1024,
        format: ui.ImageByteFormat.png,
      );

      if (imageData == null) {
        throw Exception('Không thể tạo ảnh QR');
      }

      final Uint8List pngBytes = imageData.buffer.asUint8List();

      // Tạo file tạm
      final tempDir = await getTemporaryDirectory();
      final filePath =
          '${tempDir.path}/qr_${DateTime.now().millisecondsSinceEpoch}.png';
      final file = File(filePath);
      await file.writeAsBytes(pngBytes);
      await Gal.requestAccess();
      // Lưu vào thư viện
      await Gal.putImage(filePath);

      // Android: request media scanner to index the file into gallery immediately
      if (Platform.isAndroid) {
        const channel = services.MethodChannel(
          'com.chothongminh.merchant/media_scanner',
        );
        try {
          await channel.invokeMethod('scanFile', {'path': filePath});
        } catch (_) {}
      }

      // Hiển thị thông báo thành công
      DialogUtil.showSuccessMessage('Ảnh QR đã được lưu vào thư viện!');
      print('✅ Ảnh QR đã lưu: $filePath');
    } catch (e) {
      DialogUtil.showErrorMessage('❌ Lỗi khi lưu ảnh QR: $e');
      print('❌ Lỗi khi lưu ảnh QR: $e');
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
