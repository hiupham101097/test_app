import 'dart:io';

import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_easy_refresh.dart';
import 'package:merchant/domain/data/models/bank_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BottomsheetBank extends StatefulWidget {
  final List<BankModel> dataCustom;
  final BankModel selectedItem;
  final Function(BankModel) onTap;
  final String title;
  final EasyRefreshController controller;
  final Future<void> Function() onRefresh;
  final Future<void> Function() onLoading;
  final int total;
  const BottomsheetBank({
    super.key,
    required this.dataCustom,
    required this.onTap,
    required this.selectedItem,
    required this.title,
    required this.controller,
    required this.onRefresh,
    required this.onLoading,
    required this.total,
  });

  @override
  State<BottomsheetBank> createState() => _BottomsheetBankState();
}

class _BottomsheetBankState extends State<BottomsheetBank> {
  BankModel selectedIndex = BankModel();

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.selectedItem;
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
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semibold16().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Get.back(),
                icon: Icon(
                  Icons.close,
                  color: AppColors.grayscaleColor80,
                  size: 18.sp,
                ),
              ),
            ],
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: Get.height * 0.7,
              minHeight: 10.h,
            ),
            child: CustomEasyRefresh(
              controller: widget.controller,
              onRefresh: widget.onRefresh,
              onLoading: widget.onLoading,

              // infoText: '${widget.dataCustom.length}/ ${widget.total}',
              delegate: SliverChildBuilderDelegate((context, index) {
                final bankItem = widget.dataCustom[index];
                final isSelected = selectedIndex.bankId == bankItem.bankId;
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    setState(() {
                      selectedIndex = bankItem;
                    });
                    widget.onTap(bankItem);
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 8.h),
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: AppColors.grayscaleColor30,
                          width: 0.5,
                        ),
                      ),
                      color: isSelected ? AppColors.backgroundColor12 : null,
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
                        ClipRRect(
                          borderRadius: BorderRadius.circular(360.r),
                          child: CachedImage(
                            url: bankItem.imagePath ?? '',
                            width: 36.w,
                            height: 36.w,
                            fit: BoxFit.contain,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            bankItem.bankName ?? '',
                            style: AppTextStyles.regular12().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }, childCount: widget.dataCustom.length),
            ),
          ),
        ],
      ),
    );
  }
}
