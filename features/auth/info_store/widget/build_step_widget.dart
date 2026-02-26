import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/features/auth/info_store/info_store_controller.dart';
import 'package:merchant/features/auth/info_store/widget/step_1_widget.dart';
import 'package:merchant/features/auth/info_store/widget/step_2_widget.dart';
import 'package:merchant/features/auth/info_store/widget/step_3_widget.dart';
import 'package:merchant/features/auth/info_store/widget/step_4_widget.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class BuildStepWidget extends GetView<InfoStoreController> {
  const BuildStepWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        Expanded(child: SingleChildScrollView(child: _buildBody())),
      ],
    );
  }

  Widget _buildHeader() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 17.w,
          children: List.generate(
            StepEnum.values.length,
            (index) => Container(
              width: (Get.width - 120) / 4,
              height: 6.h,
              decoration: BoxDecoration(
                color:
                    StepEnum.values[index].index <= controller.step.value.index
                        ? AppColors.primaryColor
                        : AppColors.grayscaleColor10,
                borderRadius: BorderRadius.circular(360.r),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () => switch (controller.step.value) {
        StepEnum.step1 => Step1Widget(),
        StepEnum.step2 => Step2Widget(),
        StepEnum.step3 => Step3Widget(),
        StepEnum.step4 => Step4Widget(),
      },
    );
  }
}
