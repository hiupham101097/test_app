import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/features/oder_detail/oder_detail_controller.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

class HeaderWidget extends StatelessWidget {
  const HeaderWidget({super.key, required this.oderDetail});
  final OderDetailModel oderDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 1.w),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${"order_code".tr}: #${oderDetail.orderId}",
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor16,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                _buildItemSummary(
                  title: "Đặt hàng lúc",
                  value: DateUtil.formatDate(
                    DateTime.tryParse(oderDetail.createDate ?? ''),
                    format: 'HH:mm',
                  ),
                ),
                Container(
                  width: 1.w,
                  height: 16.h,
                  color: AppColors.grayscaleColor10,
                ),
                _buildItemSummary(
                  title: "Dự kiến giao",
                  value: DateUtil.formatDate(
                    DateTime.tryParse(oderDetail.predictDeliveryDate ?? ''),
                    format: 'HH:mm',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildItemSummary({String? title, String? value}) {
    return Expanded(
      child: Column(
        children: [
          Text(title ?? "", style: AppTextStyles.regular10()),
          Text(
            value ?? "",
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }
}
