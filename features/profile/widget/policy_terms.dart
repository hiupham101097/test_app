import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class PolicyTerms extends StatefulWidget {
  const PolicyTerms({super.key});

  @override
  State<PolicyTerms> createState() => _PolicyTermsState();
}

class _PolicyTermsState extends State<PolicyTerms> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor24,
      appBar: CustomAppBar(title: "policy_terms".tr),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 8.w),
        child: Column(
          children: [
            _buildItem("Chính Sách Bảo Mật", () {
              AppUtil.openUrl(
                "https://chothongminh.com/chi-tiet-tin-tuc/chinh-sach-bao-mat",
              );
            }),
            _buildItem("Giải Quyết Khiếu Nại", () {
              AppUtil.openUrl(
                "https://chothongminh.com/chi-tiet-tin-tuc/co-che-giai-quyet-tranh-chap",
              );
            }),
            _buildItem("Quy Chế Hoạt Động", () {
              AppUtil.openUrl(
                "https://chothongminh.com/chi-tiet-tin-tuc/quy-che-hoat-dong-phan-1",
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(String title, Function()? onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(color: AppColors.backgroundColor24),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.bold14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
