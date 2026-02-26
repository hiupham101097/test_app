import 'package:merchant/constants/asset_constants.dart';
import 'package:get/get.dart';

enum MethodEnum {
  zalo,
  sms;

  String getLabel() {
    switch (this) {
      case MethodEnum.zalo:
        return 'method_zalo'.tr;
      case MethodEnum.sms:
        return 'method_sms'.tr;
    }
  }

  String getCode() {
    switch (this) {
      case MethodEnum.zalo:
        return 'zns';
      case MethodEnum.sms:
        return 'sms';
    }
  }

  String getIcon() {
    switch (this) {
      case MethodEnum.zalo:
        return AssetConstants.icZalo;
      case MethodEnum.sms:
        return AssetConstants.icSms;
    }
  }
}
