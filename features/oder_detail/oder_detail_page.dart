import 'package:flutter/material.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/oder_detail/view/find_driver.dart';
import 'package:merchant/features/oder_detail/view/info_driver.dart';
import 'package:merchant/features/oder_detail/view/no_find_driver.dart';
import 'package:merchant/features/oder_detail/view/status_cancel.dart';
import 'package:merchant/features/oder_detail/view/success_oder.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/features/oder_detail/view/header_widget.dart';
import 'package:merchant/features/oder_detail/view/info_customer_widget.dart';
import 'package:merchant/features/oder_detail/view/list_product_widget.dart';
import 'package:merchant/features/oder_detail/view/pay_widget.dart';
import 'package:merchant/features/oder_detail/view/sumary_oder.dart';
import 'oder_detail_controller.dart';

class OrderDetailPage extends GetView<OrderDetailController> {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(title: "Chi tiết đơn hàng", child: _buildBody());
  }

  _buildBody() {
    return Obx(
      () =>
          controller.isLoading.value || controller.isLoadingSocket.value
              ? SizedBox.shrink()
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildUiStatusOrder(),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            HeaderWidget(
                              oderDetail: controller.oderDetail.value,
                            ),
                            ListProductWidget(),
                            InfoCustomerWidget(
                              oderDetail: controller.oderDetail.value,
                            ),
                            SumaryOrder(
                              oderDetail: controller.oderDetail.value,
                            ),
                            PayWidget(oderDetail: controller.oderDetail.value),
                            _buildButton(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }

  Widget _buildUiStatusOrder() {
    return Obx(() {
      final orderStatus = controller.oderDetail.value.orderStatus;
      print("orderStatus: $orderStatus");
      print("statusFindDriver: ${controller.statusFindDriver.value}");
      switch (orderStatus) {
        case 'PREPARING':
          return Container();
        case 'PROCESSING':
          switch (controller.statusFindDriver.value) {
            case 'SEARCHING_FOR_DRIVER':
              return FindDriver(
                onTap: () {
                  controller.showBottomSheetCancelOrder(() {
                    controller.cancelFindDriver();
                  });
                },
              );
            case 'ALL_BUSY_FOR_DRIVER':
              return NoFindDriver();
            case 'DRIVER_ACCEPTED':
            case 'DRIVER_ARRIVED_RECEIVE_POINT':
            case 'DRIVER_GOING_TO_SEND_POINT':
            case 'DELIVERED':
            case 'DRIVER_GOING_TO_REFUND_POINT':
            case 'DRIVER_ARRIVED_REFUND_POINT':
            case 'DRIVER_COMPLETED_REFUND_POINT':
            case 'IN_DELIVERY':
            case 'IN_RECIEVE':
            case 'IN_REFIUND':
            case 'REFUNDED':
              return _infoDriver();
            case 'CANCELLED':
              return _buildDriverCancel();
            default:
              return Container();
          }
        case 'DELIVERING':
          return _infoDriver();
        case 'DRIVER_CANCELED':
          return StatusCancel(
            fromType:
                controller.oderDetail.value.orderStatusHistory?.fromType ?? '',
            createDate:
                controller.oderDetail.value.orderStatusHistory?.createDate ??
                '',
            reasonCancel:
                controller.oderDetail.value.orderStatusHistory?.reasonCancel ??
                '',
          );

        case 'COMPLETED':
          return SuccessOder(
            avatar: controller.oderDetail.value.driverInfo?.avatar ?? '',
            driverName: controller.oderDetail.value.driverInfo?.name ?? '',
            vehiclePlate:
                controller.oderDetail.value.driverInfo?.driverId ?? '',
            vehicleBrand: controller.oderDetail.value.driverInfo?.vehicle ?? '',
            driverRate: controller.oderDetail.value.driverInfo?.rating ?? 0,
            phone: controller.oderDetail.value.driverInfo?.phone ?? '',
          );
        case 'CANCELED':
        case 'FAILED':
          return StatusCancel(
            fromType:
                controller.oderDetail.value.orderStatusHistory?.fromType ?? '',
            createDate:
                controller.oderDetail.value.orderStatusHistory?.createDate ??
                '',
            reasonCancel:
                controller.oderDetail.value.orderStatusHistory?.reasonCancel ??
                '',
          );
        default:
          return Container();
      }
    });
  }

  Widget _buildDriverCancel() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 12.w).copyWith(bottom: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.warningColor10,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Đơn hàng đã bị hủy",
            style: AppTextStyles.semibold12().copyWith(
              color: AppColors.warningColor,
            ),
          ),
          Text(
            "Đơn hàng đã bị hủy bởi tài xế",
            style: AppTextStyles.regular12().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoDriver() {
    return Obx(() {
      final nextPoint = controller.nextPoint.value;
      final driver = controller.driver.value;
      final driverName =
          nextPoint.driverName ?? driver.name ?? "Đang cập nhật...";
      final driverRate = nextPoint.driverRating ?? 4.8;

      final vehicleBrand = nextPoint.vehicleBrand ?? "Đang cập nhật...";
      final avatar = nextPoint.avatar;
      final vehiclePlate = nextPoint.vehiclePlate ?? "Đang cập nhật...";
      final phone = nextPoint.driverPhone ?? driver.phone ?? "Đang cập nhật...";

      return InfoDriver(
        avatar: avatar ?? '',
        driverName: driverName,
        driverRate: driverRate,
        vehiclePlate: vehiclePlate,
        vehicleBrand: vehicleBrand,
        status: controller.statusFindDriver.value,
        phone: phone,
      );
    });
  }

  _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Obx(() {
        final transportOrder = controller.statusFindDriver.value;
        final orderStatus = controller.oderDetail.value.orderStatus;

        return Column(
          spacing: 8.h,
          children: [
            if (orderStatus == "PENDING")
              AppButton(
                type: AppButtonType.outline,
                title: "Xác nhận đơn",
                onPressed: () {
                  controller.confirmOder("PREPARING");
                },
              ),
            if ((orderStatus == "PREPARING" || orderStatus == "PROCESSING") &&
                (transportOrder == 'PENDING' ||
                    transportOrder == 'ALL_BUSY_FOR_DRIVER' ||
                    transportOrder == 'CANCELLED'))
              AppButton(
                title: controller.getTitleFindDriver(transportOrder),
                onPressed: () {
                  if ((transportOrder == "PENDING" ||
                      transportOrder == "ALL_BUSY_FOR_DRIVER" ||
                      transportOrder == "CANCELLED")) {
                    controller.findDriverForOrder(
                      controller.oderDetail.value.transportOrderId,
                    );
                  }
                },
                type: AppButtonType.outline,
              ),
            if (orderStatus == "PREPARING" ||
                orderStatus == "PROCESSING" ||
                orderStatus == "PENDING")
              AppButton(
                title: "Hủy đơn",
                onPressed: () {
                  controller.showBottomSheetCancelOrder(() {
                    controller.cancelOder(reason: controller.reason.value);
                  });
                },
                type: AppButtonType.nomal,
              ),
          ],
        );
      }),
    );
  }
}
