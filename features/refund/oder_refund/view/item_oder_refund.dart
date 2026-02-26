import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/domain/data/models/order_group_month_model.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/features/refund/request_refund/request_refund_controller.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class ItemOrderRefundByMonth extends StatelessWidget {
  const ItemOrderRefundByMonth({
    super.key,
    required this.item,
    required this.onTap,
  });
  final OrderGroupMonthModel item;
  final Function(OrderModel order) onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          DateUtil.formatVietnameseWeekdayWithDate(
            DateTime.tryParse(item.month),
            short: false,
          ),
          style: AppTextStyles.semibold14().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        SizedBox(height: 4.h),
        Column(
          spacing: 12.h,
          children: List.generate(item.orders.length, (index) {
            final status =
                item.orders[index].refundStatus.isNotEmpty &&
                        item.orders[index].refundStatus != ''
                    ? item.orders[index].refundStatus
                    : item.orders[index].orderStatus;

            return GestureDetector(
              onTap: () {
                onTap(item.orders[index]);
              },
              child: Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor24,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.grayscaleColor40,
                    width: 0.2.w,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grayscaleColor10,
                      blurRadius: 2.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '#${item.orders[index].orderId}',
                                style: AppTextStyles.medium14().copyWith(
                                  color: AppColors.grayscaleColor80,
                                ),
                              ),
                              Text(
                                DateUtil.formatDate(
                                  DateTime.tryParse(
                                    item.orders[index].createDate ?? '',
                                  ),
                                  format: 'HH:mm dd/MM/yyyy',
                                ),
                                style: AppTextStyles.regular12().copyWith(
                                  color: AppColors.grayscaleColor50,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppUtil()
                                .getStatusColor(status)
                                .withOpacity(0.2),
                            borderRadius: BorderRadius.circular(360),
                            border: Border.all(
                              color: AppUtil().getStatusColor(status),
                              width: 0.5.w,
                            ),
                          ),
                          child: Text(
                            AppUtil().getStatusLabel(status),
                            style: AppTextStyles.medium10().copyWith(
                              color: AppUtil().getStatusColor(status),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: AppColors.grayscaleColor30,
                      thickness: 0.3.w,
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 8.w),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(360.r),
                            child: CachedImage(
                              url: item.orders[index].imageUrl,
                              width: 40.r,
                              height: 40.r,
                              fit: BoxFit.cover,
                            ),
                          ),
                          SizedBox(width: 10.w),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    item.orders[index].name,
                                    style: AppTextStyles.medium12().copyWith(
                                      color: AppColors.grayscaleColor80,
                                    ),
                                  ),
                                  SizedBox(width: 4.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 4.w,
                                      vertical: 2.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryColor,
                                      borderRadius: BorderRadius.circular(2),
                                    ),
                                    child: Text(
                                      'x${item.orders[index].totalOrder}',
                                      style: AppTextStyles.medium10().copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (item.orders[index].totalOrder > 1) ...[
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Image.asset(
                                      AssetConstants.icOrder,
                                      width: 12.w,
                                      height: 12.w,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      'order_has_product'.trArgs([
                                        (item.orders[index].totalOrder - 1)
                                            .toString(),
                                      ]),
                                      style: AppTextStyles.regular12(),
                                    ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      color: AppColors.grayscaleColor30,
                      thickness: 0.3.w,
                    ),
                    Row(
                      children: [
                        item.orders[index].paymentMethod == 'HOME'
                            ? Image.asset(
                              AssetConstants.icPayments,
                              width: 20.w,
                              height: 20.w,
                            )
                            : Icon(
                              Icons.check_circle_outline_rounded,
                              size: 20.r,
                              color: AppColors.primaryColor,
                            ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            item.orders[index].paymentMethod == 'HOME'
                                ? "sum_payment".tr
                                : "order_paid".tr,
                            style: AppTextStyles.regular12(),
                          ),
                        ),

                        Text(
                          AppUtil.formatMoney(
                            item.orders[index].totalOrderPrice,
                          ),
                          style: AppTextStyles.semibold12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ],
                    ),
                    if (item.orders[index].reasonCancel.isNotEmpty) ...[
                      Divider(
                        color: AppColors.grayscaleColor30,
                        thickness: 0.3.w,
                      ),
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber_outlined,
                            size: 20.r,
                            color: AppColors.warningColor,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            item.orders[index].reasonCancel,
                            style: AppTextStyles.regular12().copyWith(
                              color: AppColors.warningColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ],
    );
  }
}
