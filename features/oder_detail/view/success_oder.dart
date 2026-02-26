import 'package:flutter/material.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class SuccessOder extends StatelessWidget {
  const SuccessOder({
    super.key,
    required this.avatar,
    required this.driverName,
    required this.driverRate,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.phone,
  });
  final String avatar;
  final String driverName;
  final double driverRate;
  final String vehiclePlate;
  final String vehicleBrand;
  final String phone;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
            decoration: BoxDecoration(
              color: AppColors.primaryColor10,
              borderRadius: BorderRadius.circular(8.r),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Đơn hàng của bạn đã hoàn tất",
                  style: AppTextStyles.semibold14().copyWith(
                    color: AppColors.primaryColor,
                  ),
                ),
                Text(
                  "Đơn hàng của bạn đã được giao thành công.",
                  style: AppTextStyles.regular12().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            "Thông tin tài xế",
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grayscaleColor10,
                  width: 1.w,
                ),
              ),
            ),
            child: Row(
              children: [
                Stack(
                  alignment: Alignment.bottomCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFF34D4EA),
                        borderRadius: BorderRadius.circular(360.r),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(360.r),
                        child: CachedImage(
                          url: avatar,
                          width: 52.r,
                          height: 52.r,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    Positioned(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 2.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(360.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4.r,
                              offset: Offset(0, 2.h),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: 12.sp, color: Colors.yellow),
                            SizedBox(width: 2.w),
                            Text(
                              driverRate.toString(),
                              style: AppTextStyles.regular10().copyWith(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    spacing: 2.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        driverName,
                        style: AppTextStyles.medium14().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "$vehiclePlate | $vehicleBrand",
                        style: AppTextStyles.regular12(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  height: 40.h,
                  width: 1.w,
                  color: AppColors.grayscaleColor10,
                ),
                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    AppUtil.callPhoneNumber(phone);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(360.r),
                    ),
                    child: Icon(
                      Icons.phone_enabled_outlined,
                      size: 16.sp,
                      color: Colors.white,
                    ),
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
