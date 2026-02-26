import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/pleace_holder_view.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/object_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class PickImageWidget extends StatelessWidget {
  const PickImageWidget({
    super.key,
    required this.pickedImages,
    required this.title,
    required this.width,
    required this.height,
    required this.onTap,
    required this.onDelete,
  });
  final String pickedImages;
  final String title;
  final double width;
  final double height;
  final Function(String) onTap;
  final Function(String) onDelete;

  @override
  Widget build(BuildContext context) {
    print(pickedImages);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text(title, style: AppTextStyles.semibold14()),
        if (pickedImages.isNotEmpty)
          Container(
            width: width,
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
                  pickedImages.contains("http") &&
                          ObjectUtil.isNotEmpty(pickedImages)
                      ? CachedImage(
                        url: pickedImages,
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      )
                      : SizedBox.shrink(),
                  pickedImages != "" &&
                          pickedImages.isNotEmpty &&
                          !pickedImages.contains("http")
                      ? Image.file(
                        File(pickedImages),
                        width: width,
                        height: height,
                        fit: BoxFit.cover,
                      )
                      : SizedBox.shrink(),
                  Positioned(
                    top: 4.w,
                    right: 4.w,
                    child: GestureDetector(
                      onTap: () {
                        onDelete(pickedImages);
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
        if (pickedImages.isEmpty)
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
    );
  }
}
