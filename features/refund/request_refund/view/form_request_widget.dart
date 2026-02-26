import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_dropdown.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/features/refund/request_refund/request_refund_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class FormRequestWidget extends GetView<RequestRefundController> {
  const FormRequestWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 20.h,
        children: [
          Text(
            "fill_information".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          TitleDefaultTextField(
            focusNode: controller.codeFocusNode,
            controller: controller.codeController,
            title: "order_code_hardcoded".tr,
            readOnly: true,
            hintText: "enter_order_code_hardcoded".tr,
            textInputType: TextInputType.text,
            validator: (value) => Validator.formValidation(value),
          ),

          Obx(
            () => CustomDropdown<String>(
              title: 'service'.tr,
              hintText: 'select_service_type'.tr,
              value: controller.selectedservice.value,
              items: controller.serviceItems,
              onChanged: (value) {
                controller.selectedservice.value = value!;
                controller.isValidate();
              },
              suffixIcon: SizedBox(),
              isRequired: true,
              validator: (value) => Validator.formValidation(value),
            ),
          ),

          Obx(
            () => CustomDropdown<String>(
              title: 'problem'.tr,
              hintText: 'select_problem'.tr,
              value: controller.selectedProblem.value,
              items: controller.listReason,
              onChanged: (value) {
                controller.selectedProblem.value = value!;
                controller.isValidate();
              },
              onTap: () {
                controller.showBottomSheetCustom();
              },
              isRequired: true,
              validator: (value) => Validator.formValidation(value),
            ),
          ),
          TitleDefaultTextField(
            focusNode: controller.titleFocusNode,
            controller: controller.titleController,
            title: "title".tr,
            readOnly: !controller.isReadonly.value,

            required: true,
            hintText: "enter_title".tr,
            textInputType: TextInputType.text,
            validator: (value) => Validator.formValidation(value),
          ),
          TitleDefaultTextField(
            required: true,
            focusNode: controller.descriptionFocusNode,
            controller: controller.descriptionController,
            title: "description".tr,
            readOnly: !controller.isReadonly.value,
            hintText: "enter_description".tr,
            textInputType: TextInputType.text,
            maxLines: null,
            maxLength: 300,
            validator: (value) => Validator.formValidation(value),
          ),
        ],
      ),
    );
  }
}
