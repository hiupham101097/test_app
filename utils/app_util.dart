import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:html_unescape/html_unescape.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:diacritic/diacritic.dart';
import 'object_util.dart';

class AppUtil {
  static AppUtil instance = new AppUtil();

  static List<T> map<T>(List? list, Function handler, {int? length}) {
    final List<T> result = [];
    int size;

    if (ObjectUtil.isNotEmpty(list)) {
      size =
          (length != null && length <= (list?.length ?? 0))
              ? length
              : (list?.length ?? 0);

      for (var i = 0; i < size; i++) {
        result.add(handler(i, list?[i]));
      }
    }

    return result;
  }

  static Map<String, dynamic> filterRequestData(
    Map<String, dynamic> mapToEdit,
  ) {
    final keys = mapToEdit.keys.toList(growable: false);
    for (String key in keys) {
      final value = mapToEdit[key];
      if (value == null) {
        mapToEdit.remove(key);
      } else if (value is String) {
        if (value.isEmpty) {
          mapToEdit.remove(key);
        }
      } else if (value is Map) {
        filterRequestData(value as Map<String, dynamic>);
      }
    }
    return mapToEdit;
  }

  static Future<String> getDeviceId() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      return androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      return iosInfo.identifierForVendor ?? "";
    } else {
      return "";
    }
  }

  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }

  static String formatMoney(
    double money, {
    currency = 'đ',
    fractionDigits = 0,
    bool isContract = false,
  }) {
    if (money.isNaN) {
      money = 0;
    }
    String format = '###,##${isContract ? '0.00' : '#.##'}';
    switch (fractionDigits) {
      case 0:
        format = '###,###';
        break;
      case 1:
        format = '###,##${isContract ? '0.0' : '#.#'}';
        break;
      case 2:
        format = '###,##${isContract ? '0.00' : '#.##'}';
        break;
      case 3:
        format = '###,##${isContract ? '0.000' : '#.###'}';
        break;
      case 4:
        format = '###,###${isContract ? '0.0000' : '#.####'}';
        break;
      case 5:
        format = '###,##${isContract ? '0.00000' : '#.#####'}';
        break;
      case 6:
        format = '###,##${isContract ? '0.000000' : '#.######'}';
        break;
      case 7:
        format = '###,##${isContract ? '0.0000000' : '#.#######'}';
        break;
      case 8:
        format = '###,##${isContract ? '0.00000000' : '#.########'}';
        break;
      case 9:
        format = '###,##${isContract ? '0.000000000' : '#.#########'}';
        break;
    }
    var f = new NumberFormat(format, 'en_US');

    if (currency == 'đ' || currency == "VNĐ") {
      f = new NumberFormat('###,###', 'en_US');
    }

    return '${f.format(money)} $currency';
  }

  static String formatNumber(
    double number, {
    fractionDigits = 0,
    bool isContract = false,
  }) {
    if (number.isNaN) {
      number = 0;
    }
    String format = '###,##${isContract ? '0.00' : '#.##'}';
    switch (fractionDigits) {
      case 0:
        format = '###,###';
        break;
      case 1:
        format = '###,##${isContract ? '0.0' : '#.#'}';
        break;
      case 2:
        format = '###,##${isContract ? '0.00' : '#.##'}';
        break;
      case 3:
        format = '###,##${isContract ? '0.000' : '#.###'}';
        break;
      case 4:
        format = '###,###${isContract ? '0.0000' : '#.####'}';
        break;
      case 5:
        format = '###,##${isContract ? '0.00000' : '#.#####'}';
        break;
      case 6:
        format = '###,##${isContract ? '0.000000' : '#.######'}';
        break;
      case 7:
        format = '###,##${isContract ? '0.0000000' : '#.#######'}';
        break;
      case 8:
        format = '###,##${isContract ? '0.00000000' : '#.########'}';
        break;
      case 9:
        format = '###,##${isContract ? '0.000000000' : '#.#########'}';
        break;
    }
    final f = new NumberFormat(format, 'en_US');

    return f.format(number);
  }

  static int getFractionDigits(double minimumPriceFluctuation) {
    final decimalPointIndex = minimumPriceFluctuation.toString().indexOf('.');
    return decimalPointIndex < 0
        ? 0
        : minimumPriceFluctuation
            .toString()
            .substring(decimalPointIndex + 1)
            .length;
  }

  static Color mixColors(Color c1, Color c2, double ratio) {
    return Color.lerp(c1, c2, ratio)!;
  }

  static Future<void> callPhoneNumber(String phoneNumber) async {
    final Uri phoneno = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(phoneno, mode: LaunchMode.externalApplication)) {
      throw 'Cannot open dialer for number $phoneNumber';
    }
  }

  static String formatPaymentMethod(String paymentMethod) {
    switch (paymentMethod) {
      case 'ZLT':
        return ' Thanh toán ZaloPay';
      case 'ZLP':
        return ' Thanh toán ZaloPay';
      case 'ZLS':
        return ' Thanh toán ZaloPay';
      case 'MMT':
        return ' Thanh toán Momo';
      case 'MMO':
        return ' Thanh toán Momo';
      case 'VNT':
        return ' Thanh toán VnPay';
      case 'VNP':
        return ' Thanh toán VnPay';
      case 'HOME':
        return 'Thanh toán tiền mặt';
      case 'PBS':
        return 'Thanh toán ngân hàng';
      case 'PBP':
        return 'Thanh toán ngân hàng';
      default:
        return paymentMethod;
    }
  }

  static String getImagePaymentMethod(String paymentMethod) {
    switch (paymentMethod.toUpperCase()) {
      case 'ZLT':
        return AssetConstants.icZaloPay;
      case 'ZLP':
        return AssetConstants.icZaloPay;
      case 'ZLS':
        return AssetConstants.icZaloPay;
      case 'MMT':
        return AssetConstants.icMomo;
      case 'MMO':
        return AssetConstants.icMomo;
      case 'VNT':
        return AssetConstants.icVnPay;
      case 'VNP':
        return AssetConstants.icVnPay;
      case 'HOME':
        return AssetConstants.myWallet;
      case 'PBS':
        return AssetConstants.atmCard;
      case 'PBP':
        return AssetConstants.atmCard;
      default:
        return AssetConstants.myWallet;
    }
  }

  String getStatusLabel(String status) {
    switch (status) {
      case 'APPROVED':
        return 'accept_refund'.tr;
      case 'PENDING':
        return 'pending_order'.tr;
      case 'REJECTED':
        return 'reject_order'.tr;
      case 'CANCELED':
        return 'new_order'.tr;
      case 'FAILED':
        return 'new_order'.tr;
      case 'REFUND_PENDING':
        return 'wait_order'.tr;
      case 'REFUND_FAILED':
        return 'refund_failed'.tr;
      case 'REFUND_SUCCESS':
        return 'refund_success'.tr;
      default:
        return ''.tr;
    }
  }

  Color getStatusColor(String? status) {
    switch (status) {
      case 'APPROVED':
        return AppColors.successColor;
      case 'PENDING':
        return AppColors.infomationColor;
      case 'REJECTED':
        return AppColors.warningColor;
      case 'CANCELED':
        return AppColors.grayscaleColor50;
      case 'FAILED':
        return AppColors.grayscaleColor50;
      case 'REFUND_PENDING':
        return AppColors.infomationColor;
      case 'REFUND_FAILED':
        return AppColors.warningColor;
      case 'REFUND_SUCCESS':
        return AppColors.primaryColor;
      default:
        return AppColors.grayscaleColor50;
    }
  }

  static List<ProductGroupCategoryModel> groupByCategory(
    List<ProductModel> products,
  ) {
    List<ProductGroupCategoryModel> listProductGroupByCategory = [];

    final grouped = <String, List<ProductModel>>{};

    for (final p in products.where((e) => e.category != null)) {
      final key = p.category!.name ?? '';
      grouped.putIfAbsent(key, () => []).add(p);
    }

    listProductGroupByCategory.addAll(
      grouped.entries.map(
        (e) => ProductGroupCategoryModel(
          category: e.key,
          categoryLength: e.value.length,
          products: e.value,
        ),
      ),
    );
    return listProductGroupByCategory;
  }

  static String generateSlug(String name) {
    return removeDiacritics(name) // xoá dấu
        .toLowerCase()
        .trim()
        .replaceAll(RegExp(r'[^a-z0-9\s-]'), '') // xoá ký tự đặc biệt
        .replaceAll(RegExp(r'\s+'), '-') // thay space = -
        .replaceAll(RegExp(r'-+'), '-'); // gộp nhiều - thành 1
  }

  String convertHtmlToPlainText(String htmlData) {
    var unescape = HtmlUnescape();

    String withLineBreaks = htmlData.replaceAll(
      RegExp(r'<br\s*/?>', caseSensitive: false),
      '\n',
    );
    String textOnly = withLineBreaks.replaceAll(RegExp(r'<[^>]*>'), '');
    String decodedText = unescape.convert(textOnly);
    return decodedText.trim();
  }

  static Future<void> openUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw 'Cannot open url $url';
    }
  }

  static Future<void> openMap(String address) async {
    final Uri googleUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=$address",
    );
    final Uri appleUrl = Uri.parse("maps://?q=$address");

    if (Platform.isAndroid) {
      if (!await launchUrl(googleUrl, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch Google Maps';
      }
    } else if (Platform.isIOS) {
      if (!await launchUrl(appleUrl, mode: LaunchMode.externalApplication)) {
        if (!await launchUrl(googleUrl, mode: LaunchMode.externalApplication)) {
          throw 'Could not launch Maps';
        }
      }
    }
  }

  Future<XFile> pickImages() async {
    try {
      final ImagePicker picker = ImagePicker();

      final XFile? singleImage = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
      );

      if (singleImage == null || singleImage.path.isEmpty) {
        return XFile("");
      }

      final int fileSize = File(singleImage.path).lengthSync();
      const int maxSize = 5 * 1024 * 1024; // 1MB

      print("Image size: ${(fileSize / 1024).toStringAsFixed(2)} KB");

      if (fileSize > maxSize) {
        DialogUtil.showErrorMessage("Ảnh phải nhỏ hơn 5MB");
        return XFile("");
      }

      return singleImage;
    } catch (e) {
      DialogUtil.showErrorMessage("Chọn ảnh thất bại");
      return XFile("");
    }
  }
}
