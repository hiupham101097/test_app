import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

enum AppButtonType { primary, outline, remove, nomal, text }

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final bool isEnable;
  final Color? colorText;
  final Color? outlineColor;
  final double? width;
  final double? height;
  final String? icon;

  const AppButton({
    super.key,
    required this.title,
    this.onPressed,
    this.isEnable = true,
    this.type = AppButtonType.outline,
    this.colorText,
    this.outlineColor,
    this.width,
    this.height,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    switch (type) {
      case AppButtonType.primary:
        return TextButton(
          onPressed: isEnable ? onPressed : null,
          style: ButtonStyle(
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(360)),
            ),
            fixedSize: WidgetStatePropertyAll(
              Size(context.width, height ?? 40.h),
            ),
            backgroundColor: WidgetStatePropertyAll(
              isEnable ? AppColors.primaryColor : AppColors.backgroundColor00,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 8.w,
            children: [
              if (icon != null) ...[
                Image.asset(icon!, width: 24.w, height: 24.w),
              ],
              Text(
                textAlign: TextAlign.center,
                title.toUpperCase(),
                style: AppTextStyles.bold14().copyWith(color: Colors.white),
              ),
            ],
          ),
        );
      case AppButtonType.outline:
        return Container(
          padding: EdgeInsets.all(2.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.r),
            border: Border.all(
              color:
                  isEnable
                      ? outlineColor ?? AppColors.primaryColor
                      : AppColors.grayscaleColor20,
              width: 2.h,
            ),
          ),
          child: GestureDetector(
            onTap: isEnable ? onPressed : null,
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.r),
                color:
                    isEnable
                        ? outlineColor ?? AppColors.primaryColor
                        : AppColors.grayscaleColor20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.w,
                children: [
                  if (icon != null)
                    Image.asset(icon!, width: 24.w, height: 24.w),
                  Text(
                    title.toUpperCase(),
                    style: AppTextStyles.bold14().copyWith(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        );

      case AppButtonType.remove:
        return Container(
          padding: EdgeInsets.all(2.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360.r),
            border: Border.all(
              color:
                  isEnable
                      ? AppColors.warningColor
                      : AppColors.grayscaleColor20,
              width: 2.w,
            ),
          ),
          child: GestureDetector(
            onTap: isEnable ? onPressed : null,
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.w,
                children: [
                  if (icon != null)
                    Image.asset(icon!, width: 24.w, height: 24.w),
                  Text(
                    title.toUpperCase(),
                    style: AppTextStyles.bold14().copyWith(
                      color:
                          isEnable
                              ? AppColors.warningColor
                              : AppColors.grayscaleColor20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      case AppButtonType.text:
        return GestureDetector(
          onTap: isEnable ? onPressed : null,
          child: Container(
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(360.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 8.w,
              children: [
                if (icon != null) Image.asset(icon!, width: 24.w, height: 24.w),
                Text(
                  title.toUpperCase(),
                  style: AppTextStyles.bold14().copyWith(
                    color:
                        isEnable
                            ? colorText ?? AppColors.primaryColor
                            : AppColors.grayscaleColor20,
                  ),
                ),
              ],
            ),
          ),
        );
      case AppButtonType.nomal:
        return Container(
          padding: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(360),
            border: Border.all(
              color:
                  isEnable
                      ? AppColors.primaryColor
                      : AppColors.grayscaleColor20,
              width: 2,
            ),
          ),
          child: GestureDetector(
            onTap: isEnable ? onPressed : null,
            child: Container(
              height: 38.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 8.w,
                children: [
                  if (icon != null)
                    Image.asset(icon!, width: 24.w, height: 24.w),
                  Text(
                    title.toUpperCase(),
                    style: AppTextStyles.bold14().copyWith(
                      color:
                          isEnable
                              ? AppColors.primaryColor
                              : AppColors.grayscaleColor20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }
}
