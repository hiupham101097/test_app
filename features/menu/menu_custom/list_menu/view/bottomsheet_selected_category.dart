import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/domain/data/models/category_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BottomsheetSelectedCategory extends StatefulWidget {
  final List<CategoryModel> dataCustom;
  final List<CategoryModel> selectedItem;
  final Function(List<CategoryModel>) onTap;
  final Function() onCancel;
  final String title;

  const BottomsheetSelectedCategory({
    super.key,
    required this.dataCustom,
    required this.onTap,
    required this.selectedItem,
    required this.title,
    required this.onCancel,
  });

  @override
  State<BottomsheetSelectedCategory> createState() =>
      _BottomsheetSelectedCategoryState();
}

class _BottomsheetSelectedCategoryState
    extends State<BottomsheetSelectedCategory> {
  List<CategoryModel> selectedCategory = [];

  @override
  void initState() {
    super.initState();
    selectedCategory = List.from(widget.selectedItem);
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
          SizedBox(height: 12.h),

          widget.dataCustom.isNotEmpty
              ? ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: Get.height * 0.6,
                  minHeight: 10.h,
                ),
                child: ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final currentItem = widget.dataCustom[index];
                    final isSelected = selectedCategory.any(
                      (item) => item.id == currentItem.id,
                    );
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          if (isSelected) {
                            selectedCategory.removeWhere(
                              (item) => item.id == currentItem.id,
                            );
                          } else {
                            selectedCategory.add(currentItem);
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
                          border:
                              index == widget.dataCustom.length - 1
                                  ? null
                                  : Border(
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
                        child: Text(
                          widget.dataCustom[index].name ?? "",
                          style: AppTextStyles.regular14().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => SizedBox(height: 2.h),
                  itemCount: widget.dataCustom.length,
                ),
              )
              : CustomEmpty(
                title: "no_data".tr,
                width: 60.r,
                height: 60.r,
                image: AssetConstants.icEmptyImage,
              ),

          Row(
            spacing: 12.w,
            children: [
              Expanded(
                child: AppButton(
                  title: "cancel".tr,
                  type: AppButtonType.nomal,
                  onPressed: () {
                    selectedCategory.clear();
                    widget.onCancel();
                    Get.back();
                    setState(() {});
                  },
                ),
              ),
              Expanded(
                child: AppButton(
                  title: "confirm".tr,
                  onPressed: () {
                    widget.onTap(selectedCategory);
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
