import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import '../commons/views/_icon_toast_widget.dart';

class DialogUtil {
  static DialogUtil instance = DialogUtil();

  DialogUtil();

  static showSuccessMessage(
    String description, {
    VoidCallback? onDismiss,
    bool isTop = true,
    int duration = 5,
  }) {
    showToastWidget(
      IconToastWidget.success(msg: description),
      context: Get.overlayContext,
      position: isTop ? StyledToastPosition.top : StyledToastPosition.bottom,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTop,
      startOffset: const Offset(0.0, -3.0),
      reverseEndOffset: const Offset(0.0, -3.0),
      duration: Duration(seconds: duration),
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
      onDismiss: onDismiss,
    );
  }

  static showErrorMessage(
    String description, {
    VoidCallback? onDismiss,
    bool isTop = true,
    int duration = 5,
  }) {
    showToastWidget(
      IconToastWidget.fail(msg: description),
      context: Get.overlayContext,
      position: isTop ? StyledToastPosition.top : StyledToastPosition.bottom,
      animation: StyledToastAnimation.slideFromTop,
      reverseAnimation: StyledToastAnimation.slideToTop,
      startOffset: const Offset(0.0, -3.0),
      reverseEndOffset: const Offset(0.0, -3.0),
      duration: Duration(seconds: duration),
      animDuration: const Duration(seconds: 1),
      curve: Curves.elasticOut,
      reverseCurve: Curves.fastOutSlowIn,
      onDismiss: onDismiss,
    );
  }

  static showConfirmDialog(
    BuildContext context, {
    bool isForeUpdate = false,
    bool isForeUpdateCancel = false,
    String? title,
    String? description,
    String? image,
    String? button,
    Function? action,
    Function? actionCancel,
    String? titleCancel,
    Function? laterAction,
    bool isShowCancel = true,
    Color? titleColor,
    AppButtonType? typeButtonCancel,
    AppButtonType? typeButton,
  }) {
    Get.generalDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor24,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Opacity(
                opacity: a1.value,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      image == null
                          ? SizedBox()
                          : Column(
                            children: [
                              Image.asset(
                                image,
                                width: 90.w,
                                height: 90.h,
                                fit: BoxFit.cover,
                              ),
                              SizedBox(height: 24.h),
                            ],
                          ),
                      Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold16().copyWith(
                          color: titleColor ?? AppColors.accessColor,
                        ),
                      ),
                      SizedBox(height: 8.h),
                      description != null
                          ? Text(
                            description ?? '',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular14(),
                          )
                          : SizedBox(),
                      SizedBox(height: 12.h),
                      Row(
                        spacing: 16.w,
                        children: [
                          if (isShowCancel)
                            Expanded(
                              child: AppButton(
                                title: titleCancel ?? "cancel".tr,
                                type: typeButtonCancel ?? AppButtonType.nomal,
                                onPressed: () {
                                  if (!isForeUpdateCancel) {
                                    Get.back();
                                  }
                                  if (actionCancel != null) {
                                    actionCancel();
                                  }
                                },
                              ),
                            ),
                          Expanded(
                            child: AppButton(
                              title: button ?? "confirm".tr,
                              type: typeButton ?? AppButtonType.outline,
                              onPressed: () {
                                if (!isForeUpdate) {
                                  Navigator.of(
                                    context,
                                    rootNavigator: true,
                                  ).pop();
                                }
                                if (action != null) {
                                  action();
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) => SizedBox(),
    );
  }

  static showDialogSucess(
    BuildContext context,
    String codeOrder,
    String reason, {
    Function? close,
  }) {
    Get.generalDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.backgroundColor24,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Opacity(
                opacity: a1.value,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "order_canceled".tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyles.semibold20().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      const SizedBox(height: 8),
                      RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "order_text".tr,
                              style: AppTextStyles.regular14(),
                            ),
                            TextSpan(
                              text: " #$codeOrder",
                              style: AppTextStyles.semibold14().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            TextSpan(
                              text: " đã huỷ với lý do:\n",
                              style: AppTextStyles.regular14(),
                            ),
                            TextSpan(
                              text: reason,
                              style: AppTextStyles.semibold14().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      AppButton(
                        title: "close".tr,
                        type: AppButtonType.nomal,
                        onPressed: () {
                          if (close != null) {
                            close();
                          } else {
                            Get.back();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) => SizedBox(),
    );
  }

  static showDialogLoading(
    BuildContext context, {
    String? title,
    String? description,
    String? image,
  }) {
    Get.generalDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return Transform.scale(
          scale: a1.value,
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
              margin: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primaryColor5,
                borderRadius: BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Opacity(
                opacity: a1.value,
                child: Material(
                  color: Colors.transparent,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CircularProgressIndicator(
                        color: AppColors.primaryColor,
                        backgroundColor: AppColors.primaryColor20,
                        strokeWidth: 5.w,
                        strokeCap: StrokeCap.round,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        title ?? '',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bold16().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),

                      SizedBox(height: 16.h),
                      description != null
                          ? Text(
                            description ?? '',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular14(),
                          )
                          : SizedBox(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) => SizedBox(),
    );
  }

  static showDialogSuccessTransaction(
    BuildContext context, {
    Widget? title,
    Widget? description,
    Widget? image,
    String? titleLeft,
    String? titleRight,
    AppButtonType? typeButtonLeft,
    AppButtonType? typeButtonRight,
    Function? actionLeft,
    Function? actionRight,
    bool isForeUpdate = false,
    Color? outlineColor,
    bool isShowLeft = true,
    bool isShowRight = true,
    bool isDisablePop = true,
  }) {
    Get.generalDialog(
      transitionBuilder: (context, a1, a2, widget) {
        return WillPopScope(
          onWillPop: () async => isDisablePop,
          child: Transform.scale(
            scale: a1.value,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 20.h),
                margin: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor5,
                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                ),
                child: Opacity(
                  opacity: a1.value,
                  child: Material(
                    color: Colors.transparent,
                    child: Column(
                      spacing: 12.h,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (image != null) image,
                        if (title != null) title,
                        if (description != null) description,
                        Row(
                          spacing: 16.w,
                          children: [
                            if (isShowLeft)
                              Expanded(
                                child: AppButton(
                                  title: titleLeft ?? "cancel".tr,
                                  type: typeButtonLeft ?? AppButtonType.nomal,
                                  onPressed: () {
                                    if (actionLeft != null) {
                                      actionLeft();
                                    } else {
                                      Get.back();
                                    }
                                  },
                                ),
                              ),
                            if (isShowRight)
                              Expanded(
                                child: AppButton(
                                  title: titleRight ?? "confirm".tr,
                                  type:
                                      typeButtonRight ?? AppButtonType.outline,
                                  outlineColor: outlineColor,
                                  onPressed: () {
                                    if (!isForeUpdate) {
                                      Navigator.of(
                                        context,
                                        rootNavigator: true,
                                      ).pop();
                                    }
                                    if (actionRight != null) {
                                      actionRight();
                                    }
                                  },
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionDuration: Duration(milliseconds: 200),
      barrierLabel: '',
      barrierDismissible: false,
      pageBuilder: (context, animation1, animation2) => SizedBox(),
    );
  }

  static void showErrorDialog(BuildContext buildContext, String string) {}
}

void showAlertAppUpdateDialog(
  BuildContext context, {
  String? message,
  String? title,
  bool isShowSkip = false,
  VoidCallback? onUpdate,
  VoidCallback? onSkip,
}) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    barrierLabel: '',
    useRootNavigator: true,
    pageBuilder: (context, animation1, animation2) => SizedBox(),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: WillPopScope(
          onWillPop: () async => false,
          child: Material(
            color: Colors.transparent,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20.w),
                margin: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor24,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.transparent),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: Opacity(
                  opacity: a1.value,
                  child: Material(
                    color: Colors.transparent,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Lottie.asset(
                            'assets/lottie/update.json',
                            width: 200.w,
                            height: 200.h,
                          ),
                          SizedBox(height: 20.h),
                          Text(
                            title ?? 'Có phiên bản mới cập nhật',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.bold16().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            message ?? '',
                            textAlign: TextAlign.center,
                            style: AppTextStyles.regular14().copyWith(
                              color: AppColors.grayscaleColor60,
                            ),
                          ),
                          SizedBox(height: 24),
                          Row(
                            spacing: 8.w,
                            children: [
                              if (isShowSkip)
                                Expanded(
                                  child: AppButton(
                                    title: 'Bỏ qua',
                                    type: AppButtonType.nomal,

                                    onPressed: () {
                                      onSkip?.call();
                                    },
                                  ),
                                ),
                              Expanded(
                                child: AppButton(
                                  title: 'Cập nhật ngay',
                                  type: AppButtonType.outline,
                                  onPressed: () {
                                    onUpdate?.call();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
    transitionDuration: Duration(milliseconds: 300),
  );
}
