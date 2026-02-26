import 'dart:math';
import 'package:merchant/constants/app_constants.dart';
import 'package:flutter/material.dart';

class ScreenUtil {
  static ScreenUtil instance = ScreenUtil();
  double width;
  bool allowFontScaling;

  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _pixelRatio;
  static late double _deviceHeight;
  static late double _deviceWidth;

  static late double _textScaleFactor;

  ScreenUtil({
    this.width = AppConstants.BASE_WIDTH,
    this.allowFontScaling = false,
  });

  static ScreenUtil getInstance() {
    return instance;
  }

  void init(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    _mediaQueryData = mediaQuery;
    _pixelRatio = mediaQuery.devicePixelRatio;
    _screenWidth =
        mediaQuery.size.width > AppConstants.BASE_WIDTH
            ? min(mediaQuery.size.width, AppConstants.MAX_WIDTH)
            : mediaQuery.size.width;
    _deviceHeight = mediaQuery.size.height;
    _deviceWidth = mediaQuery.size.width;
    _textScaleFactor = mediaQuery.textScaleFactor;
  }

  static MediaQueryData get mediaQueryData => _mediaQueryData;

  static double get textScaleFactory => _textScaleFactor;

  static double get pixelRatio => _pixelRatio;

  static double get screenWidthDp => _screenWidth;

  static double get screenWidth => _screenWidth * _pixelRatio;

  static double get deviceHeight => _deviceHeight;

  static double get deviceWidth => _deviceWidth;

  get scaleWidth => _screenWidth / instance.width;

  setScale(double width) => width * scaleWidth;

  setSp(double fontSize) {
    if (allowFontScaling) {
      return setScale(fontSize);
    } else {
      double scaledSize = setScale(fontSize);
      return scaledSize / _textScaleFactor;
    }
  }
}
