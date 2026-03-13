import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/domain/data/models/voucher_discount_model.dart';
import 'package:merchant/features/voucher_discount/voucher_discount_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class VoucherDiscountPage extends GetView<VoucherDiscountController> {
  const VoucherDiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "Voucher giảm giá",
      backgroundColor: AppColors.backgroundColor24,
      child: _buildBody(),
      floatingActionButton: _buildAddButton(),
    );
  }

  Widget _buildBody() {
    return Obx(() {
      if (controller.listVoucher.isEmpty) {
        return Center(
          child: Text(
            "Tạo voucher mua sắm ngay",
            style: AppTextStyles.medium14(),
          ),
        );
      }

      return ListView.separated(
        padding: EdgeInsets.all(16.r),
        itemCount: controller.listVoucher.length,
        separatorBuilder: (_, __) => SizedBox(height: 14.h),
        itemBuilder: (context, index) {
          final voucher = controller.listVoucher[index];
          return _buildVoucherItem(voucher);
        },
      );
    });
  }

  Widget _buildVoucherItem(VoucherDiscountModel voucher) {
    return GestureDetector(
      onTap: () => controller.openVoucher(voucher),
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          children: [
            _buildLeftIcon(voucher),
            SizedBox(width: 14.w),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(voucher.name ?? "", style: AppTextStyles.semibold14()),

                  SizedBox(height: 4.h),

                  Text(
                    "Đơn tối thiểu ${voucher.minOrderValue ?? 0}",
                    style: AppTextStyles.regular12(),
                  ),

                  Divider(),

                  Text(
                    "HSD: ${_getExpiryDate(voucher)}",
                    style: AppTextStyles.regular12(),
                  ),
                ],
              ),
            ),

            Icon(Icons.radio_button_unchecked),
          ],
        ),
      ),
    );
  }

  Widget _buildLeftIcon(VoucherDiscountModel voucher) {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        gradient: LinearGradient(
          colors: [
            safeColor(voucher.color?.medium, const Color(0xffB0AAF3)),
            safeColor(voucher.color?.wild, const Color(0xff3624FF)),
          ],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.discount, color: Colors.white),
          SizedBox(height: 4),
          Text("Giảm giá", style: TextStyle(color: Colors.white, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return FloatingActionButton(
      onPressed: controller.createVoucher,
      backgroundColor: AppColors.primaryColor,
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  String _getExpiryDate(VoucherDiscountModel voucher) {
    final expiryDate = voucher.endDate;

    return "${expiryDate!.day}/${expiryDate.month}/${expiryDate.year}";
  }

  Color safeColor(String? hex, Color fallback) {
    if (hex == null || hex.isEmpty) return fallback;
    try {
      var hexColor = hex.replaceAll('#', '');
      if (hexColor.length == 6) hexColor = 'FF$hexColor';
      return Color(int.parse(hexColor, radix: 16));
    } catch (_) {
      return fallback;
    }
  }
}
