import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:get/utils.dart';

enum StatusOrderEnum {
  PENDING, //đang chờ xác nhận
  PREPARING, // đang soạn hàng
  PROCESSING, // đang tìm tài xế
  DELIVERING, // đang giao hàng
  COMPLETED, // hoàn thành
  FAILED; // thất bại

  String getLabel() {
    switch (this) {
      case StatusOrderEnum.PENDING:
        return 'Chờ xác nhận'.tr;
      case StatusOrderEnum.PREPARING:
        return 'Đang chuẩn bị món'.tr;
      case StatusOrderEnum.DELIVERING:
        return 'Đang giao hàng'.tr;
      case StatusOrderEnum.COMPLETED:
        return 'Hoàn thành'.tr;
      case StatusOrderEnum.FAILED:
        return 'Đã huỷ'.tr;
      case StatusOrderEnum.PROCESSING:
        return 'Đang xử lý'.tr;
    }
  }

  Color getColor() {
    switch (this) {
      case StatusOrderEnum.PENDING:
        return AppColors.grayscaleColor50;
      case StatusOrderEnum.PREPARING:
        return AppColors.infomationColor;
      case StatusOrderEnum.DELIVERING:
        return Colors.deepOrange;
      case StatusOrderEnum.COMPLETED:
        return AppColors.successColor;
      case StatusOrderEnum.FAILED:
        return AppColors.warningColor;
      case StatusOrderEnum.PROCESSING:
        return Colors.indigo;
    }
  }
}

enum StatusRefundEnum {
  refund_pending,
  pending,
  result;

  String getLabel() {
    switch (this) {
      case StatusRefundEnum.refund_pending:
        return 'Đơn mới'.tr;
      case StatusRefundEnum.pending:
        return 'Đã gửi'.tr;
      case StatusRefundEnum.result:
        return 'Kết quả'.tr;
    }
  }
}

enum StatusComplaintEnum {
  PENDING,
  APPROVED,
  REJECTED;

  String getLabel() {
    switch (this) {
      case StatusComplaintEnum.PENDING:
        return 'Đơn mới'.tr;
      case StatusComplaintEnum.APPROVED:
        return 'Hoàn tiền'.tr;
      case StatusComplaintEnum.REJECTED:
        return 'Từ chối'.tr;
    }
  }
}
