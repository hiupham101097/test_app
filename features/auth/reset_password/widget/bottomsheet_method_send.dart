import 'dart:io';

import 'package:merchant/commons/types/method_enum.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BottomSheetMethodSend extends StatefulWidget {
  MethodEnum? selectedMethod;
  Function(MethodEnum) onTap;
  BottomSheetMethodSend({
    super.key,
    required this.onTap,
    required this.selectedMethod,
  });

  @override
  State<BottomSheetMethodSend> createState() => _BottomSheetMethodSendState();
}

class _BottomSheetMethodSendState extends State<BottomSheetMethodSend> {
  MethodEnum? selectedMethod;
  @override
  void initState() {
    super.initState();
    selectedMethod = widget.selectedMethod;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16.h).copyWith(
            bottom:
                MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                    ? 40.h
                    : 20.h,
          ),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Mã OTP".tr,
                            style: AppTextStyles.semibold14().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Text(
                            "Bạn muốn chúng tôi gửi mã OTP cho bạn qua".tr,
                            style: AppTextStyles.regular14().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
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
                    maxHeight: MediaQuery.of(context).size.height * 0.6.h,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      spacing: 12.h,
                      children: [
                        ...MethodEnum.values.map(
                          (e) => _buildItem(e, selectedMethod == e),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
            ],
          ),
        ),
      ],
    );
  }

  _buildItem(MethodEnum item, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedMethod = item;
        });
        widget.onTap(item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 18.w),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : AppColors.backgroundColor24,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor80
                    : AppColors.grayscaleColor20,
            width: 1.r,
          ),
        ),

        child: Row(
          children: [
            Image.asset(item.getIcon(), width: 40.r, height: 40.r),
            SizedBox(width: 20.w),
            Text(
              item.getLabel(),
              style: AppTextStyles.medium14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
