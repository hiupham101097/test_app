import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._();

  static const String fontBold = "Roboto-Bold";
  static const String fontSemibold = "Roboto-Semibold";
  static const String fontMedium = "Roboto-Medium";
  static const String fontRegular = "Roboto-Regular";

  static const _baseTextStyle = TextStyle(
    fontFamily: fontRegular,
    color: AppColors.grayscaleColor60,
    letterSpacing: -0.4,
    height: 1.4,
  );

  static TextStyle regular10() =>
      _baseTextStyle.merge(TextStyle(fontSize: 12.sp, fontFamily: fontRegular));

  static TextStyle regular11() =>
      _baseTextStyle.merge(TextStyle(fontSize: 13.sp, fontFamily: fontRegular));

  static TextStyle regular12() =>
      _baseTextStyle.merge(TextStyle(fontSize: 14.sp, fontFamily: fontRegular));

  static TextStyle regular13() =>
      _baseTextStyle.merge(TextStyle(fontSize: 15.sp, fontFamily: fontRegular));

  static TextStyle regular14() =>
      _baseTextStyle.merge(TextStyle(fontSize: 16.sp, fontFamily: fontRegular));

  static TextStyle regular15() =>
      _baseTextStyle.merge(TextStyle(fontSize: 17.sp, fontFamily: fontRegular));

  static TextStyle regular16() =>
      _baseTextStyle.merge(TextStyle(fontSize: 18.sp, fontFamily: fontRegular));

  static TextStyle regular17() =>
      _baseTextStyle.merge(TextStyle(fontSize: 19.sp, fontFamily: fontRegular));

  static TextStyle regular18() =>
      _baseTextStyle.merge(TextStyle(fontSize: 20.sp, fontFamily: fontRegular));

  static TextStyle regular19() =>
      _baseTextStyle.merge(TextStyle(fontSize: 21.sp, fontFamily: fontRegular));

  static TextStyle regular20() =>
      _baseTextStyle.merge(TextStyle(fontSize: 22.sp, fontFamily: fontRegular));

  // Medium - sử dụng .sp cho responsive font size
  static TextStyle medium10() =>
      _baseTextStyle.merge(TextStyle(fontSize: 12.sp, fontFamily: fontMedium));

  static TextStyle medium11() =>
      _baseTextStyle.merge(TextStyle(fontSize: 13.sp, fontFamily: fontMedium));

  static TextStyle medium12() =>
      _baseTextStyle.merge(TextStyle(fontSize: 14.sp, fontFamily: fontMedium));

  static TextStyle medium13() =>
      _baseTextStyle.merge(TextStyle(fontSize: 15.sp, fontFamily: fontMedium));

  static TextStyle medium14() =>
      _baseTextStyle.merge(TextStyle(fontSize: 16.sp, fontFamily: fontMedium));

  static TextStyle medium15() =>
      _baseTextStyle.merge(TextStyle(fontSize: 17.sp, fontFamily: fontMedium));

  static TextStyle medium16() =>
      _baseTextStyle.merge(TextStyle(fontSize: 18.sp, fontFamily: fontMedium));

  static TextStyle medium17() =>
      _baseTextStyle.merge(TextStyle(fontSize: 19.sp, fontFamily: fontMedium));

  static TextStyle medium18() =>
      _baseTextStyle.merge(TextStyle(fontSize: 20.sp, fontFamily: fontMedium));

  static TextStyle medium19() =>
      _baseTextStyle.merge(TextStyle(fontSize: 21.sp, fontFamily: fontMedium));

  static TextStyle medium20() =>
      _baseTextStyle.merge(TextStyle(fontSize: 22.sp, fontFamily: fontMedium));

  // Semibold - sử dụng .sp cho responsive font size
  static TextStyle semibold10() => _baseTextStyle.merge(
    TextStyle(fontSize: 12.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold11() => _baseTextStyle.merge(
    TextStyle(fontSize: 13.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold12() => _baseTextStyle.merge(
    TextStyle(fontSize: 14.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold13() => _baseTextStyle.merge(
    TextStyle(fontSize: 15.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold14() => _baseTextStyle.merge(
    TextStyle(fontSize: 16.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold15() => _baseTextStyle.merge(
    TextStyle(fontSize: 17.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold16() => _baseTextStyle.merge(
    TextStyle(fontSize: 18.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold17() => _baseTextStyle.merge(
    TextStyle(fontSize: 19.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold18() => _baseTextStyle.merge(
    TextStyle(fontSize: 20.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold19() => _baseTextStyle.merge(
    TextStyle(fontSize: 21.sp, fontFamily: fontSemibold),
  );

  static TextStyle semibold20() => _baseTextStyle.merge(
    TextStyle(fontSize: 22.sp, fontFamily: fontSemibold),
  );

  // Bold - sử dụng .sp cho responsive font size
  static TextStyle bold11() =>
      _baseTextStyle.merge(TextStyle(fontSize: 13.sp, fontFamily: fontBold));

  static TextStyle bold12() =>
      _baseTextStyle.merge(TextStyle(fontSize: 14.sp, fontFamily: fontBold));

  static TextStyle bold13() =>
      _baseTextStyle.merge(TextStyle(fontSize: 15.sp, fontFamily: fontBold));

  static TextStyle bold14() =>
      _baseTextStyle.merge(TextStyle(fontSize: 16.sp, fontFamily: fontBold));

  static TextStyle bold15() =>
      _baseTextStyle.merge(TextStyle(fontSize: 17.sp, fontFamily: fontBold));

  static TextStyle bold16() =>
      _baseTextStyle.merge(TextStyle(fontSize: 18.sp, fontFamily: fontBold));

  static TextStyle bold17() =>
      _baseTextStyle.merge(TextStyle(fontSize: 19.sp, fontFamily: fontBold));

  static TextStyle bold18() =>
      _baseTextStyle.merge(TextStyle(fontSize: 20.sp, fontFamily: fontBold));

  static TextStyle bold19() =>
      _baseTextStyle.merge(TextStyle(fontSize: 21.sp, fontFamily: fontBold));

  static TextStyle bold20() =>
      _baseTextStyle.merge(TextStyle(fontSize: 22.sp, fontFamily: fontBold));

  static TextStyle bold28() =>
      _baseTextStyle.merge(TextStyle(fontSize: 30.sp, fontFamily: fontBold));
}
