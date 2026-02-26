import 'package:merchant/domain/data/models/oder_detail_model.dart';
import 'package:merchant/features/oder_detail/oder_detail_controller.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

class InfoCustomerWidget extends StatelessWidget {
  const InfoCustomerWidget({super.key, required this.oderDetail});
  final OderDetailModel oderDetail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppColors.grayscaleColor10, width: 1),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "customer_info".tr,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppColors.grayscaleColor10,
                        width: 1,
                      ),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        oderDetail.userName,
                        style: AppTextStyles.medium14().copyWith(
                          color: AppColors.grayscaleColor80,
                        ),
                      ),
                      Text(
                        oderDetail.userAddress,
                        style: AppTextStyles.regular12(),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 16),
              GestureDetector(
                onTap: () {
                  AppUtil.callPhoneNumber(oderDetail.phoneNumber);
                },
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    borderRadius: BorderRadius.circular(360),
                  ),
                  child: Icon(
                    Icons.phone_enabled_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // _buildItemInfo({String? title, String? value, bool isLast = false}) {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12),
  //     decoration: BoxDecoration(
  //       border: Border(
  //         bottom: BorderSide(
  //           color: isLast ? Colors.transparent : AppColors.grayscaleColor10,
  //           width: 0.5,
  //         ),
  //       ),
  //     ),
  //     child: Row(
  //       children: [
  //         Expanded(child: Text(title ?? "", style: AppTextStyles.regular13())),
  //         SizedBox(width: 12),
  //         Expanded(
  //           child: Text(
  //             value ?? "",
  //             style: AppTextStyles.regular13(),
  //             textAlign: TextAlign.end,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
