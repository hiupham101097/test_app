import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/domain/data/models/variant_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:flutter/material.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';

class BottomsheetAddVariant extends StatefulWidget {
  const BottomsheetAddVariant({
    super.key,
    required this.onConfirm,
    this.variant,
    this.isEdit = false,
  });
  final Function(VariantModel) onConfirm;
  final VariantModel? variant;
  final bool isEdit;
  @override
  State<BottomsheetAddVariant> createState() => _BottomsheetAddVariantState();
}

class _BottomsheetAddVariantState extends State<BottomsheetAddVariant> {
  final formKey = GlobalKey<FormState>();
  final nameFocusNode = FocusNode();
  final nameController = TextEditingController();
  final priceFocusNode = FocusNode();
  final priceController = TextEditingController();
  final isValidate = false.obs;

  void actionValidate() {
    if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
      isValidate.value = true;
    } else {
      isValidate.value = false;
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.variant != null) {
      nameController.text = widget.variant!.title;
      priceController.text = AppUtil.formatNumber(widget.variant!.price);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            children: [
              Align(
                child: Text(
                  widget.isEdit
                      ? "Chỉnh sửa biến thể sản phẩm".tr
                      : "Thêm biến thể sản phẩm".tr,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.semibold16().copyWith(
                    color: AppColors.grayscaleColor80,
                  ),
                ),
              ),
              Positioned(
                right: 0,
                top: 0,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(
                    Icons.close,
                    color: AppColors.grayscaleColor80,
                    size: 18.sp,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Divider(color: AppColors.grayscaleColor10, height: 1.h),
          SizedBox(height: 24.h),
          _buildForm(),
          SizedBox(height: 24.h),
          AppButton(
            title: widget.isEdit ? "Cập nhật".tr : "XÁC NHẬN".tr,
            onPressed: () {
              Get.back();
              widget.onConfirm(
                VariantModel(
                  title: nameController.text,
                  price: double.parse(priceController.text.replaceAll(',', '')),
                ),
              );
            },
            isEnable: isValidate.value,
          ),
        ],
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TitleDefaultTextField(
            focusNode: nameFocusNode,
            title: "Tên biến thể".tr,
            hintText: "Nhập tên biến thể".tr,
            controller: nameController,
            onChanged: (value) {
              setState(() {
                actionValidate();
              });
            },
          ),
          SizedBox(height: 24.h),
          TitleDefaultTextField(
            focusNode: priceFocusNode,
            title: "Giá biến thể".tr,
            hintText: "Nhập giá biến thể".tr,
            controller: priceController,
            inputFormatter: [ThousandsFormatter()],
            textInputType: TextInputType.number,
            onChanged: (value) {
              setState(() {
                actionValidate();
              });
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
        ],
      ),
    );
  }
}
