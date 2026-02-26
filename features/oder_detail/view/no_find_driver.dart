import 'package:flutter/material.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class NoFindDriver extends StatelessWidget {
  const NoFindDriver({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.warningColor10,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(7.w),
            decoration: BoxDecoration(
              color: AppColors.warningColor,
              borderRadius: BorderRadius.circular(360.r),
            ),
            child: Image.asset(
              AssetConstants.noFindDriver,
              width: 16.w,
              height: 16.h,
            ),
          ),

          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Rất tiếc! Chưa tìm thấy tài xế phù hợp.",
                  style: AppTextStyles.semibold12().copyWith(
                    color: AppColors.warningColor,
                  ),
                ),
                Text(
                  "Vui lòng thử lại hoặc chọn phương án khác nhé!",
                  style: AppTextStyles.regular12().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
