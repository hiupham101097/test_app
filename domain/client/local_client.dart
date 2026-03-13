import 'package:shared_preferences/shared_preferences.dart';

class LocalClient {
  final SharedPreferences sharedPreference;

  LocalClient(this.sharedPreference);

  static const String userKey = 'user';
  static const String accessTokenKey = 'accessToken';
  static const String userBoxName = 'userBox';

  bool get isFirstOpen {
    return sharedPreference.getBool("isFirstOpen") ?? true;
  }

  String get accessToken {
    return sharedPreference.getString("accessToken") ?? "";
  }

  void setFirstOpen(bool value) {
    sharedPreference.setBool("isFirstOpen", value);
  }

  void setAccessToken(String value) {
    sharedPreference.setString("accessToken", value);
  }

  void setPassword(String value) {
    sharedPreference.setString("password", value);
  }

  String get password {
    return sharedPreference.getString("password") ?? "";
  }

  void clearAccessToken() {
    sharedPreference.remove("accessToken");
  }

  void clearPassword() {
    sharedPreference.remove("password");
  }

  void setEmail(String value) {
    sharedPreference.setString("email", value);
  }

  String get email {
    return sharedPreference.getString("email") ?? "";
  }

  void clearEmail() {
    sharedPreference.remove("email");
  }

  void setPhone(String value) {
    sharedPreference.setString("phone", value);
  }

  String get phone {
    return sharedPreference.getString("phone") ?? "";
  }

  void clearPhone() {
    sharedPreference.remove("phone");
  }

  void setintroduceCode(String value) {
    sharedPreference.setString("introduceCode", value);
  }

  String get introduceCode {
    return sharedPreference.getString("introduceCode") ?? "";
  }

  void clearintroduceCode() {
    sharedPreference.remove("introduceCode");
  }


  void setAmountSetting(String value) {
    sharedPreference.setString("amountSetting", value);
  }

  String get amountSetting {
    return sharedPreference.getString("amountSetting") ?? "";
  }

  void clearAmountSetting() {
    sharedPreference.remove("amountSetting");
  }
}
