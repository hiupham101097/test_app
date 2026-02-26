import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'support_controller.dart';

class SupportPage extends GetView<SupportController> {
  const SupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "Trung tâm hỗ trợ",
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
          child: _buildBody(),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            AssetConstants.logoGober,
            width: 129.w,
            height: 129.w,
            fit: BoxFit.cover,
          ),
          SizedBox(height: 20.h),

          _buildInfo(
            icon: AssetConstants.icLocation,
            title: "Địa chỉ: ",
            content:
                "L17-11, Tầng 17, Tòa nhà Vincom Center, 72 Lê Thánh Tôn, P. Bến Nghé, Quận 1, TP. Hồ Chí Minh.",
            onTap: () {
              AppUtil.openMap(
                "L17-11, Tầng 17, Tòa nhà Vincom Center, 72 Lê Thánh Tôn, P. Bến Nghé, Quận 1, TP. Hồ Chí Minh.",
              );
            },
          ),
          SizedBox(height: 8.h),
          _buildInfo(
            icon: AssetConstants.icPhonePramiry,
            title: "Hotline: ",
            content: "0935 319 739",
            onTap: () {
              AppUtil.callPhoneNumber("0935 319 739");
            },
          ),
          SizedBox(height: 8.h),
          _buildInfo(
            title: "Email: ",
            icon: AssetConstants.icMail,
            content: "info@chothongminh.com",
            onTap: () {
              AppUtil.openUrl("mailto:info@chothongminh.com");
            },
          ),
          SizedBox(height: 8.h),
          _buildInfo(
            title: "Website: ",
            icon: AssetConstants.icWebsite,
            content: "https://chothongminh.com",
            onTap: () {
              AppUtil.openUrl("https://chothongminh.com");
            },
          ),
          SizedBox(height: 8.h),
          _buildInfo(
            title: "Facebook: ",
            icon: AssetConstants.icFb,
            content: "https://facebook.com/dichogiupban",
            onTap: () {
              AppUtil.openUrl("https://facebook.com/dichogiupban");
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInfo({
    required String title,
    required String content,
    Function()? onTap,
    required String icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.backgroundColor24,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: AppColors.grayscaleColor30, width: 0.3.w),
          boxShadow: [
            BoxShadow(
              color: AppColors.grayscaleColor30,
              blurRadius: 1.r,
              offset: Offset(0, 1.0),
            ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: [
            Image.asset(icon, width: 20.w, height: 20.w),
            SizedBox(width: 8.w),
            Expanded(
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: title,
                      style: AppTextStyles.semibold12().copyWith(
                        color: AppColors.grayscaleColor80,
                      ),
                    ),
                    TextSpan(
                      text: content,
                      style: AppTextStyles.regular12().copyWith(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
