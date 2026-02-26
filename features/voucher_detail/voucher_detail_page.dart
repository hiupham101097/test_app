import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/features/home_page/view/voucher_item_widget.dart';
import 'package:merchant/features/voucher_detail/voucher_detail_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class VoucherDetailPage extends GetView<VoucherDetailController> {
  const VoucherDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "voucher_detail".tr,
          style: AppTextStyles.bold14().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 16,
            color: AppColors.grayscaleColor80,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFBFDA9D), Color(0xFF60A309)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      // Body
      body: Obx(
        () => Container(
          decoration: const BoxDecoration(color: Color(0xFF60A309)),
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: 80.h),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor24,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(24.r),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: Offset(0, -2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [SizedBox(height: 72.h), _buildInfoVoucher()],
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                top: 10.h,
                left: 42.w,
                right: 42.w,
                child: VoucherItemWidget(
                  promotion: controller.voucherDetail.value,
                  isJoin: true,
                  onJoin: () {
                    controller.onJoinVoucher();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => Container(
          color: AppColors.backgroundColor24,
          padding: EdgeInsets.all(16.w),
          child: AppButton(
            title:
                controller.voucherDetail.value.isExisted
                    ? "joined".tr
                    : "join".tr,
            isEnable: !controller.voucherDetail.value.isExisted,
            onPressed: () {
              controller.onJoinVoucher();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildInfoVoucher() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "voucher_info".tr,
            style: AppTextStyles.bold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            controller.voucherDetail.value.description,
            style: AppTextStyles.regular14(),
          ),
        ],
      ),
    );
  }
}
