import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_empty.dart';

class CustomEasyRefresh extends StatelessWidget {
  final Future<void> Function()? onLoading;
  final EasyRefreshController? controller;
  final Future<void> Function()? onRefresh;
  final SliverChildBuilderDelegate? delegate;
  final Widget? sliver;
  final String? infoText;
  final int? childCount;
  final Key? key;
  final Widget? emptyWidget;

  CustomEasyRefresh({
    this.onLoading,
    this.controller,
    this.onRefresh,
    this.delegate,
    this.sliver,
    this.infoText,
    this.childCount,
    this.key,
    this.emptyWidget,
  });

  @override
  Widget build(BuildContext context) {
    return EasyRefresh.custom(
      enableControlFinishRefresh: false,
      enableControlFinishLoad: onLoading == null ? false : true,
      onLoad: onLoading,
      controller: controller,

      onRefresh: onRefresh,
      emptyWidget:
          _isEmpty ? emptyWidget ?? CustomEmpty(title: "no_data".tr) : null,
      header: ClassicalHeader(
        refreshText: 'pull_to_refresh'.tr,
        refreshReadyText: 'release_to_refresh'.tr,
        refreshingText: 'refreshing'.tr,
        refreshedText: 'refreshed'.tr,
        infoColor: context.theme.hintColor,
        infoText: 'update_last'.tr,
        textColor: context.theme.hintColor,
      ),
      footer: ClassicalFooter(
        enableInfiniteLoad: false,
        loadText: 'pull_to_load_more'.tr,
        loadReadyText: 'release_to_load_more'.tr,
        loadingText: 'loading_more'.tr,
        loadedText: 'loaded'.tr,
        infoText: infoText,
        noMoreText: 'no_more_data'.tr,
        textColor: context.theme.hintColor,
        infoColor: context.theme.hintColor,
      ),
      slivers: <Widget>[sliver ?? SliverList(delegate: delegate!)],
    );
  }

  bool get _isEmpty {
    if (delegate != null) {
      return delegate!.childCount == 0;
    }
    if (childCount != null) {
      return childCount == 0;
    }
    return false;
  }
}
