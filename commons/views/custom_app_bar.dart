import 'dart:isolate';

import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../constants/asset_constants.dart';
import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final Widget? actionButton;
  final Color? titleColor;
  final Color? backgroundColor;
  final VoidCallback? onTitleClick;
  final VoidCallback? onBackPress;
  final Widget? titleWidget;
  final bool? enableBack;
  final bool? centerTitle;
  final bool? isShowDivider;

  CustomAppBar({
    Key? key,
    this.title,
    this.actionButton,
    this.titleColor,
    this.backgroundColor,
    this.onTitleClick,
    this.onBackPress,
    this.titleWidget,
    this.enableBack = true,
    this.centerTitle = true,
    this.isShowDivider = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor ?? AppColors.backgroundColor24,
      centerTitle: centerTitle!,
      bottom:
          isShowDivider!
              ? PreferredSize(
                preferredSize: Size.fromHeight(0.5),
                child: Container(
                  color: AppColors.backgroundColor00,
                  height: 0.5,
                ),
              )
              : null,
      leading:
          enableBack!
              ? IconButton(
                icon: FaIcon(
                  FontAwesomeIcons.chevronLeft,
                  size: 16.r,
                  color: AppColors.grayscaleColor80,
                ),
                onPressed: () {
                  FocusScopeNode currentFocus = FocusScope.of(Get.context!);

                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    FocusManager.instance.primaryFocus!.unfocus();
                  }
                  if (onBackPress == null) {
                    Get.back();
                  } else {
                    onBackPress!();
                  }
                },
              )
              : const SizedBox(),
      title:
          title != null
              ? Text(
                title!.toUpperCase(),
                textAlign: centerTitle! ? TextAlign.center : TextAlign.left,
                style: AppTextStyles.bold14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
              : titleWidget ?? const SizedBox(),
      actions: <Widget>[actionButton ?? const SizedBox()],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(56);
}
