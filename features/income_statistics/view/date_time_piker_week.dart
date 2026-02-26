import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class DateTimePikerWeek extends StatefulWidget {
  final String? selectedValue;
  final void Function(DateTime startDate, DateTime endDate)? onConfirm;

  const DateTimePikerWeek({super.key, this.selectedValue, this.onConfirm});

  @override
  State<DateTimePikerWeek> createState() => _DateTimePikerWeekState();
}

class _DateTimePikerWeekState extends State<DateTimePikerWeek> {
  int? selectedWeekIndex;
  DateTime currentDate = DateTime.now();

  @override
  void initState() {
    super.initState();
  }

  void _previousMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
    });
  }

  List<Map<String, DateTime>> _getWeeksInMonth() {
    List<Map<String, DateTime>> weeks = [];

    DateTime firstDay = DateTime(currentDate.year, currentDate.month, 1);
    DateTime lastDay = DateTime(currentDate.year, currentDate.month + 1, 0);

    DateTime currentWeekStart = firstDay;
    if (firstDay.weekday != DateTime.monday) {
      currentWeekStart = firstDay.subtract(
        Duration(days: firstDay.weekday - 1),
      );
    }

    // Generate weeks
    while (currentWeekStart.isBefore(lastDay) ||
        currentWeekStart.isAtSameMomentAs(lastDay) ||
        currentWeekStart.month == currentDate.month) {
      DateTime weekEnd = currentWeekStart.add(Duration(days: 6));

      if (currentWeekStart.month == currentDate.month ||
          weekEnd.month == currentDate.month ||
          (currentWeekStart.isBefore(firstDay) && weekEnd.isAfter(firstDay))) {
        weeks.add({'start': currentWeekStart, 'end': weekEnd});
      }

      currentWeekStart = currentWeekStart.add(Duration(days: 7));
    }

    return weeks;
  }

  String _formatWeekRange(DateTime start, DateTime end) {
    String startDay = start.day.toString().padLeft(2, '0');
    String endDay = end.day.toString().padLeft(2, '0');
    return "$startDay - $endDay";
  }

  @override
  Widget build(BuildContext context) {
    final weeksInMonth = _getWeeksInMonth();

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
                              "Tháng ${currentDate.month.toString().padLeft(2, '0')}/${currentDate.year}",
                              style: AppTextStyles.semibold14().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            SizedBox(width: 12),
                            GestureDetector(
                              onTap: _nextMonth,
                              child: Icon(
                                Icons.chevron_right,
                                size: 24,
                                color: AppColors.grayscaleColor60,
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
                      children: List.generate(
                        weeksInMonth.length,
                        (index) => _buildWeekItem(
                          index,
                          weeksInMonth[index]['start']!,
                          weeksInMonth[index]['end']!,
                          selectedWeekIndex == index,
                        ),
                      ),
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
                            if (selectedWeekIndex != null) {
                              final selectedWeek =
                                  weeksInMonth[selectedWeekIndex!];
                              widget.onConfirm?.call(
                                selectedWeek['start']!,
                                selectedWeek['end']!,
                              );
                            }
                          },
                          isEnable: selectedWeekIndex != null,
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

  Widget _buildWeekItem(
    int index,
    DateTime startDate,
    DateTime endDate,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedWeekIndex = index;
        });
      },
      child: Container(
        width: (Get.width - 60.w) / 3,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          border: Border.all(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : AppColors.grayscaleColor30,
            width: 1.r,
          ),
          color:
              isSelected
                  ? AppColors.primaryColor.withOpacity(0.1)
                  : Colors.transparent,
        ),
        alignment: Alignment.center,
        child: Text(
          _formatWeekRange(startDate, endDate),
          style: AppTextStyles.regular12().copyWith(
            color:
                isSelected
                    ? AppColors.primaryColor
                    : AppColors.grayscaleColor80,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
