import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class DateTimePikerMonth extends StatefulWidget {
  final String? selectedValue;
  final void Function(List<DateTime> selectedMonth)? onConfirm;

  const DateTimePikerMonth({super.key, this.selectedValue, this.onConfirm});

  @override
  State<DateTimePikerMonth> createState() => _DateTimePikerMonthState();
}

class _DateTimePikerMonthState extends State<DateTimePikerMonth> {
  final Set<int> selectedMonthIndexes = <int>{};
  int currentYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
  }

  void _previousYear() {
    setState(() {
      currentYear--;
      selectedMonthIndexes.clear();
    });
  }

  void _nextYear() {
    // Prevent navigating beyond the current year
    if (currentYear < DateTime.now().year) {
      setState(() {
        currentYear++;
        selectedMonthIndexes.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int currentMonthIndex = now.month - 1; // 0-based index
    final monthNames = [
      'january'.tr,
      'february'.tr,
      'march'.tr,
      'april'.tr,
      'may'.tr,
      'june'.tr,
      'july'.tr,
      'august'.tr,
      'september'.tr,
      'october'.tr,
      'november'.tr,
      'december'.tr,
    ];

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor24,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            GestureDetector(
                              onTap: _previousYear,
                              child: Icon(
                                Icons.chevron_left,
                                size: 24,
                                color: AppColors.grayscaleColor60,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "$currentYear",
                              style: AppTextStyles.semibold14().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: currentYear < now.year ? _nextYear : null,
                              child: Icon(
                                Icons.chevron_right,
                                size: 24,
                                color:
                                    currentYear < now.year
                                        ? AppColors.grayscaleColor60
                                        : AppColors.grayscaleColor30,
                              ),
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
                          size: 24,
                          color: AppColors.grayscaleColor60,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
                Divider(color: AppColors.grayscaleColor10, height: 1),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.4,
                    ),
                    child: Wrap(
                      spacing: 12.w,
                      runSpacing: 12.h,
                      children: List.generate(12, (index) {
                        final bool isFutureMonth =
                            (currentYear > now.year) ||
                            (currentYear == now.year &&
                                index > currentMonthIndex);
                        return _buildMonthItem(
                          index,
                          monthNames[index],
                          selectedMonthIndexes.contains(index),
                          isFutureMonth,
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    spacing: 12.w,
                    children: [
                      Expanded(
                        child: AppButton(
                          title: "back".tr,
                          type: AppButtonType.nomal,
                          onPressed: () {
                            Get.back();
                          },
                        ),
                      ),
                      Expanded(
                        child: AppButton(
                          title: "confirm".tr,
                          onPressed: () {
                            if (selectedMonthIndexes.isNotEmpty) {
                              final List<DateTime> months =
                                  selectedMonthIndexes
                                      .map(
                                        (i) => DateTime(currentYear, i + 1, 1),
                                      )
                                      .toList()
                                    ..sort((a, b) => a.compareTo(b));
                              widget.onConfirm?.call(months);
                            }
                          },
                          isEnable: selectedMonthIndexes.isNotEmpty,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthItem(
    int index,
    String monthName,
    bool isSelected,
    bool isDisabled,
  ) {
    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () {
                setState(() {
                  if (selectedMonthIndexes.contains(index)) {
                    selectedMonthIndexes.remove(index);
                  } else {
                    selectedMonthIndexes.add(index);
                  }
                });
              },
      child: Container(
        width: (Get.width - 60.w) / 3,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color:
                isDisabled
                    ? AppColors.grayscaleColor20
                    : isSelected
                    ? AppColors.primaryColor
                    : AppColors.grayscaleColor30,
            width: 1.r,
          ),
          color:
              isDisabled
                  ? Colors.transparent
                  : isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          monthName,
          style: AppTextStyles.regular12().copyWith(
            color:
                isDisabled
                    ? AppColors.grayscaleColor40
                    : isSelected
                    ? AppColors.primaryColor
                    : AppColors.grayscaleColor80,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
