import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/commons/views/custom_dropdown.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'add_bank_controller.dart';

class AddBankPage extends GetView<AddBankController> {
  const AddBankPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: CustomScreen(
        title: 'add_bank_title'.tr,
        resizeToAvoidBottomInset: false,
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        children: [
          Expanded(
            child: Form(
              key: controller.formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                spacing: 24.h,
                children: [
                  Text(
                    "bank_info".tr,
                    style: AppTextStyles.semibold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Obx(
                    () => CustomDropdown<String>(
                      title: 'bank_name'.tr,
                      hintText: 'select_bank'.tr,
                      value: controller.selectedBank.value?.bankName,
                      items:
                          controller.bankList
                              .map((e) => e.bankName ?? '')
                              .toList(),
                      onChanged: (value) {
                        controller.selectedBank.value = controller.bankList
                            .firstWhere((e) => e.bankName == value);
                      },
                      isRequired: true,
                      onTap: () {
                        controller.showBottomSheetBank();
                      },
                      validator: Validator.formValidation,
                    ),
                  ),
                  TitleDefaultTextField(
                    title: 'bank_branch'.tr,
                    focusNode: controller.branchFocusNode,
                    controller: controller.branchController,
                    hintText: 'enter_bank_branch'.tr,
                  ),
                  TitleDefaultTextField(
                    title: 'account_number'.tr,
                    focusNode: controller.numberAccountFocusNode,
                    controller: controller.numberAccountController,
                    hintText: 'enter_account_number'.tr,
                    textInputType: TextInputType.number,
                    validator: Validator.formValidation,
                    required: true,
                  ),
                  TitleDefaultTextField(
                    title: 'account_holder_name'.tr,
                    focusNode: controller.nameAccountFocusNode,
                    controller: controller.nameAccountController,
                    hintText: 'enter_account_holder_name'.tr,
                    validator: Validator.formValidation,
                    required: true,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 24.h),
          AppButton(
            title: 'confirm'.tr,
            onPressed: () {
              if (controller.formKey.currentState?.validate() ?? false) {
                controller.addBank();
              }
            },
          ),
        ],
      ),
    );
  }
}
