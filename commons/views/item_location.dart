import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class ItemLocation extends StatelessWidget {
  const ItemLocation({
    super.key,

    required this.newValue,
    required this.oldValue,
  });
  final String newValue;
  final String oldValue;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor40, width: 0.5.w),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.location_on_outlined,
            size: 16.w,
            color: AppColors.grayscaleColor50,
          ),
          SizedBox(width: 4.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Địa chỉ mới: ",
                        style: AppTextStyles.semibold11().copyWith(
                          color: AppColors.grayscaleColor80,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: newValue,
                        style: AppTextStyles.regular11().copyWith(
                          color: AppColors.grayscaleColor80,
                          height: 1.2,
                        ),
                      ),
                    ],
                  ),
                ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Địa chỉ cũ: ",
                        style: AppTextStyles.semibold11().copyWith(
                          color: AppColors.grayscaleColor80,
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: oldValue,
                        style: AppTextStyles.regular11().copyWith(
                          color: AppColors.grayscaleColor80,
                          height: 1.2,
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
    );
  }
}
