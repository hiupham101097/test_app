import 'dart:io';

import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class BottomSheetConfirmPass extends StatefulWidget {
  Function() onTap;
  BottomSheetConfirmPass({super.key, required this.onTap});

  @override
  State<BottomSheetConfirmPass> createState() => _BottomSheetConfirmPassState();
}

class _BottomSheetConfirmPassState extends State<BottomSheetConfirmPass> {
  final FocusNode passwordFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final formKey = GlobalKey<FormState>();
  final password = sl<LocalClient>().password;

  @override
  void initState() {
    super.initState();
  }

  String? validatePassword(String? value) {
    if (Validator.isNullOrEmpty(value)) {
      return "requiredPassword".tr;
    }
    if (value != password) {
      return "password_not_match".tr;
    }

    return null;
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
                          "confirm_pass".tr,
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
                        SizedBox(height: 8.h),
                        TitleDefaultTextField(
                          focusNode: passwordFocusNode,
                          controller: passwordController,
                          title: "password_label".tr,
                          hintText: "password_placeholder".tr,
                          obscureText: !isPasswordVisible.value,
                          validator: (value) => validatePassword(value),
                          suffix: IconButton(
                            onPressed: () {
                              setState(() {
                                isPasswordVisible.value =
                                    !isPasswordVisible.value;
                              });
                            },

                            icon: Icon(
                              isPasswordVisible.value
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        // GestureDetector(
                        //   onTap: () {
                        //     Get.toNamed(Routes.resetPassword);
                        //   },
                        //   child: Text(
                        //     "forgot_password".tr,
                        //     style: AppTextStyles.medium12().copyWith(
                        //       color: AppColors.infomationColor,
                        //     ),
                        //   ),
                        // ),
                        // SizedBox(height: 24.h),
                        AppButton(
                          title: "confirm".tr,
                          onPressed: () {
                            if (formKey.currentState?.validate() ?? false) {
                              widget.onTap();
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
