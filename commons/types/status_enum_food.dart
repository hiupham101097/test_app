import 'package:get/get.dart';

enum StatusEnumFood {
  on,
  off;

  String getLabel() {
    switch (this) {
      case StatusEnumFood.on:
        return 'Hiển thị'.tr;
      case StatusEnumFood.off:
        return 'Tạm tắt'.tr;
    }
  }

  bool getCode() {
    switch (this) {
      case StatusEnumFood.on:
        return true;
      case StatusEnumFood.off:
        return false;
    }
  }
}
