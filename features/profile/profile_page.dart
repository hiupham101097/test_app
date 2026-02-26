import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/profile/widget/policy_terms.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'profile_controller.dart';

class ProfilePage extends GetView<ProfileController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor24,
      appBar: AppBar(
        title: Text(
          "account".tr,
          style: AppTextStyles.bold14().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        leading: IconButton(
          icon: FaIcon(
            FontAwesomeIcons.chevronLeft,
            size: 20.r,
            color: AppColors.grayscaleColor80,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color.fromARGB(255, 192, 235, 135), Colors.white],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: CustomEasyRefresh(
        controller: controller.controller,
        onRefresh: controller.onRefresh,
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildBody(),
          childCount: 1,
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Column(
      children: [
        _buildHeader(),
        SizedBox(height: 24.h),
        _myActivities(),
        SizedBox(height: 24.h),
        _supportAndPolicy(),
        SizedBox(height: 28.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AppButton(
            title: "logout".tr,
            onPressed: () {
              controller.logoutConfirm();
            },
            icon: AssetConstants.icLogout,
          ),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: AppButton(
            title: "Xoá tài khoản".tr,
            type: AppButtonType.text,
            colorText: AppColors.warningColor,
            onPressed: () {
              controller.deleteAccountConfirm();
            },
          ),
        ),
        SizedBox(
          height:
              MediaQuery.of(Get.context!).systemGestureInsets.bottom > 32.h
                  ? 40.h
                  : 20.h,
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(100.r),
              child: CachedImage(
                url: controller.store.value.imageUrlMap,
                fit: BoxFit.cover,
                width: 64.w,
                height: 64.w,
              ),
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                if (index < controller.store.value.rating.floor()) {
                  return Icon(Icons.star, color: AppColors.attentionColor);
                } else if (index < controller.store.value.rating &&
                    controller.store.value.rating % 1 != 0) {
                  return Icon(Icons.star_half, color: AppColors.attentionColor);
                } else {
                  return Icon(Icons.star, color: AppColors.grayscaleColor20);
                }
              }),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Text(
                controller.store.value.name,
                style: AppTextStyles.medium16().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 8.h),

            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildInfoTotalOrder(
                    title: "cancel_trip".tr,
                    value:
                        "${controller.canCelOrder.value + controller.canceledByDriver.value}",
                    icon: Icons.close,
                    color: AppColors.warningColor30,
                  ),
                  SizedBox(width: 16.w),
                  _buildInfoTotalOrder(
                    title: "evaluation".tr,
                    value:
                        "${controller.evaluateOverview.value.totalRatingCount}",
                    icon: Icons.star,
                    color: AppColors.attentionColor30,
                  ),
                  SizedBox(width: 16.w),
                  _buildInfoTotalOrder(
                    title: "completed".tr,
                    value: "${controller.completedOrder.value}",
                    icon: Icons.check,
                    color: AppColors.successColor20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTotalOrder({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 8.h),
      width: 80.w,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.grayscaleColor80,
                  blurRadius: 1.r,
                  offset: Offset(0, 1.0),
                ),
              ],
            ),
            padding: EdgeInsets.all(6.r),
            child: Icon(icon, color: color, size: 14.sp),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: AppTextStyles.semibold20().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            title,
            style: AppTextStyles.medium12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _myActivities() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "my_activity".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          _buildItem(
            "store_information".tr,
            AssetConstants.icAccountCircle,
            onTap: () {
              Get.toNamed(Routes.infoProfile);
            },
          ),
          _buildItem(
            "Đơn bồi hoàn",
            AssetConstants.icRefund,
            onTap: () {
              Get.toNamed(Routes.refund);
            },
          ),
          _buildItem(
            "setting_time".tr,
            AssetConstants.icTimer,
            onTap: () {
              Get.toNamed(Routes.settingTime);
            },
          ),
          _buildItem(
            "income_statistics".tr,
            AssetConstants.icChart,
            onTap: () {
              Get.toNamed(Routes.incomeStatistics);
            },
          ),
          _buildItem(
            "evaluate".tr,
            AssetConstants.icChat,
            onTap: () {
              Get.toNamed(Routes.evaluate);
            },
          ),
        ],
      ),
    );
  }

  Widget _supportAndPolicy() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "support_center".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 8.h),
          _buildItem(
            "support_center".tr,
            AssetConstants.icSupportAgent,
            onTap: () {
              Get.toNamed(Routes.support);
            },
          ),
          GestureDetector(
            onTap: () {
              Get.to(() => PolicyTerms());
            },
            child: _buildItem("policy_terms".tr, AssetConstants.icPolicy),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, String icon, {GestureTapCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.grayscaleColor30, width: 0.3.w),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              icon,
              width: 20.w,
              height: 20.w,
              color: AppColors.grayscaleColor60,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                title,
                style: AppTextStyles.regular14().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
              ),
            ),
            SizedBox(width: 10.w),
            FaIcon(
              FontAwesomeIcons.chevronRight,
              color: AppColors.grayscaleColor80,
              size: 12.w,
            ),
          ],
        ),
      ),
    );
  }
}
