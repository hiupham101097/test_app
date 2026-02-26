import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/pleace_holder_view.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/object_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class PickImageMutilWidget extends StatelessWidget {
  const PickImageMutilWidget({
    super.key,
    required this.pickedImages,
    required this.title,
    required this.width,
    required this.height,
    required this.onTap,
    required this.onDelete,
    required this.maxImages,
  });
  final List<String> pickedImages;
  final String title;
  final double width;
  final double height;
  final Function(String) onTap;
  final Function(String) onDelete;
  final int maxImages;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTextStyles.semibold14().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        Text(
          "Bạn có thể thêm tối đa $maxImages ảnh",
          style: AppTextStyles.regular12().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 12.w,
          runSpacing: 12.h,
          children: [
            if (ObjectUtil.isNotEmpty(pickedImages))
              ...pickedImages
                  .map(
                    (e) => Container(
                      width: (Get.width - 36.w) / 2,
                      height: height,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12.r),
                        color: AppColors.backgroundColor24,
                        border: Border.all(
                          color: AppColors.grayscaleColor10,
                          width: 0.5.w,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grayscaleColor10,
                            blurRadius: 1.r,
                            offset: Offset(1, 1),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12.r),
                        child: Stack(
                          children: [
                            e.contains("http") && e.isNotEmpty
                                ? CachedImage(
                                  url: e,
                                  width: (Get.width - 36.w) / 2,
                                  height: height,
                                  fit: BoxFit.cover,
                                )
                                : SizedBox.shrink(),
                            ObjectUtil.isNotEmpty(e) && !e.contains("http")
                                ? Image.file(
                                  File(e),
                                  width: (Get.width - 36.w) / 2,
                                  height: height,
                                  fit: BoxFit.cover,
                                )
                                : SizedBox.shrink(),
                            Positioned(
                              top: 4.w,
                              right: 4.w,
                              child: GestureDetector(
                                onTap: () {
                                  onDelete(e);
                                },
                                child: Container(
                                  padding: EdgeInsets.all(4.w),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningColor,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    size: 16.w,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList(),
            if (pickedImages.length < maxImages)
              PleaceHolderView(
                width: width,
                height: height,
                onTap: () {
                  AppUtil().pickImages().then((value) {
                    if (value.path.isNotEmpty) {
                      onTap(value.path);
                    }
                  });
                },
              ),
          ],
        ),
      ],
    );
  }
}
