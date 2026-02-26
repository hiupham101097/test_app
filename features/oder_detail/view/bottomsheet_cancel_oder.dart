import 'dart:io';

import 'package:merchant/domain/data/models/cancel_model.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BottomSheetCancelOrder extends StatefulWidget {
  final String? selectedValue;
  final List<String> reasons;
  final void Function(String)? onConfirm;

  const BottomSheetCancelOrder({
    super.key,
    this.selectedValue,
    this.onConfirm,
    required this.reasons,
  });

  @override
  State<BottomSheetCancelOrder> createState() => _BottomSheetCancelOrderState();
}

class _BottomSheetCancelOrderState extends State<BottomSheetCancelOrder> {
  String? selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom:
            MediaQuery.of(context).systemGestureInsets.bottom > 32.h &&
                    Platform.isAndroid
                ? 40.h
                : 0.h,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor24,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "cancel_order_reason".tr,
                          style: AppTextStyles.semibold14().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 24.sp,
                          color: AppColors.grayscaleColor60,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Divider(color: AppColors.grayscaleColor10, height: 1.h),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5.h,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          ...widget.reasons.map(
                            (e) => _buildItem(e, selectedValue == e),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: AppButton(
                    title: "confirm".tr,
                    onPressed: () {
                      widget.onConfirm?.call(
                        selectedValue ?? widget.reasons[0],
                      );
                    },
                    isEnable:
                        selectedValue != null && selectedValue!.isNotEmpty,
                  ),
                ),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildItem(String item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedValue = item;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h),

        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked_sharp
                  : Icons.radio_button_unchecked_sharp,
              size: 20.sp,
              color:
                  isSelected
                      ? AppColors.primaryColor
                      : AppColors.grayscaleColor60,
            ),
            SizedBox(width: 12.w),
            Text(item, style: AppTextStyles.regular14()),
          ],
        ),
      ),
    );
  }
}
