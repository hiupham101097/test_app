import 'package:merchant/style/app_colors.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';

class BuildRating extends StatelessWidget {
  const BuildRating({super.key, required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(5, (index) {
        if (index < rating.floor()) {
          return Icon(Icons.star, color: AppColors.attentionColor, size: 12.sp);
        } else if (index < rating && rating % 1 != 0) {
          return Icon(
            Icons.star_half,
            color: AppColors.attentionColor,
            size: 12.sp,
          );
        } else {
          return Icon(
            Icons.star,
            color: AppColors.grayscaleColor20,
            size: 12.sp,
          );
        }
      }),
    );
  }
}
