import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/features/confirm_order/confirm_order_controller.dart';
import 'package:merchant/features/oder_detail/oder_detail_controller.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

class SumaryOrder extends StatelessWidget {
  const SumaryOrder({super.key, required this.oderDetail});
  final OderDetailModel oderDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "order_summary".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12),
          _buildItemInfo(
            title: "Tổng tiền hàng".tr,
            value: AppUtil.formatMoney(oderDetail.totalOrderPrice),
          ),

          _buildItemInfo(
            title: "Tổng tiền hàng sau Khuyến mại".tr,
            value: AppUtil.formatMoney(oderDetail.discountedVoucherAmount),
          ),
          _buildItemInfo(
            title: "Phí VAT đã bao gồm trong giá bán".tr,
            value: '',
          ),
          _buildItemInfo(
            title: "Phí vận chuyển".tr,
            value: AppUtil.formatMoney(oderDetail.deliveryShip),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(
                  flex: 2,
                  child: Text(
                    "total_payment".tr,
                    style: AppTextStyles.semibold13(),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  flex: 2,
                  child: Text(
                    AppUtil.formatMoney(oderDetail.priceAfterVoucher),
                    style: AppTextStyles.semibold13(),
                    textAlign: TextAlign.end,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildItemInfo({String? title, String? value}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(title ?? "", style: AppTextStyles.regular13()),
          ),
          SizedBox(width: 12),
          Expanded(
            flex: 1,
            child: Text(
              value ?? "",
              style: AppTextStyles.regular13(),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
