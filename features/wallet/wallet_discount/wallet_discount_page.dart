import 'package:dotted_line/dotted_line.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/transaction_model.dart';
import 'package:merchant/features/wallet/my_wallet/my_wallet_controller.dart';
import 'package:merchant/features/wallet/wallet_discount/wallet_discount_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class WalletDiscountPage extends GetView<WalletDiscountController> {
  const WalletDiscountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: CustomAppBar(title: 'Ví chiết khấu'.tr),
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

  Widget buildHeader() {
    return SingleChildScrollView(child: _buildHeaderDiscountWallet());
  }

  Widget buildBody() {
    return SingleChildScrollView(
      child: Column(children: [buildHeader(), _buidHistory()]),
    );
  }

  Widget _buildNoteDiscountWallet() {
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
                        text: 'discount_wallet_can'.tr,
                        style: AppTextStyles.regular10(),
                      ),
                      TextSpan(text: ' ', style: AppTextStyles.regular10()),
                      TextSpan(
                        text: 'withdraw_money_space'.tr,
                        style: AppTextStyles.semibold10().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      TextSpan(text: ' ', style: AppTextStyles.regular10()),

                      TextSpan(
                        text: 'and_use_for'.tr,
                        style: AppTextStyles.regular10(),
                      ),
                      TextSpan(text: ' ', style: AppTextStyles.regular10()),

                      TextSpan(
                        text: 'deduct_platform_fee'.tr,
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
          _buildItemInfo(
            description: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Ví phải duy trì '.tr,
                    style: AppTextStyles.regular10(),
                  ),
                  TextSpan(
                    text: 'số dư tối thiểu 50.000đ.',
                    style: AppTextStyles.semibold10().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  TextSpan(text: ' ', style: AppTextStyles.regular10()),
                  TextSpan(
                    text: 'Nếu số dư nhỏ hơn 50.000đ, bạn sẽ',
                    style: AppTextStyles.regular10(),
                  ),
                  TextSpan(text: ' ', style: AppTextStyles.regular10()),
                  TextSpan(
                    text: 'không thể nhận đơn mới.',
                    style: AppTextStyles.semibold10().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 4.h),
          _buildItemInfo(
            value: 'Dùng để khấu trừ phí nền tảng cho mỗi đơn hàng.'.tr,
          ),
          SizedBox(height: 4.h),
          _buildItemInfo(
            value:
                'Có thể rút về tài khoản ngân hàng, thời gian xử lý từ 2–7 ngày.'
                    .tr,
          ),
        ],
      ),
    );
  }

  Widget _buildItemInfo({String value = '', Widget? description}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: 24.w),
        Container(
          height: 3.h,
          width: 3.w,
          decoration: BoxDecoration(
            color: AppColors.grayscaleColor90,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child:
              description ??
              Text(
                value,
                style: AppTextStyles.regular10().copyWith(
                  color: AppColors.grayscaleColor60,
                  height: 1.h,
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

  _buildItemTransaction(TransactionModel data) {
    final status = data.status?.toString().toLowerCase();
    final transactionType = data.type?.toString().toLowerCase();
    final imageColor =
        transactionType == 'deposit' || transactionType == 'refundCommission'
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
        transactionType == 'deposit'
            ? AssetConstants.icDispose
            : AssetConstants.icWithDraw;

    final titleStatus =
        status == 'success'
            ? 'success_status'.tr
            : status == 'pending'
            ? 'pending'.tr
            : status == 'cancelled'
            ? 'Từ chối duyệt'.tr
            : 'failed'.tr;
    final statusColor =
        status == 'success'
            ? AppColors.successColor
            : status == 'pending'
            ? AppColors.attentionColor
            : AppColors.warningColor;

    return GestureDetector(
      onTap: () {
        Get.toNamed(
          Routes.detailTransaction,
          arguments: {'transactionDiscount': data, 'type': data.type},
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        child: Row(
          children: [
            Container(
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
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.reason ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.medium14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text(
                    DateUtil.formatDate(
                      data.createDate,
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

  Widget _buildHeaderDiscountWallet() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(vertical: 16.h).copyWith(bottom: 0.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(AssetConstants.icMoneyCash, width: 47.w, height: 64.h),
            SizedBox(height: 12.h),
            Text('discount_wallet'.tr, style: AppTextStyles.regular12()),
            Text(
              AppUtil.formatMoney(
                double.tryParse(
                      controller.walletUser.value.wallet?.toString() ?? '0',
                    ) ??
                    0,
              ),
              style: AppTextStyles.semibold16().copyWith(
                color: AppColors.primaryColor,
              ),
            ),
            _buildNoteDiscountWallet(),
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
                    title: 'withdraw_money'.tr,
                    image: AssetConstants.icWithDraw,
                    onTap: () {
                      Get.toNamed(
                        Routes.withDraw,
                        arguments: {'type': MyWalletType.discountWallet},
                      );
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
