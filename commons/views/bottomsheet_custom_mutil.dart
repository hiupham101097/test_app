import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class BottomsheetCustomMutilWidget extends StatefulWidget {
  final List<String> dataCustom;
  final List<String> selectedItem;
  final Function(List<int>) onConfirm;
  final String title;

  const BottomsheetCustomMutilWidget({
    super.key,
    required this.dataCustom,
    required this.onConfirm,
    required this.selectedItem,
    required this.title,
  });

  @override
  State<BottomsheetCustomMutilWidget> createState() =>
      _BottomsheetCustomMutilWidgetState();
}

class _BottomsheetCustomMutilWidgetState
    extends State<BottomsheetCustomMutilWidget> {
  List<int> selectedIndex = [];

  @override
  void initState() {
    super.initState();
    selectedIndex =
        widget.selectedItem
            .map((item) => widget.dataCustom.indexOf(item))
            .where((index) => index != -1)
            .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w).copyWith(
        bottom:
            MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                ? 40.h
                : 20.h,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Header
          Stack(
            children: [
              Align(
                child: Text(
                  widget.title,
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

          SizedBox(height: 8.h),

          /// List item
          widget.dataCustom.isNotEmpty
              ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.6,
                  minHeight: 10.h,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final isSelected = selectedIndex.contains(index);

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedIndex.remove(index);
                          } else {
                            selectedIndex.add(index);
                          }
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.only(bottom: 8.h),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: AppColors.grayscaleColor30,
                              width: 0.5,
                            ),
                          ),
                          color:
                              isSelected ? AppColors.backgroundColor12 : null,
                          borderRadius:
                              isSelected
                                  ? BorderRadius.circular(4.r)
                                  : BorderRadius.circular(0),
                          boxShadow:
                              isSelected
                                  ? [
                                    BoxShadow(
                                      color: AppColors.grayscaleColor20,
                                      blurRadius: 0,
                                      offset: const Offset(0, 1),
                                    ),
                                  ]
                                  : null,
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                widget.dataCustom[index],
                                style: AppTextStyles.regular14().copyWith(
                                  color: AppColors.grayscaleColor80,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => SizedBox(height: 2.h),
                  itemCount: widget.dataCustom.length,
                ),
              )
              : CustomEmpty(
                title: "no_data".tr,
                width: 60.r,
                height: 60.r,
                image: AssetConstants.icEmptyImage,
              ),

          Padding(
            padding: EdgeInsets.only(top: 12.h),
            child: AppButton(
              width: Get.width,
              title: "Xác nhận",
              onPressed: () {
                widget.onConfirm(selectedIndex);
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }
}
