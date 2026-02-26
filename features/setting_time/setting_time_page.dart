import 'package:flutter/cupertino.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/setting_time/enum/enum_time.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'setting_time_controller.dart';

class SettingTimePage extends GetView<SettingTimeController> {
  const SettingTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(
      title: "setting_time".tr,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [_buildDayTime(), _buildTime()]),
            ),
          ),
          _buildButton(),
        ],
      ),
    );
  }

  Widget _buildButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: AppButton(
        title: "save_info".tr,
        // isEnable: controller.hasChanges.value,
        onPressed: () {
          controller.setDateTime();
        },
      ),
    );
  }

  Widget _buildDayTime() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'choose_sale_days'.tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12.h),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children:
                  EnumTime.values.map((day) {
                    return GestureDetector(
                      onTap: () {
                        if (controller.selectDay.contains(day)) {
                          controller.selectDay.remove(day);
                        } else {
                          controller.selectDay.add(day);
                        }
                        // controller.checkHasChanges();
                      },
                      child: Obx(
                        () => Container(
                          height: 76.w,
                          width: 76.w,
                          margin: EdgeInsets.only(
                            right: day == EnumTime.SUNDAY ? 0 : 12.w,
                          ),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color:
                                controller.selectDay.contains(day)
                                    ? AppColors.primaryColor5
                                    : Colors.transparent,
                            border: Border.all(
                              color:
                                  controller.selectDay.contains(day)
                                      ? AppColors.primaryColor
                                      : AppColors.grayscaleColor80,
                            ),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 12.h,
                            children: [
                              Text(
                                day.getNamVi(day),
                                style: AppTextStyles.regular12().copyWith(
                                  color: AppColors.grayscaleColor80,
                                ),
                              ),
                              Icon(
                                controller.selectDay.contains(day)
                                    ? Icons.check_box_outlined
                                    : Icons.check_box_outline_blank,
                                color:
                                    controller.selectDay.contains(day)
                                        ? AppColors.primaryColor
                                        : AppColors.grayscaleColor80,
                                size: 18.r,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTime() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'choose_sale_time'.tr,
              style: AppTextStyles.semibold14().copyWith(
                color: AppColors.grayscaleColor80,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              decoration: BoxDecoration(
                border: Border.all(
                  color: AppColors.grayscaleColor30,
                  width: 0.3,
                ),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 12.h,
                children: [
                  ...List.generate(
                    controller.openTimes.length,
                    (index) => Column(
                      spacing: 12.h,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Khung giờ bán hàng ${index + 1}",
                              style: AppTextStyles.medium12().copyWith(
                                color: AppColors.grayscaleColor80,
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                controller.deleteTime(index);
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    CupertinoIcons.delete,
                                    size: 16.r,
                                    color: AppColors.warningColor,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    "delete".tr,
                                    style: AppTextStyles.medium12().copyWith(
                                      color: AppColors.warningColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Row(
                          spacing: 20.w,
                          children: [
                            _buildTimeItem(
                              controller.openTimes[index].openTime,
                              onTap: () {
                                controller.showTimePicker(
                                  title: 'start_time'.tr,
                                  onTimeSelected: (newTime) {
                                    controller.updateTime(
                                      newTime,
                                      controller.openTimes[index],
                                      'openTime',
                                    );
                                  },
                                );
                              },
                            ),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 18.r,
                              color: AppColors.grayscaleColor60,
                            ),
                            _buildTimeItem(
                              controller.openTimes[index].closeTime,
                              onTap: () {
                                controller.showTimePicker(
                                  title: 'end_time'.tr,
                                  onTimeSelected: (newTimeEnd) {
                                    controller.updateTime(
                                      newTimeEnd,
                                      controller.openTimes[index],
                                      'closeTime',
                                    );
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(
                    color: AppColors.grayscaleColor30,
                    height: 1,
                    thickness: 0.3,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (controller.openTimes.length >= 3) return;
                      controller.addTime();
                    },
                    child: Row(
                      spacing: 4.w,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 18.r,
                          color: AppColors.infomationColor,
                        ),
                        Text(
                          "${'add_time_slot'.tr} (${controller.openTimes.length}/3)",
                          style: AppTextStyles.semibold12().copyWith(
                            color: AppColors.infomationColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeItem(String time, {required Function() onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.grayscaleColor30, width: 1),
            borderRadius: BorderRadius.circular(4.r),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  time,
                  style: AppTextStyles.regular12().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              Icon(
                Icons.access_time_sharp,
                size: 18.r,
                color: AppColors.grayscaleColor80,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
