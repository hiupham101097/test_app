import 'package:flutter/material.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class CustomEmpty extends StatelessWidget {
  final String title;
  final String image;
  final double? width;
  final double? height;
  const CustomEmpty({
    super.key,
    required this.title,
    this.image = AssetConstants.icEmpty,
    this.width = 128,
    this.height = 128,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(image, width: width, height: height),
        const SizedBox(height: 10),
        Text(
          title,
          style: AppTextStyles.medium12().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
      ],
    );
  }
}
