import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';

class MyWalletPage extends GetView<MyWalletController> {
  const MyWalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      isBack: false,
      title: 'my_wallet'.tr,
      child: CustomEasyRefresh(
        controller: controller.controller,
        onRefresh: controller.onRefresh,
        delegate: SliverChildBuilderDelegate(
          (context, index) => _buildBody(),
          childCount: 1,
        ),
      ),
      // child: SingleChildScrollView(child: _buildBody()),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        child: Column(
          children: [
            Image.asset(
              AssetConstants.myWallet,
              width: 182.w,
              height: 195.h,
              fit: BoxFit.cover,
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.primaryColor10,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 12.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor5,
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primaryColor80,
                        width: 1.r,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.grayscaleColor10,
                          blurRadius: 1.r,
                          offset: Offset(1.w, 2.h),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          spacing: 15.w,
                          children: [
                            _buildBalance(
                              title: 'Ví tiền vào'.tr,
                              balance: AppUtil.formatMoney(
                                controller.myWallet.value.withdrawableBalance ??
                                    0,
                              ),
                              image: AssetConstants.icMoneyCash,
                              onTap: () {
                                Get.toNamed(Routes.walletIn);
                              },
                            ),
                            _buildBalance(
                              title: 'Ví chiết khấu'.tr,
                              balance: AppUtil.formatMoney(
                                double.tryParse(
                                      controller.walletUser.value.wallet
                                              ?.toString() ??
                                          '0',
                                    ) ??
                                    0,
                              ),
                              image: AssetConstants.icMoneyBalance,
                              onTap: () {
                                Get.toNamed(Routes.walletDiscount);
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  _buildItemInfo(
                    title: 'Tài khoản ký quỹ'.tr,
                    value: AppUtil.formatMoney(
                      double.tryParse(controller.moneyDiscount.value) ?? 0,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '*${'minimum_balance'.tr}',
                    style: AppTextStyles.regular10().copyWith(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Divider(
                    color: AppColors.grayscaleColor20,
                    height: 8.h,
                    thickness: 0.3.r,
                  ),
                  SizedBox(height: 4.h),
                  _buildItemInfo(
                    title: 'Tiền đang chờ duyệt'.tr,
                    value: AppUtil.formatMoney(
                      controller.myWallet.value.pendingBalance ?? 0,
                    ),
                  ),
                  Divider(
                    color: AppColors.grayscaleColor20,
                    height: 16.h,
                    thickness: 0.3.r,
                  ),
                  _buildItemInfo(
                    title: 'withdrawable_balance_description'.tr,
                    value: AppUtil.formatMoney(
                      controller.myWallet.value.withdrawableBalance ?? 0,
                    ),
                    colorTitle: AppColors.grayscaleColor80,
                    colorValue: AppColors.successColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBalance({
    required String title,
    required String balance,
    required String image,
    required Function() onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: AppColors.primaryColor5,
            border: Border.all(color: AppColors.primaryColor, width: 0.4.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.14),
                blurRadius: 1.r,
                offset: Offset(0.w, 2.h),
              ),
            ],
          ),
          child: Column(
            children: [
              Image.asset(image, width: 47.w, height: 64.h),
              SizedBox(height: 12.h),
              Text(title, style: AppTextStyles.regular12()),
              Text(
                balance,
                style: AppTextStyles.semibold15().copyWith(
                  color: AppColors.primaryColor80,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required String title,
    required String image,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(image, width: 20.w, height: 20.h, fit: BoxFit.cover),
          SizedBox(height: 8.h),
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

  Widget _buildItemInfo({
    required String title,
    required String value,
    Color? colorTitle = AppColors.grayscaleColor60,
    Color? colorValue = AppColors.grayscaleColor60,
  }) {
    return Row(
      children: [
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.medium14().copyWith(color: colorTitle),
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.medium14().copyWith(color: colorValue),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
