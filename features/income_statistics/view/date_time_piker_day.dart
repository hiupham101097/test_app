import 'dart:io';

import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class DateTimePikerDay extends StatefulWidget {
  final String? selectedValue;
  final void Function(List<DateTime> selectedDate)? onConfirm;

  const DateTimePikerDay({super.key, this.selectedValue, this.onConfirm});

  @override
  State<DateTimePikerDay> createState() => _DateTimePikerDayState();
}

class _DateTimePikerDayState extends State<DateTimePikerDay> {
  final Set<DateTime> selectedDates = <DateTime>{};
  DateTime currentDate = DateTime.now();
  late DateTime firstDayOfMonth;
  late DateTime lastDayOfMonth;

  @override
  void initState() {
    super.initState();
    _updateMonthData();
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  DateTime _normalizeDay(DateTime day) =>
      DateTime(day.year, day.month, day.day);

  void _updateMonthData() {
    firstDayOfMonth = DateTime(currentDate.year, currentDate.month, 1);
    lastDayOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);
  }

  void _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
      _updateMonthData();
    });
  }

  void _nextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
      _updateMonthData();
    });
  }

  List<DateTime?> _getDaysInMonth() {
    List<DateTime?> days = [];

    int firstDayWeekday = firstDayOfMonth.weekday;
    for (int i = 1; i < firstDayWeekday; i++) {
      days.add(null);
    }

    for (int day = 1; day <= lastDayOfMonth.day; day++) {
      days.add(DateTime(currentDate.year, currentDate.month, day));
    }

    return days;
  }

  @override
  Widget build(BuildContext context) {
    final daysInMonth = _getDaysInMonth();
    final DateTime now = DateTime.now();
    final bool isAtCurrentMonth =
        currentDate.year == now.year && currentDate.month == now.month;
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
                              onTap: _previousMonth,
                              child: Icon(
                                Icons.chevron_left,
                                size: 24,
                                color: AppColors.grayscaleColor60,
                              ),
                            ),
                            SizedBox(width: 12),
                            Text(
                              "${monthNames[currentDate.month - 1]} ${currentDate.year}",
                              style: AppTextStyles.semibold14().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: isAtCurrentMonth ? null : _nextMonth,
                              child: Icon(
                                Icons.chevron_right,
                                size: 24,
                                color:
                                    isAtCurrentMonth
                                        ? AppColors.grayscaleColor30
                                        : AppColors.grayscaleColor60,
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
                  child: Column(
                    children: [
                      // Weekday headers
                      Row(
                        children:
                            [
                              't2'.tr,
                              't3'.tr,
                              't4'.tr,
                              't5'.tr,
                              't6'.tr,
                              't7'.tr,
                              'cn'.tr,
                            ].map((day) {
                              return Expanded(
                                child: Container(
                                  height: 32.h,
                                  alignment: Alignment.center,
                                  child: Text(
                                    day,
                                    style: AppTextStyles.regular12().copyWith(
                                      color: AppColors.grayscaleColor60,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                      SizedBox(height: 8),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 7,
                          childAspectRatio: 1,
                          crossAxisSpacing: 4.w,
                          mainAxisSpacing: 4.h,
                        ),
                        itemCount: daysInMonth.length,
                        itemBuilder: (context, index) {
                          final day = daysInMonth[index];
                          if (day == null) {
                            return Container();
                          }

                          final isSelected = selectedDates.any(
                            (d) => _isSameDay(d, day),
                          );

                          final isToday =
                              DateTime.now().year == day.year &&
                              DateTime.now().month == day.month &&
                              DateTime.now().day == day.day;

                          final bool isFutureDay =
                              (day.year > now.year) ||
                              (day.year == now.year && day.month > now.month) ||
                              (day.year == now.year &&
                                  day.month == now.month &&
                                  day.day > now.day);

                          return _buildDayItem(
                            day,
                            isSelected,
                            isToday,
                            isFutureDay,
                          );
                        },
                      ),
                    ],
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
                            if (selectedDates.isNotEmpty) {
                              widget.onConfirm?.call(selectedDates.toList());
                            }
                          },
                          isEnable: selectedDates.isNotEmpty,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height:
                      MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                          ? 40.h
                          : 20.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayItem(
    DateTime day,
    bool isSelected,
    bool isToday,
    bool isDisabled,
  ) {
    return GestureDetector(
      onTap:
          isDisabled
              ? null
              : () {
                setState(() {
                  final normalized = _normalizeDay(day);
                  final existing = selectedDates.firstWhere(
                    (d) => _isSameDay(d, normalized),
                    orElse: () => DateTime(0),
                  );

                  if (existing.year != 0) {
                    selectedDates.removeWhere((d) => _isSameDay(d, normalized));
                  } else {
                    selectedDates.add(normalized);
                  }
                });
              },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(360.r),
          color:
              isDisabled
                  ? Colors.transparent
                  : isSelected
                  ? AppColors.primaryColor30
                  : isToday
                  ? AppColors.primaryColor10
                  : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          "${day.day}",
          style: AppTextStyles.regular14().copyWith(
            color:
                isDisabled
                    ? AppColors.grayscaleColor40
                    : AppColors.grayscaleColor80,
            fontWeight: isToday ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
