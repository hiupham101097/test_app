import 'package:merchant/domain/client/api_client.dart';
import 'package:merchant/domain/data/models/open_time_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/features/setting_time/enum/enum_time.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/error_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:bottom_picker/bottom_picker.dart';
import 'package:bottom_picker/resources/arrays.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../../domain/data/models/store_model.dart';

class SettingTimeController extends GetxController {
  final ApiClient client = ApiClient();
  final store = StoreModel().obs;
  final selectDay = <EnumTime>[].obs;
  final openTimes = <OpenTimeModel>[].obs;
  final hasChanges = false.obs;

  @override
  void onInit() {
    super.onInit();
    store.value = StoreDB().currentStore() ?? StoreModel();
    List<String> days = const [];
    try {
      days = store.value.openDays;
    } catch (_) {
      days = const [];
    }
    if (days.isNotEmpty) {
      for (final dayName in days) {
        final match = EnumTime.values.where((e) => e.name == dayName);
        if (match.isNotEmpty) {
          selectDay.add(match.first);
        }
      }
    }
    // Deep copy to avoid mutating the StoreModel's persisted list until Save
    openTimes.value =
        store.value.openTimes
            .map(
              (e) => OpenTimeModel(
                id: e.id,
                openTime: e.openTime,
                closeTime: e.closeTime,
              ),
            )
            .toList();
  }

  void updateTime(String time, OpenTimeModel timeModel, String type) {
    final index = openTimes.indexWhere((e) => e.id == timeModel.id);
    if (index == -1) return;

    final updated =
        type == 'openTime'
            ? OpenTimeModel(
              id: timeModel.id,
              openTime: time,
              closeTime: timeModel.closeTime,
            )
            : OpenTimeModel(
              id: timeModel.id,
              openTime: timeModel.openTime,
              closeTime: time,
            );

    openTimes[index] = updated;
    openTimes.refresh();
    hasChanges.value = true;
  }

  void deleteTime(int index) {
    openTimes.removeAt(index);
    openTimes.refresh();
    hasChanges.value = true;
    setDateTime();
  }

  void addTime() {
    openTimes.add(OpenTimeModel(id: '', openTime: '00:00', closeTime: '00:00'));
    openTimes.refresh();
  }

  Future<void> setDateTime() async {
    EasyLoading.show();
    final data = {
      "openDays": selectDay.map((e) => e.name).toList(),
      "openTimes":
          openTimes
              .map((e) => {"openTime": e.openTime, "closeTime": e.closeTime})
              .toList(),
    };
    await client
        .setDateTime(data: data)
        .then((response) async {
          EasyLoading.dismiss();
          if (response.data["resultApi"] != null) {
            final store = StoreModel.fromJson(response.data["resultApi"]);
            StoreDB().save(store);
            print("store:${response.data["resultApi"]["openDays"]}");
            DialogUtil.showSuccessMessage('update_time_success'.tr);
          }
        })
        .catchError((error, trace) {
          EasyLoading.dismiss();
          ErrorUtil.catchError(error, trace);
        });
  }

  void showTimePicker({
    String? title,
    required Function(String) onTimeSelected,
  }) {
    BottomPicker.time(
      initialTime: Time(hours: 0, minutes: 0),
      buttonStyle: BoxDecoration(
        color: AppColors.primaryColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      pickerTitle: Text(
        title ?? '',
        style: AppTextStyles.medium12().copyWith(
          color: AppColors.grayscaleColor80,
        ),
      ),
      pickerTextStyle: AppTextStyles.medium12().copyWith(
        color: AppColors.grayscaleColor80,
      ),
      backgroundColor: Colors.white,
      buttonContent: Text(
        'confirm'.tr,
        style: AppTextStyles.medium12().copyWith(color: Colors.white),
        textAlign: TextAlign.center,
      ),
      buttonWidth: 100.w,
      titlePadding: EdgeInsets.symmetric(vertical: 12.h),
      bottomPickerTheme: BottomPickerTheme.plumPlate,
      onSubmit: (value) {
        final time =
            value.hour.toString().padLeft(2, '0') +
            ':' +
            value.minute.toString().padLeft(2, '0');
        onTimeSelected(time);
      },
    ).show(Get.context!);
  }

  // void checkHasChanges() {
  //   final selectedDayNames = selectDay.map((e) => e.name).toList();
  //   final storeOpenDays = store.value.openDays;

  //   // Check day changes (order-insensitive)
  //   if (selectedDayNames.length != storeOpenDays.length) {
  //     hasChanges.value = true;
  //     return;
  //   }

  //   selectedDayNames.sort();
  //   storeOpenDays.sort();

  //   for (int i = 0; i < selectedDayNames.length; i++) {
  //     if (selectedDayNames[i] != storeOpenDays[i]) {
  //       hasChanges.value = true;
  //       return;
  //     }
  //   }

  //   // Check time changes (order-insensitive)
  //   final originalStore = StoreDB().currentStore() ?? StoreModel();
  //   final currentTimes = store.value.openTimes;
  //   final originalTimes = originalStore.openTimes;

  //   if (currentTimes.length != originalTimes.length) {
  //     hasChanges.value = true;
  //     return;
  //   }

  //   final normalize = (String open, String close) => (open + '-' + close);

  //   final currentNormalized =
  //       currentTimes.map((e) => normalize(e.openTime, e.closeTime)).toList()
  //         ..sort();
  //   final originalNormalized =
  //       originalTimes.map((e) => normalize(e.openTime, e.closeTime)).toList()
  //         ..sort();

  //   for (int i = 0; i < currentNormalized.length; i++) {
  //     if (currentNormalized[i] != originalNormalized[i]) {
  //       hasChanges.value = true;
  //       return;
  //     }
  //   }

  //   hasChanges.value = false;
  // }
}
