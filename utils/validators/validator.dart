import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Validator {
  static bool isNullOrEmpty(String? value) {
    return (value ?? '').isEmpty;
  }

  static bool isEmailValid(String? value) {
    if (value == null) {
      return false;
    }
    final RegExp rgx = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
    );
    return rgx.hasMatch(value);
  }

  static String? textValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "Không được để trống".tr;
    }
    return null;
  }

  static String? emailValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredEmail".tr;
    } else if (!Validator.isEmailValid(value)) {
      return "invalidEmail".tr;
    }
    return null;
  }

  static String? passwordValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredPassword".tr;
    }
    if ((value?.length ?? 0) < 8) {
      return "password_not_match".tr;
    }
    return null;
  }

  static String? confirmPasswordValidation(String? value, String? password) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredPassword".tr;
    }
    if (value != password) {
      return "password_not_match".tr;
    }
    return null;
  }

  static String? dateOfBirthValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredDateOfBirth".tr;
    }
    DateTime dateTime = DateFormat("yyyy-MM-dd").parse(value!);
    if (DateTime.now().year - dateTime.year < 16) {
      return "invalidDateOfBirth".tr;
    }
    return null;
  }

  static String? intValidation(String? value) {
    if (!Validator.isNullOrEmpty(value) && int.tryParse(value!) == null) {
      return "invalidFormat".tr;
    }
    return null;
  }

  static String? doubleValidation(String? value) {
    if (!Validator.isNullOrEmpty(value) && double.tryParse(value!) == null) {
      return "invalidFormat".tr;
    }
    return null;
  }

  static String? userValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredUser".tr;
    }

    final input = value!.trim();

    if (_isNumeric(input)) {
      if (!Validator.isPhoneValid(input)) {
        return "Số điện thoại không hợp lệ".tr;
      }
    } else {
      if (!Validator.isEmailValid(input)) {
        return "Email không hợp lệ".tr;
      }
    }

    return null;
  }

  static bool _isNumeric(String value) {
    final numericRegex = RegExp(r'^[0-9]+$');
    return numericRegex.hasMatch(value);
  }

  static String? formValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredForm".tr;
    }
    if (value!.length < 6) {
      return "Mật khẩu phải có ít nhất 6 ký tự".tr;
    }

    return null;
  }

  static String? validateWithdraw(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredWithdraw".tr;
    }
    if (double.tryParse(value!.replaceAll(RegExp(r'[,đ]'), '0'))! < 100000 ||
        double.tryParse(value!.replaceAll(RegExp(r'[,đ]'), '0'))! > 500000000) {
      return "withdraw_amount_must_be_greater_than_100000".tr;
    }

    return null;
  }

  static String? phoneValidation(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "số điện thoại không được để trống".tr;
    }
    if (!Validator.isPhoneValid(value)) {
      return "số điện thoại không hợp lệ".tr;
    }
    return null;
  }

  static bool isPhoneValid(String? value) {
    if (value == null) {
      return false;
    }
    final RegExp rgx = RegExp(r'^0[0-9]{9}$');
    return rgx.hasMatch(value);
  }

  static String? validateTripConvert(String value, String cashMoney) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredTripConvert".tr;
    }
    if (double.tryParse(value)! < 10000) {
      return "trip_convert_amount_must_be_greater_than_50000".tr;
    }
    if (double.tryParse(value)! > double.tryParse(cashMoney)!) {
      return "trip_convert_amount_must_be_less_than_cash".tr;
    }

    return null;
  }
}
