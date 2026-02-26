import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BottomSheetFeedback extends StatefulWidget {
  Function(String) onTap;
  BottomSheetFeedback({super.key, required this.onTap});

  @override
  State<BottomSheetFeedback> createState() => _BottomSheetFeedbackState();
}

class _BottomSheetFeedbackState extends State<BottomSheetFeedback> {
  final FocusNode feedbackFocusNode = FocusNode();
  final TextEditingController feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final isValidate = false.obs;

  onChangeFeedback() {
    if (feedbackController.text.isNotEmpty) {
      setState(() {
        isValidate.value = true;
      });
    } else {
      setState(() {
        isValidate.value = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            decoration: BoxDecoration(
              color: AppColors.backgroundColor24,
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.w),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          "feedback_from_seller".tr,
                          style: AppTextStyles.semibold14().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Icons.close,
                          size: 18.sp,
                          color: AppColors.grayscaleColor60,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 12.h),
                Divider(color: AppColors.grayscaleColor10, height: 1.h),
                SizedBox(height: 12.h),
                Form(
                  key: formKey,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TitleDefaultTextField(
                          focusNode: feedbackFocusNode,
                          controller: feedbackController,
                          title: "feedback_label".tr,
                          hintText: "feedback_placeholder".tr,
                          maxLines: null,
                          onChanged: (value) {
                            onChangeFeedback();
                          },
                        ),
                        SizedBox(height: 24.h),
                        AppButton(
                          title: "confirm".tr,
                          isEnable: isValidate.value,
                          onPressed: () {
                            if (isValidate.value) {
                              widget.onTap(feedbackController.text);
                            }
                          },
                        ),
                      ],
                    ),
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
}
