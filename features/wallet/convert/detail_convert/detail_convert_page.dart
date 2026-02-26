import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/wallet/convert/detail_convert/detail_convert_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DetailConvertPage extends GetView<DetailConvertController> {
  const DetailConvertPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      backgroundColor: AppColors.backgroundColor24,
      title: 'detail_transaction'.tr,
      child: Container(padding: EdgeInsets.all(16.w), child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        Image.asset(AssetConstants.icSuccess, width: 69.w, height: 69.h),
        SizedBox(height: 16.h),
        Text('Chuyển đổi thành công', style: AppTextStyles.semibold14()),
        SizedBox(height: 16.h),
        Container(
          padding: EdgeInsets.all(12.r),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayscaleColor20),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              Image.asset(
                AssetConstants.icMoneyCash,
                width: 29.w,
                height: 40.h,
              ),
              SizedBox(width: 24.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ví tiền mặt', style: AppTextStyles.regular12()),
                  Text('999.999đ', style: AppTextStyles.semibold16()),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildItemInfo('Mã giao dịch', '100.000đ'),
        _buildItemInfo('Mã giao dịch', 'ABC1234AA'),
        _buildItemInfo('Thời gian', '10/10/2021'),
        _buildItemInfo('Hình thức', 'Chuyển khoản'),
        _buildItemInfo('Nạp tiền từ Ví điện tử', 'ZaloPay'),
        _buildItemInfo('Phí chuyển khoản', '1.100đ'),
      ],
    );
  }

  Widget _buildItemInfo(String title, String value) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: AppTextStyles.regular14(),
              textAlign: TextAlign.start,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.medium14().copyWith(
                color: AppColors.grayscaleColor70,
              ),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
