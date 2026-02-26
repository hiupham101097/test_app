import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class StatusCancel extends StatelessWidget {
  const StatusCancel({
    super.key,
    required this.fromType,
    required this.createDate,
    required this.reasonCancel,
  });
  final String fromType;
  final String createDate;
  final String reasonCancel;

  @override
  Widget build(BuildContext context) {
    String getUserCancelOder(String type) {
      switch (type) {
        case "USER":
          return "Khách hàng";
        case "STORE":
          return "Cửa hàng";
        case "ADMIN":
          return "Hệ thống";
      }
      return "";
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 14.h),
      decoration: BoxDecoration(
        color: AppColors.warningColor10,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Đơn hàng đã bị hủy",
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.warningColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Đơn hàng được hủy bởi ${getUserCancelOder(fromType)}, vào lúc ${DateUtil.formatDateStr(createDate, format: 'HH:mm, dd/MM/yyyy')}",
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Lý do: ${reasonCancel}",
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }
}
