import 'dart:io';

import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/home_page/view/voucher_item_widget.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'voucher_controller.dart';

class VoucherPage extends GetView<VoucherController> {
  const VoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      isShowDivider: false,
      title: "promotion".tr,
      child: Column(
        children: [
          _buildTabBar(),
          Obx(() {
            final listVoucher =
                controller.tabController.index == 0
                    ? controller.listVoucher
                    : controller.listVoucherJoined;
            final total = controller.total.value;
            return Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.r),
                child: CustomEasyRefresh(
                  controller: controller.controller,
                  onRefresh: controller.onRefresh,
                  infoText: '${'now'.tr}: ${listVoucher.length}/ $total',
                  onLoading: controller.onLoadingPage,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => Container(
                      padding: EdgeInsets.only(
                        bottom: index == listVoucher.length - 1 ? 0 : 16.h,
                        top: index == 0 ? 16.h : 0,
                      ),
                      child: VoucherItemWidget(
                        promotion: listVoucher[index],
                        isJoin: false,
                        onJoin: () {},
                      ),
                    ),
                    childCount: listVoucher.length,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  _buildTabBar() {
    return TabBar(
      controller: controller.tabController,
      isScrollable: false,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: AppColors.infomationColor,
      labelColor: AppColors.infomationColor,
      splashFactory: NoSplash.splashFactory,
      unselectedLabelColor: AppColors.grayscaleColor80,
      labelStyle: AppTextStyles.medium14(),
      unselectedLabelStyle: AppTextStyles.medium14(),
      padding: EdgeInsets.zero,
      indicatorWeight: 2,
      dividerColor: AppColors.grayscaleColor20,
      onTap: (index) {
        controller.onChangeTab(index);
      },
      tabs: [Tab(text: 'Mã khuyến mãi'), Tab(text: 'Quản lý khuyến mãi')],
    );
  }

  Widget _buildListVoucher() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        child: Row(
          children: List.generate(
            controller.listVoucher.length,
            (index) => Container(
              margin: EdgeInsets.only(right: index == 9 ? 0 : 8.w),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Image.asset(
                  AssetConstants.imgBackgroundHome,
                  width: 290.w,
                  height: 155.h,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
