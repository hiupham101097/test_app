import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class PleaceHolderView extends StatelessWidget {
  final Function() onTap;
  final double? width;
  final double? height;
  const PleaceHolderView({
    super.key,
    required this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        width: width ?? (Get.width - 48.w) / 2,
        height: height ?? 118.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          color: AppColors.backgroundColor24,
          border: Border.all(color: AppColors.grayscaleColor10, width: 0.5.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.grayscaleColor10,
              blurRadius: 1.r,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          spacing: 8.h,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10.w),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(360.r),
                border: Border.all(color: AppColors.primaryColor, width: 0.5.w),
              ),
              child: Icon(
                size: 28.w,
                Icons.camera_alt,
                color: AppColors.primaryColor30,
              ),
            ),
            Text(
              "Chọn ảnh",
              style: AppTextStyles.regular14().copyWith(
                color: AppColors.grayscaleColor40,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
