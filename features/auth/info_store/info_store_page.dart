import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/auth/info_store/widget/build_step_widget.dart';
import 'package:merchant/features/auth/info_store/widget/intro_widget.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'info_store_controller.dart';

class InfoStorePage extends GetView<InfoStoreController> {
  const InfoStorePage({super.key});

  @override
  Widget build(BuildContext context) {
    print(controller.store.value.status.toUpperCase());
    return Obx(
      () => GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: CustomScreen(
          isBack: controller.registerCondition.value != RegisterCondition.intro,
          onBackPress: () {
            controller.onBackPress();
          },
          resizeToAvoidBottomInset: false,
          title: controller.getStepTitle(),
          child: Column(
            children: [
              Expanded(child: _buildBody()),
              controller.store.value.status.toUpperCase() == 'PENDING'
                  ? SizedBox.shrink()
                  : _buildBottom(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    return Obx(
      () =>
          controller.registerCondition.value == RegisterCondition.intro
              ? IntroWidget()
              : BuildStepWidget(),
    );
  }

  Widget _buildBottom() {
    return Obx(
      () => Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 16.h),
        child: AppButton(
          title: controller.gettitleButton(),
          onPressed: () {
            controller.onAction();
          },
          isEnable:
              controller.registerCondition.value == RegisterCondition.intro
                  ? true
                  : controller.validate.value,
        ),
      ),
    );
  }
}
