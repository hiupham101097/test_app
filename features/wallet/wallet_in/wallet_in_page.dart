import 'package:dotted_line/dotted_line.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/transaction_wallet_in_model.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/features/wallet/wallet_in/wallet_in_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class WalletInPage extends GetView<WalletInController> {
  const WalletInPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: 'Ví tiền vào'.tr),
      body: Obx(
        () => CustomEasyRefresh(
          controller: controller.controller,
          onRefresh: controller.onRefresh,
          infoText:
              '${'now'.tr}: ${controller.listTransaction.length}/ ${controller.total.value}',
          onLoading: controller.onLoadingPage,
          delegate: SliverChildBuilderDelegate(
            (context, index) => buildBody(),
            childCount: 1,
          ),
        ),
      ),
    );
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(children: [_buildHeaderWalletIn(), _buidHistory()]),
    );
  }

  Widget _buildNoteWalletIn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.error, size: 16.w, color: AppColors.grayscaleColor40),
              SizedBox(width: 8.w),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'wallet_in_description_1'.tr,
                        style: AppTextStyles.regular10(),
                      ),
                      TextSpan(text: ' ', style: AppTextStyles.regular10()),
                      TextSpan(
                        text: 'wallet_in_description_2'.tr,
                        style: AppTextStyles.semibold10().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          _buildItemInfo(value: 'wallet_in_description_3'.tr),
          SizedBox(height: 4.h),
          _buildItemInfo(value: 'wallet_in_description_4'.tr),
          SizedBox(height: 4.h),
          _buildItemInfo(value: 'wallet_in_description_5'.tr),
        ],
      ),
    );
  }

  Widget _buildItemInfo({required String value}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 24.w),
        Padding(
          padding: EdgeInsets.only(top: 5.h),
          child: Container(
            height: 3.h,
            width: 3.w,
            decoration: BoxDecoration(
              color: AppColors.grayscaleColor90,
              shape: BoxShape.circle,
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            style: AppTextStyles.regular10().copyWith(
              color: AppColors.grayscaleColor60,
              height: 1.3.h,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAction({
    required String title,
    required String image,
    required Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Image.asset(
            image,
            width: 24.w,
            height: 24.h,
            color: AppColors.grayscaleColor80,
          ),
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

  Widget _buidHistory() {
    return Obx(
      () => Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor16,
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Text(
              'transaction_history'.tr,
              style: AppTextStyles.bold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ),
          SizedBox(height: 16.h),
          if (controller.listTransaction.isNotEmpty)
            ...List.generate(
              controller.listTransaction.length,
              (index) =>
                  _buildItemTransaction(controller.listTransaction[index]),
            ),
          if (controller.listTransaction.isEmpty)
            Center(
              child: CustomEmpty(
                title: 'no_data'.tr,
                width: 100.r,
                height: 100.r,
                image: AssetConstants.icEmptyImage,
              ),
            ),
        ],
      ),
    );
  }

  _buildItemTransaction(TransactionWalletInModel data) {
    final status = data.status?.toString().toLowerCase();
    final transactionType = data.type?.toString().toLowerCase();
    final imageColor =
        transactionType == 'deposit' || transactionType == 'income'
            ? AppColors.successColor
            : transactionType == 'withdraw'
            ? AppColors.warningColor
            : AppColors.infomationColor60;
    final price = AppUtil.formatMoney(
      double.tryParse(data.amount.toString()) ?? 0,
    );
    final priceColor =
        status == 'success'
            ? AppColors.grayscaleColor80
            : status == 'pending'
            ? AppColors.grayscaleColor40
            : AppColors.warningColor;
    final icon =
        transactionType == 'internalWithdraw' ||
                transactionType == 'internalDeposit'
            ? AssetConstants.icTrip
            : transactionType == 'deposit' || transactionType == 'income'
            ? AssetConstants.icDispose
            : AssetConstants.icWithDraw;
    final titleStatus =
        status == 'success'
            ? 'success_status'.tr
            : status == 'pending'
            ? 'pending_status'.tr
            : status == 'cancelled'
            ? 'Từ chối duyệt'.tr
            : 'failed'.tr;
    final statusColor =
        status == 'success'
            ? AppColors.successColor
            : status == 'pending'
            ? AppColors.attentionColor
            : AppColors.warningColor;
    // final titleTransaction =
    //     transactionType == 'deposit'
    //         ? 'deposit_money'.tr
    //         : transactionType == 'withdraw'
    //         ? 'withdraw_money'.tr
    //         : transactionType == 'income'
    //         ? 'Thanh toán đơn hàng'.tr
    //         : 'convert_wallet'.tr;
    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.detailTransaction,
          arguments: {'transactionIn': data, 'type': data.type},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 4.h),
              child: Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(360),
                  border: Border.all(color: imageColor, width: 1),
                ),
                child: Image.asset(
                  icon,
                  color: imageColor,
                  width: 16.w,
                  height: 16.w,
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.description ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.medium14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    DateUtil.formatDate(
                      data.createdAt,
                      format: 'HH:mm, dd/MM/yyyy',
                    ),

                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor40,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  titleStatus,
                  style: AppTextStyles.semibold10().copyWith(
                    color: statusColor,
                  ),
                ),
                Text(
                  price.contains('-') ? price : '+$price',
                  style: AppTextStyles.semibold14().copyWith(color: priceColor),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderWalletIn() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h).copyWith(bottom: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetConstants.icMoneyCash, width: 47.w, height: 64.h),
            SizedBox(height: 12.h),
            Text('Ví tiền vào'.tr, style: AppTextStyles.regular12()),
            Text(
              AppUtil.formatMoney(
                double.tryParse(
                      controller.walletUser.value.withdrawableBalance
                              ?.toString() ??
                          '0',
                    ) ??
                    0,
              ),
              style: AppTextStyles.semibold16().copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            _buildNoteWalletIn(),
            DottedLine(
              dashLength: 7,
              dashGapLength: 2,
              lineThickness: 0.5,
              dashColor: AppColors.grayscaleColor50,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildAction(
                    title: 'Nạp tiền'.tr,
                    image: AssetConstants.icWithDraw,
                    onTap: () {
                      Get.toNamed(Routes.dispose);
                    },
                  ),
                  SizedBox(width: 20.w),
                  _buildAction(
                    title: 'Rút tiền'.tr,
                    image: AssetConstants.icWithDraw,
                    onTap: () {
                      Get.toNamed(
                        Routes.withDraw,
                        arguments: {'type': MyWalletType.walletIn},
                      );
                    },
                  ),
                  SizedBox(width: 20.w),
                  _buildAction(
                    title: 'Chuyển đổi'.tr,
                    image: AssetConstants.icTrip,
                    onTap: () {
                      Get.toNamed(Routes.convert);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
