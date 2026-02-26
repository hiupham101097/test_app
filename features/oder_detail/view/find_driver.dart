import 'package:flutter/material.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class FindDriver extends StatelessWidget {
  final Function() onTap;
  const FindDriver({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.primaryColor20,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Stack(
            children: [
              SizedBox(
                width: 30.w,
                height: 30.h,
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor70,
                  strokeWidth: 2.w,
                ),
              ),
              Positioned(
                top: 3.r,
                left: 3.r,
                right: 3.r,
                bottom: 3.r,
                child: Container(
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor70,
                    borderRadius: BorderRadius.circular(360.r),
                  ),
                  child: Image.asset(
                    AssetConstants.icBike,
                    width: 16.w,
                    height: 16.h,
                  ),
                ),
              ),
            ],
          ),

          SizedBox(width: 8.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đang tìm tài xế",
                  style: AppTextStyles.semibold12().copyWith(
                    color: AppColors.primaryColor80,
                  ),
                ),
                Text(
                  "Chúng tôi đang tìm tài xế gần nhất cho bạn",
                  style: AppTextStyles.regular12(),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              onTap();
            },
            child: Icon(
              Icons.close,
              size: 24.sp,
              color: AppColors.grayscaleColor60,
            ),
          ),
        ],
      ),
    );
  }
}
