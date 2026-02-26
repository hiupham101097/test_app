import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

class PayWidget extends StatelessWidget {
  const PayWidget({super.key, required this.oderDetail});
  final OderDetailModel oderDetail;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 12.w),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "pay_method".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Image.asset(
                AppUtil.getImagePaymentMethod(oderDetail.paymentMethod),
                fit: BoxFit.cover,
                width: 24.r,
                height: 24.r,
              ),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  AppUtil.formatPaymentMethod(oderDetail.paymentMethod),
                  style: AppTextStyles.regular13(),
                ),
              ),
              Text(
                AppUtil.formatMoney(oderDetail.priceAfterVoucher),
                style: AppTextStyles.semibold13(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
