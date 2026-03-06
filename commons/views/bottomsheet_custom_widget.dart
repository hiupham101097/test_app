import 'package:merchant/commons/views/custom_empty.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BottomsheetCustomWidget extends StatefulWidget {
  final List<String> dataCustom;
  final String selectedItem;
  final Function(int) onTap;
  final String title;

  const BottomsheetCustomWidget({
    super.key,
    required this.dataCustom,
    required this.onTap,
    required this.selectedItem,
    required this.title,
  });

  @override
  State<BottomsheetCustomWidget> createState() =>
      _BottomsheetCustomWidgetState();
}

class _BottomsheetCustomWidgetState extends State<BottomsheetCustomWidget> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.dataCustom.indexOf(widget.selectedItem);
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
                    final isSelected = selectedIndex == index;
                    return GestureDetector(
                      onTap: () {
                        Get.back();
                        setState(() {
                          selectedIndex = index;
                        });
                        widget.onTap(index);
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
                        child: Text(
                          widget.dataCustom[index],
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
        ],
      ),
    );
  }
}
