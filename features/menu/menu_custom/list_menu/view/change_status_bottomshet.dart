import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class ChangeStatusBottomsheet extends StatefulWidget {
  final Function(bool) onTap;

  const ChangeStatusBottomsheet({super.key, required this.onTap});

  @override
  State<ChangeStatusBottomsheet> createState() =>
      _ChangeStatusBottomsheetState();
}

class _ChangeStatusBottomsheetState extends State<ChangeStatusBottomsheet> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16.h).copyWith(
        bottom:
            MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                ? 40.h
                : 20.h,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Stack(
              children: [
                Align(
                  child: Text(
                    "change_status".tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semibold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  top: 0,
                  child: GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(
                      Icons.close,
                      color: AppColors.grayscaleColor80,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.6,
              minHeight: 10.h,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(2, (index) => _buildItem(index)),
            ),
          ),
          SizedBox(height: 12.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: AppButton(
              title: "Xác nhận",
              onPressed: () {
                widget.onTap(selectedIndex == 0);
              },
            ),
          ),
          SizedBox(height: 8.h),
        ],
      ),
    );
  }

  Widget _buildItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
        decoration: BoxDecoration(
          color:
              selectedIndex == index
                  ? AppColors.primaryColor10
                  : AppColors.backgroundColor24,

          border:
              index == 0
                  ? Border(
                    bottom: BorderSide(
                      color: AppColors.grayscaleColor10,
                      width: 1.w,
                    ),
                  )
                  : null,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color:
                        index == 0
                            ? AppColors.primaryColor
                            : AppColors.grayscaleColor80,
                    borderRadius: BorderRadius.circular(260.r),
                  ),
                ),
                SizedBox(width: 8.w),
                Text(
                  index == 0 ? "Hiển thị" : "Tạm tắt",
                  style: AppTextStyles.semibold14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(left: 14.w),
              child: Text(
                index == 0
                    ? "Món ăn sẽ được hiển thị trên ứng dụng của khách hàng. Khách hàng có thể đặt được món"
                    : "Món ăn sẽ không được hiển thị trên ứng dụng của khách hàng",
                style: AppTextStyles.regular12().copyWith(
                  color: AppColors.grayscaleColor40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
