import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/item_location.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/validators/validator.dart';
import 'info_profile_controller.dart';

class InfoProfilePage extends GetView<InfoProfileController> {
  const InfoProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(Get.context!).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor24,
        appBar: AppBar(
          title: Text(
            "store_info".tr,
            style: AppTextStyles.bold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          // actions: [
          //   Obx(
          //     () => IconButton(
          //       icon: FaIcon(
          //         controller.isEdit.value
          //             ? controller.validate.value == true
          //                 ? FontAwesomeIcons.check
          //                 : null
          //             : FontAwesomeIcons.edit,
          //         size: 14.w,
          //         color: AppColors.grayscaleColor80,
          //       ),
          //       onPressed: () {
          //         controller.actionEdit();
          //       },
          //     ),
          //   ),
          // ],
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 192, 235, 135), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          leading: IconButton(
            icon: FaIcon(
              FontAwesomeIcons.chevronLeft,
              size: 14.w,
              color: AppColors.grayscaleColor80,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 12.w),
            child: _buildBody(),
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    // final domain =
    //     '${AppConstants.domainImage}/food/store/${controller.store.value.id}/image_url/';
    // final imageUrlMap = domain + controller.store.value.imageUrl;
    return Obx(
      () => Form(
        key: controller.formKey,
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(100.r),
                  child:
                      controller.pickedImagesAvatar.value.isNotEmpty &&
                              controller.isEdit.value
                          ? Image.file(
                            File(controller.pickedImagesAvatar.value),
                            fit: BoxFit.cover,
                            width: 64.w,
                            height: 64.w,
                          )
                          : CachedImage(
                            url: controller.store.value.imageUrlMap,
                            fit: BoxFit.cover,
                            width: 64.w,
                            height: 64.w,
                          ),
                ),
                if (controller.isEdit.value)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        AppUtil().pickImages().then((value) {
                          if (value.path.isNotEmpty) {
                            controller.pickedImagesAvatar.value = value.path;
                          }
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(4.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: FaIcon(
                          FontAwesomeIcons.edit,
                          size: 14.w,
                          color: AppColors.grayscaleColor90,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                if (index < controller.store.value.rating.floor()) {
                  return Icon(Icons.star, color: AppColors.attentionColor);
                } else if (index < controller.store.value.rating &&
                    controller.store.value.rating % 1 != 0) {
                  return Icon(Icons.star_half, color: AppColors.attentionColor);
                } else {
                  return Icon(Icons.star, color: AppColors.grayscaleColor20);
                }
              }),
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: TextFormField(
                readOnly: !controller.isEdit.value,
                textAlign: TextAlign.center,
                controller: controller.nameController,
                keyboardType: TextInputType.text,
                style: AppTextStyles.medium16().copyWith(
                  color: AppColors.grayscaleColor80,
                ),
                maxLines: null,
                validator: (value) => Validator.textValidation(value),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
            SizedBox(height: 24.h),
            TitleDefaultTextField(
              focusNode: controller.phoneFocusNode,
              controller: controller.phoneController,
              title: "phone_number".tr,
              enable: true,
              readOnly: true,
              hintText: "+84123456789",
              // validator: (value) => Validator.phoneValidation(value),
              textInputType: TextInputType.number,
            ),
            SizedBox(height: 24.h),
            TitleDefaultTextField(
              focusNode: controller.emailFocusNode,
              controller: controller.emailController,
              title: "email".tr,
              enable: true,
              readOnly: true,
              textInputType: TextInputType.emailAddress,
              // validator: (value) => Validator.emailValidation(value),
            ),
            SizedBox(height: 24.h),
            TitleDefaultTextField(
              focusNode: controller.addressFocusNode,
              controller: controller.addressController,
              title: "Địa chỉ".tr,
              readOnly: !controller.isEdit.value,
              textInputType: TextInputType.text,
              hintText: "Địa chỉ cửa hàng",
              enable: true,
              maxLines: null,
              onChanged: (value) {
                controller.onSearchLocation(value);
              },
              validator: (value) => Validator.textValidation(value),
            ),

            if (controller.listLocation.isNotEmpty &&
                controller.isEdit.value) ...[
              SizedBox(height: 12.h),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.grayscaleColor40,
                    width: 1.w,
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.h,
                    children: [
                      ...controller.listLocation.map(
                        (e) => GestureDetector(
                          onTap: () {
                            controller.onSelectLocation(e);
                          },
                          child: ItemLocation(
                            newValue: e.fullNewAddress,
                            oldValue: e.fullAddress,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            SizedBox(height: 24.h),
            Container(
              decoration: BoxDecoration(
                color: AppColors.primaryColor10,
                borderRadius: BorderRadius.circular(8.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "if_you_need_to_adjust_your_profile".tr,
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "1. Tổng đài Chợ Thông Minh".tr,
                          style: AppTextStyles.regular12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                        TextSpan(
                          text: " ",
                          style: AppTextStyles.regular12().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                        TextSpan(
                          recognizer:
                              TapGestureRecognizer()
                                ..onTap = () {
                                  AppUtil.callPhoneNumber("0935 319 739");
                                },
                          text: "0935 319 739",
                          style: AppTextStyles.regular12().copyWith(
                            color: AppColors.grayscaleColor80,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: AppColors.grayscaleColor80,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "contact_us_desc_4".tr,
                    style: AppTextStyles.regular12().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  GestureDetector(
                    onTap: () {
                      AppUtil.openUrl("https://zalo.me/g/tsxlel974");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: AppColors.primaryColor80,
                          width: 1.w,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 12.w,
                        vertical: 8.h,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.people_rounded,
                            color: AppColors.grayscaleColor80,
                          ),
                          SizedBox(width: 12.w),
                          Text(
                            "contact_us_desc".tr,
                            style: AppTextStyles.regular12().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                          ),
                        ],
                      ),
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
}
