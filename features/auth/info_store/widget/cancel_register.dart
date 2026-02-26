import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class CancelRegister extends StatelessWidget {
  const CancelRegister({
    super.key,
    required this.reasonCancel,
    required this.onTap,
  });
  final String reasonCancel;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
          decoration: BoxDecoration(
            color: AppColors.warningColor10,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Đã từ chối",
                style: AppTextStyles.semibold14().copyWith(
                  color: AppColors.warningColor,
                ),
              ),
              Text(
                reasonCancel,
                style: AppTextStyles.regular12().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              SizedBox(height: 4.h),
              GestureDetector(
                onTap: () {
                  onTap();
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      "Xem chi tiết",
                      style: AppTextStyles.regular12().copyWith(
                        color: AppColors.warningColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Container(
                      padding: EdgeInsets.all(2.r),
                      decoration: BoxDecoration(
                        color: AppColors.warningColor,
                        borderRadius: BorderRadius.circular(100.r),
                      ),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.white,
                        size: 16.w,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
