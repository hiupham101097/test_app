import 'package:flutter/material.dart';

extension FocusExtensions on BuildContext {
  void resetFocus() {
    FocusScopeNode currentFocus = FocusScope.of(this);

    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      FocusManager.instance.primaryFocus?.unfocus();
    }
  }
}
