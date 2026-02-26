import 'package:lottie/lottie.dart';
import 'package:merchant/commons/types/status_oder_enum.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/domain/data/models/order_model.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BuildItemOrderWidget extends StatelessWidget {
  const BuildItemOrderWidget({
    super.key,
    required this.item,
    this.showSelectedItem = false,
    this.onSelectItem,
    this.onLongPress,
  });
  final OrderModel item;
  final bool showSelectedItem;
  final Function()? onLongPress;
  final Function(OrderModel)? onSelectItem;

  @override
  Widget build(BuildContext context) {
    final statusDriver = item.statusDriver.toUpperCase();
    return GestureDetector(
      onLongPress: () {
        onLongPress?.call();
      },
      onTap: () {
        if (showSelectedItem) {
          onSelectItem?.call(item);
        } else {
          if (item.orderStatus == "PENDING") {
            Get.toNamed(
              Routes.confirmOrderDetail,
              arguments: {'orderId': item.orderId},
            );
          } else {
            Get.toNamed(
              Routes.oderDetail,
              arguments: {'orderId': item.orderId},
            );
          }
        }
      },
      child: Container(
        padding: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color:
              item.selected.value
                  ? AppColors.primaryColor5
                  : AppColors.backgroundColor24,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.grayscaleColor40, width: 0.2.w),
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
                if (showSelectedItem) ...[
                  Icon(
                    item.selected.value
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    size: 16.w,
                    color:
                        item.selected.value
                            ? AppColors.primaryColor
                            : AppColors.grayscaleColor80,
                  ),
                  SizedBox(width: 4.w),
                ],
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateUtil.formatDate(
                          DateTime.tryParse(item.createDate ?? ''),
                          format: 'HH:mm, dd/MM/yyyy',
                        ),
                        style: AppTextStyles.regular12().copyWith(
                          color: AppColors.grayscaleColor50,
                          height: 1,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        item.userName,
                        style: AppTextStyles.medium14().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 4.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.successColor40,
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(
                      color:
                          item.orderStatus == "FAILED " ||
                                  item.orderStatus == "CANCELED" ||
                                  item.orderStatus == "DRIVER_CANCELED"
                              ? AppColors.warningColor
                              : StatusOrderEnum.values
                                  .firstWhere(
                                    (e) =>
                                        e.name.toUpperCase() ==
                                        item.orderStatus.toUpperCase(),
                                  )
                                  .getColor(),
                      width: 0.5.w,
                    ),
                  ),
                  child: Text(
                    '#${item.orderId}',
                    style: AppTextStyles.medium10().copyWith(
                      color:
                          item.orderStatus == "FAILED " ||
                                  item.orderStatus == "CANCELED" ||
                                  item.orderStatus == "DRIVER_CANCELED"
                              ? AppColors.warningColor
                              : StatusOrderEnum.values
                                  .firstWhere(
                                    (e) =>
                                        e.name.toUpperCase() ==
                                        item.orderStatus.toUpperCase(),
                                  )
                                  .getColor(),
                    ),
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.grayscaleColor30, thickness: 0.3.w),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: CachedImage(
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                      url: item.imageUrl,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                item.name,
                                style: AppTextStyles.medium12().copyWith(
                                  color: AppColors.grayscaleColor80,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            if (item.quantityFirstOrder > 1)
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 4.w,
                                  vertical: 2.w,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                child: Text(
                                  'x${item.quantityFirstOrder}',
                                  style: AppTextStyles.medium10().copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        if (item.totalOrder > 1)
                          Row(
                            children: [
                              Image.asset(
                                AssetConstants.icOrder,
                                width: 12.w,
                                height: 12.w,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Và ${item.totalOrder - 1} sản phẩm khác...',
                                style: AppTextStyles.regular12(),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: AppColors.grayscaleColor30, thickness: 0.3.w),
            Row(
              children: [
                item.paymentMethod == 'HOME'
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
                    item.paymentMethod == 'HOME'
                        ? "sum_payment".tr
                        : "order_paid".tr,
                    style: AppTextStyles.regular12(),
                  ),
                ),

                Text(
                  AppUtil.formatMoney(item.totalOrderPrice),
                  style: AppTextStyles.semibold12().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ],
            ),
            Divider(color: AppColors.grayscaleColor30, thickness: 0.3),
            SizedBox(height: 8.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Icon(
                  Icons.location_on_outlined,
                  size: 16.w,
                  color: AppColors.grayscaleColor50,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: item.userAddress.split(',').first.trim(),
                          style: AppTextStyles.bold12().copyWith(
                            color: AppColors.grayscaleColor80,
                            height: 1.4,
                          ),
                        ),
                        TextSpan(
                          text:
                              ' - ${item.userAddress.split(',').sublist(1).join(',').trim()}',
                          style: AppTextStyles.regular12().copyWith(height: 1),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (item.orderStatus == "FAILED " ||
                item.orderStatus == "CANCELED" ||
                item.orderStatus == "DRIVER_CANCELED" &&
                    item.reasonCancel.isNotEmpty) ...[
              Divider(color: AppColors.grayscaleColor30, thickness: 0.3),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.warning_amber_outlined,
                    size: 16.w,
                    color: AppColors.warningColor,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.reasonCancel,
                      style: AppTextStyles.semibold12().copyWith(
                        color: AppColors.warningColor,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            if (item.orderStatus == "COMPLETED") ...[
              Divider(color: AppColors.grayscaleColor30, thickness: 0.3),
              Row(
                children: [
                  Icon(
                    Icons.check_circle_outline_rounded,
                    size: 16.w,
                    color: AppColors.successColor,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    "Đơn hàng đã được giao thành công",
                    style: AppTextStyles.semibold12().copyWith(
                      color: AppColors.successColor,
                    ),
                  ),
                ],
              ),
            ],
            if ((statusDriver == "SEARCHING_FOR_DRIVER" ||
                    statusDriver == "CANCELLED" ||
                    item.statusDriver == "ALL_BUSY_FOR_DRIVER" ||
                    statusDriver == "DRIVER_ACCEPTED" ||
                    statusDriver == "DRIVER_ARRIVED_RECEIVE_POINT" ||
                    statusDriver == "IN_RECIEVE") &&
                item.orderStatus == "PROCESSING") ...[
              SizedBox(height: 8.h),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (statusDriver == "SEARCHING_FOR_DRIVER")
                    Lottie.asset(
                      AssetConstants.gifSearchDriver,
                      width: 16.r,
                      height: 16.r,
                      fit: BoxFit.cover,
                    )
                  else
                    Image.asset(
                      statusDriver == "CANCELLED"
                          ? AssetConstants.icWarning
                          : statusDriver == "ALL_BUSY_FOR_DRIVER"
                          ? AssetConstants.icTimer
                          : statusDriver == "DRIVER_ACCEPTED"
                          ? AssetConstants.icBike
                          : statusDriver == "IN_RECIEVE"
                          ? AssetConstants.icBike
                          : statusDriver == "DRIVER_ARRIVED_RECEIVE_POINT"
                          ? AssetConstants.icBike
                          : AssetConstants.icWarning,

                      color:
                          statusDriver == "CANCELLED"
                              ? null
                              : statusDriver == "ALL_BUSY_FOR_DRIVER"
                              ? AppColors.warningColor
                              : statusDriver == "DRIVER_ACCEPTED"
                              ? AppColors.successColor
                              : statusDriver == "IN_RECIEVE"
                              ? AppColors.successColor
                              : statusDriver == "DRIVER_ARRIVED_RECEIVE_POINT"
                              ? AppColors.successColor
                              : Colors.transparent,
                      width: 16.r,
                      height: 16.r,
                    ),

                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      item.statusDriver == "SEARCHING_FOR_DRIVER"
                          ? "Đang tìm tài xế..."
                          : item.statusDriver == "CANCELLED"
                          ? "Tài xế đã huỷ nhận đơn"
                          : item.statusDriver == "ALL_BUSY_FOR_DRIVER"
                          ? "không tìm thấy tài xế"
                          : item.statusDriver == "DRIVER_ACCEPTED"
                          ? "Tài xế đã nhận đơn"
                          : item.statusDriver == "IN_RECIEVE"
                          ? "Tài xế đã đến cửa hàng"
                          : statusDriver == "DRIVER_ARRIVED_RECEIVE_POINT"
                          ? "Tài xế đang đến cửa hàng"
                          : "",
                      style: AppTextStyles.semibold12().copyWith(
                        color:
                            item.statusDriver == "SEARCHING_FOR_DRIVER"
                                ? AppColors.infomationColor
                                : item.statusDriver == "CANCELLED"
                                ? AppColors.warningColor
                                : item.statusDriver == "ALL_BUSY_FOR_DRIVER"
                                ? AppColors.warningColor
                                : item.statusDriver == "DRIVER_ACCEPTED"
                                ? AppColors.successColor
                                : item.statusDriver == "IN_RECIEVE"
                                ? AppColors.successColor
                                : statusDriver == "DRIVER_ARRIVED_RECEIVE_POINT"
                                ? AppColors.successColor
                                : Colors.transparent,
                        height: 1,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
