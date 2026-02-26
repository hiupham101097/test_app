import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/confirm_order/confirm_order_controller.dart';
import 'package:merchant/features/confirm_order/view/list_product_widget.dart';
import 'package:merchant/features/oder_detail/view/header_widget.dart';
import 'package:merchant/features/oder_detail/view/info_customer_widget.dart';
import 'package:merchant/features/oder_detail/view/pay_widget.dart';
import 'package:merchant/features/oder_detail/view/sumary_oder.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class ConfirmOrderPage extends GetView<ConfirmOrderController> {
  const ConfirmOrderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(title: "Xác nhận đơn hàng", child: _buildBody());
  }

  _buildBody() {
    return Obx(
      () =>
          controller.isLoading.value
              ? SizedBox.shrink()
              : controller.orderData.isEmpty
              ? Center(child: CustomEmpty(title: "Không còn đơn hàng"))
              : Padding(
                padding: EdgeInsets.symmetric(vertical: 12.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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

  _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Obx(
        () => Column(
          spacing: 8.h,
          children: [
            if (controller.oderDetail.value.orderStatus == "PENDING")
              AppButton(
                title: "XÁC NHẬN ĐƠN HÀNG",
                onPressed: () {
                  controller.confirmOder(
                    "PREPARING",
                    controller.oderDetail.value.orderId,
                    controller.oderDetail.value.userId,
                  );
                },
              ),
            if (controller.oderDetail.value.orderStatus == "PENDING")
              AppButton(
                title: "Hủy đơn",
                onPressed: () {
                  controller.showBottomSheetCancelOrder();
                },
                type: AppButtonType.nomal,
              ),
          ],
        ),
      ),
    );
  }
}
