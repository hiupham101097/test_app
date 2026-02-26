import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'dart:io';
import '../../../commons/views/custom_app_bar.dart';

double getBottomBarHeight(BuildContext context) {
  final bottomInset = MediaQuery.of(context).systemGestureInsets.bottom;
  if (Platform.isAndroid && bottomInset > 32) {
    return 4;
  } else {
    return 24;
  }
}

class CustomScreen extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isBack;
  final bool isAction;
  final Widget? action;
  final bool isBottom;
  final Widget? floatingActionButton;
  final VoidCallback? onBackPress;
  final Color? backgroundColor;
  final Widget? bottomNavigationBar;
  final bool resizeToAvoidBottomInset;
  final bool isShowDivider;

  const CustomScreen({
    Key? key,
    this.title,
    required this.child,
    this.isBack = true,
    this.isAction = false,
    this.action,
    this.isBottom = false,
    this.floatingActionButton,
    this.onBackPress,
    this.backgroundColor = Colors.white,
    this.bottomNavigationBar,
    this.resizeToAvoidBottomInset = true,
    this.isShowDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: SafeArea(
        top: false,
        bottom:
            Platform.isAndroid &&
            MediaQuery.of(context).systemGestureInsets.bottom > 32.h,
        child: Scaffold(
          appBar:
              title != null
                  ? CustomAppBar(
                    title: title,
                    enableBack: isBack,
                    actionButton: action,
                    onBackPress: onBackPress,
                    isShowDivider: isShowDivider,
                  )
                  : null,
          backgroundColor: backgroundColor,
          resizeToAvoidBottomInset: resizeToAvoidBottomInset,
          body: child,
          bottomNavigationBar: bottomNavigationBar,
          floatingActionButton: floatingActionButton,
        ),
      ),
    );
  }
}
