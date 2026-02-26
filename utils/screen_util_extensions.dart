import 'package:flutter/material.dart';
import 'screen_utill.dart';

extension ScreenUtilExtension on num {
  double get w => ScreenUtil.instance.setScale(this.toDouble());
  double get h => ScreenUtil.instance.setScale(this.toDouble());
  double get r => ScreenUtil.instance.setScale(this.toDouble());
  double get sp => ScreenUtil.instance.setSp(this.toDouble());
}

extension ScreenUtilContextExtension on BuildContext {
  double get screenWidth => ScreenUtil.screenWidthDp;
  double get screenHeight => ScreenUtil.deviceHeight;
  double get pixelRatio => ScreenUtil.pixelRatio;
  MediaQueryData get mediaQuery => ScreenUtil.mediaQueryData;
}
