
import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BottomsheetUpdateVoucher extends StatefulWidget {
  final ProductModel dataUpdate;
  final Function(String, int) onTap;
  final String title;

  const BottomsheetUpdateVoucher({
    super.key,
    required this.dataUpdate,
    required this.onTap,
    required this.title,
  });

  @override
  State<BottomsheetUpdateVoucher> createState() =>
      _BottomsheetUpdateVoucherState();
}

class _BottomsheetUpdateVoucherState extends State<BottomsheetUpdateVoucher> {
  int selectedIndex = 0;
  final FocusNode promotionInformationFocusNode = FocusNode();
  final TextEditingController promotionInformationController =
      TextEditingController();
  final FocusNode numViewFocusNode = FocusNode();
  final TextEditingController numViewController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    promotionInformationController.text = AppUtil.formatNumber(
      widget.dataUpdate.priceSale.toDouble(),
    );
    numViewController.text = widget.dataUpdate.quantityPromotion.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        padding: EdgeInsets.all(12.w).copyWith(
          bottom:
              MediaQuery.of(context).systemGestureInsets.bottom > 32.h
                  ? 40.h
                  : 20.h,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Chỉnh sửa thông tin".tr,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.semibold16().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: Icon(
                    Icons.close,
                    color: AppColors.grayscaleColor80,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: CachedImage(
                    url: widget.dataUpdate.imageUrlMap,
                    width: 76.w,
                    height: 76.w,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    spacing: 3.h,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.dataUpdate.name,
                        style: AppTextStyles.medium14(),
                      ),
                      Text(
                        AppUtil().convertHtmlToPlainText(
                          widget.dataUpdate.description,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: AppTextStyles.regular10(),
                      ),
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: AppUtil.formatMoney(
                                widget.dataUpdate.priceSale.toDouble(),
                              ),
                              style: AppTextStyles.medium12().copyWith(
                                color: AppColors.primaryColor60,
                              ),
                            ),
                            TextSpan(
                              text: "  ",
                              style: AppTextStyles.medium12(),
                            ),
                            TextSpan(
                              text: AppUtil.formatMoney(
                                widget.dataUpdate.price.toDouble(),
                              ),
                              style: AppTextStyles.medium10().copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.grayscaleColor40,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (widget.dataUpdate.productOptionFood.isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              Icons.edit_note_outlined,
                              size: 12.w,
                              color: AppColors.grayscaleColor80,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              "Sản phẩm có ${widget.dataUpdate.productOptionFood.length} tùy chỉnh",
                              style: AppTextStyles.medium10().copyWith(
                                color: const Color.fromARGB(255, 40, 13, 13),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 24.h),
            TitleDefaultTextField(
              focusNode: promotionInformationFocusNode,
              title: "Giá khuyến mãi".tr,
              required: true,
              hintText: "Nhập giá khuyến mãi".tr,
              controller: promotionInformationController,
              inputFormatter: [ThousandsFormatter()],
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Vui lòng nhập giá khuyến mãi".tr;
                }
                if (double.tryParse(value.replaceAll(',', ''))! >
                    widget.dataUpdate.price.toDouble()) {
                  return "promotion_price_must_be_less_than_original_price".tr;
                }
                if (double.tryParse(value.replaceAll(',', ''))! <= 0) {
                  return "price_must_be_greater_than_zero".tr;
                }
                return null;
              },
              onChanged: (value) {
                setState(() {});
              },
              suffix: Container(
                margin: EdgeInsets.only(top: 13),
                child: Text(
                  "đ",
                  style: AppTextStyles.regular14().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
            ),
            SizedBox(height: 12.h),
            TitleDefaultTextField(
              focusNode: numViewFocusNode,
              title: "Số lượng khuyến mãi tối đa".tr,
              hintText: "Nhập số lượng khuyến mãi tối đa".tr,
              controller: numViewController,
              required: true,
              onChanged: (value) {
                setState(() {});
              },
            ),
            SizedBox(height: 24.h),
            AppButton(
              title: "LƯU CHỈNH SỬA".tr,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  widget.onTap(
                    promotionInformationController.text.replaceAll(',', ''),
                    int.parse(numViewController.text),
                  );
                }
              },
              isEnable:
                  promotionInformationController.text.isNotEmpty &&
                  numViewController.text.isNotEmpty,
            ),
          ],
        ),
      ),
    );
  }
}
