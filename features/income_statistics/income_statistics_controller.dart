import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:merchant/domain/data/models/statistical_model.dart';
import 'package:merchant/features/income_statistics/view/date_time_piker_day.dart';
import 'package:merchant/features/income_statistics/view/date_time_piker_month.dart';
import 'package:get/get.dart';
import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class IncomeStatisticsController extends GetxController {
  final ApiClient client = ApiClient();
  final List<String> tabList = ['Ngày', 'Tháng'];
  final RxInt currentIndex = 0.obs;
  final RxList<StatisticalModel> statisticsData = <StatisticalModel>[].obs;
  final totalRevenue = [].obs;
  final rxIMaxRevenue = 0.obs;
  final listData = <StatisticalModel>[].obs;
  final totalRevenueDisplay = 0.obs;
  final canceled = 0.obs;
  final completed = 0.obs;
  final canceledByDriver = 0.obs;
  final total = 0.obs;
  final dateSelected = "".obs;

  late ScrollController scrollController;

  @override
  void onInit() {
    super.onInit();
    scrollController = ScrollController();
    totalRevenue.value = [
      DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd'),
    ];
    fetchDataReimbursement([
      DateUtil.formatDate(DateTime.now(), format: 'yyyy-MM-dd'),
    ]);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  Future<void> fetchDataReimbursement(List<String> date) async {
    EasyLoading.show();
    final filter = [
      {"key": currentIndex.value == 0 ? "days" : "months", "value": date},
    ];
    final filterString = jsonEncode(filter);
    await client
        .fetchDataIncomeStatistics(filter: filterString)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data["resultApi"]["data"] != null) {
            statisticsData.assignAll(
              (response.data["resultApi"]["data"] as List)
                  .map(
                    (e) => StatisticalModel.fromJson(e as Map<String, dynamic>),
                  )
                  .toList(),
            );
            rxIMaxRevenue.value = statisticsData
                .map((e) => e.totalRevenue as int)
                .reduce((a, b) => a > b ? a : b);
            if (totalRevenue.length < 2) {
              listData.assignAll(statisticsData);
              if (listData.isNotEmpty) {
                totalRevenueDisplay.value =
                    listData
                            .where(
                              (e) =>
                                  (e.day == date.last || e.month == date.last),
                            )
                            .firstOrNull
                            ?.totalRevenue
                        as int;

                dateSelected.value = date.last;
              }
            } else {
              listData.assignAll(statisticsData);
              final total = response.data["resultApi"]["total"];
              totalRevenueDisplay.value = int.tryParse(total.toString()) ?? 0;
              dateSelected.value = date.last;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              scrollToSelectedItem(dateSelected.value);
            });
          }
          fetchstatisticOrder(dateSelected.value);
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  onDateSelected(String date) {
    if (dateSelected.value == date) return;
    dateSelected.value = date;
    fetchstatisticOrder(dateSelected.value);

    scrollToSelectedItem(date);
  }

  // Hàm cuộn đến item được chọn
  void scrollToSelectedItem(String selectedDate) {
    if (listData.isEmpty) return;

    int selectedIndex = -1;
    for (int i = 0; i < listData.length; i++) {
      final item = listData[i];
      final itemDate = item.day != null ? item.day ?? '' : item.month ?? '';
      if (itemDate == selectedDate) {
        selectedIndex = i;
        break;
      }
    }

    if (selectedIndex != -1 && scrollController.hasClients) {
      final itemWidth = 90.w;
      final targetOffset = selectedIndex * itemWidth;

      final screenWidth = Get.width;
      final itemCenterOffset =
          targetOffset - (screenWidth / 2) + (itemWidth / 2);

      scrollController.animateTo(
        itemCenterOffset.clamp(0.0, scrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  onSelectTab(int index) {
    if (currentIndex.value != index) {
      currentIndex.value = index;
      totalRevenue.value = [
        DateUtil.formatDate(
          DateTime.now(),
          format: index == 0 ? 'yyyy-MM-dd' : 'yyyy-MM',
        ),
      ];
      fetchDataReimbursement([
        DateUtil.formatDate(
          DateTime.now(),
          format: index == 0 ? 'yyyy-MM-dd' : 'yyyy-MM',
        ),
      ]);
    }
  }

  Future<void> fetchstatisticOrder(String date) async {
    EasyLoading.show();
    final type = currentIndex.value == 0 ? "day" : "month";
    await client
        .fetchStatisticOrder(type: type, date: date)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            final data = response.data["resultApi"];
            canceled.value = data["canceled"];
            completed.value = data["completed"];
            canceledByDriver.value = data["driver_canceled"];
            total.value = data["total"];
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  List<String> formatDateForDisplay(String dateString) {
    try {
      DateTime date;

      if (RegExp(r'^\d{4}-\d{2}$').hasMatch(dateString)) {
        date = DateTime.parse("$dateString-01");
        return ["Tháng ${date.month}", "${date.year}"];
      } else if (RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(dateString)) {
        date = DateTime.parse(dateString);
        return ["Ngày ${date.day}", "Tháng ${date.month}"];
      } else {
        return [dateString];
      }
    } catch (e) {
      return [dateString];
    }
  }

  void showBottomSheetDateTimePikerMonth() {
    Get.bottomSheet(
      currentIndex.value == 0
          ? DateTimePikerDay(
            onConfirm: (date) {
              final listDate =
                  date
                      .map((e) => DateUtil.formatDate(e, format: 'yyyy-MM-dd'))
                      .toList();
              totalRevenue.assignAll(listDate);
              print(totalRevenue);
              fetchDataReimbursement(listDate);
              Get.back();
            },
          )
          : DateTimePikerMonth(
            onConfirm: (months) {
              final listDate =
                  months
                      .map((e) => DateUtil.formatDate(e, format: 'yyyy-MM'))
                      .toList();
              totalRevenue.assignAll(listDate);
              print(totalRevenue);
              fetchDataReimbursement(listDate);
              Get.back();
            },
          ),
      isScrollControlled: true,
    );
  }
}
