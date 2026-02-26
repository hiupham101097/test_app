import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class InfoDriver extends StatelessWidget {
  const InfoDriver({
    super.key,
    required this.avatar,
    required this.driverName,
    required this.driverRate,
    required this.vehiclePlate,
    required this.vehicleBrand,
    required this.status,
    required this.phone,
  });
  final String avatar;
  final String driverName;
  final double driverRate;
  final String vehiclePlate;
  final String vehicleBrand;
  final String status;
  final String phone;
  @override
  Widget build(BuildContext context) {
    print("status: $status");
    final normalizedStatus = status.toUpperCase();
    String buildStatus() {
      switch (normalizedStatus) {
        case "PENDING":
          return "Đang chờ xác nhận";
        case "DRIVER_ACCEPTED":
          return "Tài xế đã nhận đơn";
        case "DRIVER_ARRIVED_RECEIVE_POINT":
          return "Tài xế đã đến cửa hàng";
        case "DRIVER_GOING_TO_SEND_POINT":
          return "Tài xế đang đi giao";
        case "DELIVERED":
          return "Đã giao hàng";
        case "DRIVER_GOING_TO_REFUND_POINT":
          return "Tài xế đang đi hoàn trả";
        case "DRIVER_ARRIVED_REFUND_POINT":
          return "Tài xế đến điểm hoàn trả";
        case "DRIVER_COMPLETED_REFUND_POINT":
          return "Hoàn trả thành công";
        case "DRIVER_REJECT":
          return "Tài xế từ chối đơn";
        case "IN_DELIVERY":
          return "Đang giao hàng";
        case "IN_RECIEVE":
          return "Tài xế đang đến cửa hàng";
        case "IN_REFUND":
          return "Tài xế đang đến điểm hoàn trả";
        default:
          return "";
      }
    }

    String buildStatusText() {
      switch (normalizedStatus) {
        case "PENDING":
          return "Đơn hàng đang chờ cửa hàng xác nhận.";
        case "DRIVER_ACCEPTED":
          return "Tài xế đã nhận đơn, chuẩn bị đến cửa hàng lấy hàng.";
        case "DRIVER_ARRIVED_RECEIVE_POINT":
          return "Tài xế đã đến cửa hàng để lấy hàng.";
        case "DRIVER_GOING_TO_SEND_POINT":
          return "Tài xế đang trên đường đến địa điểm giao, chuẩn bị giao hàng.";
        case "DELIVERED":
          return "Tài xế đã giao hàng thành công.";
        case "DRIVER_GOING_TO_REFUND_POINT":
          return "Tài xế đang trên đường đến điểm hoàn trả.";
        case "DRIVER_ARRIVED_REFUND_POINT":
          return "Tài xế đã đến điểm hoàn trả và đang xử lý.";
        case "DRIVER_COMPLETED_REFUND_POINT":
          return "Tài xế đã thực hiện hoàn trả thành công.";
        case "DRIVER_REJECT":
          return "Tài xế đã từ chối, đơn hàng bị hủy.";
        case "IN_DELIVERY":
          return "Tài xế đã lấy hàng và đang giao cho khách.";
        case "IN_RECIEVE":
          return "Tài xế đang trên đường đến cửa hàng để lấy hàng.";
        case "IN_REFUND":
          return "Tài xế đang trên đường đến điểm hoàn trả.";

        default:
          return "";
      }
    }

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: EdgeInsets.symmetric(horizontal: 12.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor10,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                buildStatus(),
                style: AppTextStyles.semibold14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
              Text(
                buildStatusText(),
                style: AppTextStyles.regular12().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: DottedLine(
            dashLength: 7,
            dashGapLength: 2,
            lineThickness: 0.5,
            dashColor: AppColors.grayscaleColor50,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 14.h),
          decoration: BoxDecoration(
            color: AppColors.primaryColor20,
            borderRadius: BorderRadius.circular(8.r),
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
                    bottom: 0,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 1.h,
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
                          Icon(Icons.star, size: 10.sp, color: Colors.yellow),
                          SizedBox(width: 2.w),
                          Text(
                            driverRate.toString(),
                            style: AppTextStyles.regular10().copyWith(
                              fontSize: 8.sp,
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
                  spacing: 4.h,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      driverName.toUpperCase(),
                      style: AppTextStyles.medium14().copyWith(
                        color: AppColors.primaryColor80,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (vehiclePlate.isNotEmpty &&
                        vehiclePlate != "Đang cập nhật...")
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 4.w,
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
                        child: Text(
                          vehiclePlate,
                          style: AppTextStyles.semibold10().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ),
                    if (vehicleBrand.isNotEmpty &&
                        vehicleBrand != "Đang cập nhật...")
                      Text(
                        vehicleBrand,
                        style: AppTextStyles.regular11(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              if (phone.isNotEmpty && phone != "Đang cập nhật...")
                GestureDetector(
                  onTap: () {
                    AppUtil.callPhoneNumber(phone);
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor10,
                      borderRadius: BorderRadius.circular(360.r),
                    ),
                    child: Icon(
                      Icons.call_outlined,
                      size: 16.sp,
                      color: AppColors.primaryColor70,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
