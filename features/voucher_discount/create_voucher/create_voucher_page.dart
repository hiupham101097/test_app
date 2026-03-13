import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class CreateVoucherPage extends GetView<CreateVoucherController> {
  const CreateVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title:
            controller.isUpdate
                ? "Cập nhật mã giảm giá"
                : "Thêm mới mã giảm giá",
        bottomNavigationBar: _buildBottomButton(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        children: [
          _buildSection(
            title: "Thông tin chung",
            children: [
              _buildVoucherType(),
              SizedBox(height: 14.h),
              _buildVoucherCode(),
              SizedBox(height: 14.h),
              _buildVoucherName(),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Giảm giá",
                controllerField: controller.discountController,
                focusNode: controller.discountFocusNode,
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildSection(
            title: "Thời gian và số lượng",
            children: [
              _buildDateField(
                "Ngày bắt đầu",
                VoucherDateType.start,
                controller.startDateController,
                controller.startDateFocusNode,
              ),
              SizedBox(height: 14.h),
              _buildDateField(
                "Ngày kết thúc",
                VoucherDateType.expiry,
                controller.expiryDateController,
                controller.expiryDateFocusNode,
              ),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Số lượng voucher",
                controllerField: controller.usageCountController,
                focusNode: controller.usageCountFocusNode,
              ),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Sử dụng mỗi người",
                controllerField: controller.usagePerUserController,
                focusNode: controller.usagePerFocusNode,
              ),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Giá đơn hàng tối thiểu",
                controllerField: controller.minOrderController,
                focusNode: controller.minOrderFocusNode,
              ),
            ],
          ),
          Obx(() {
            if (controller.store.value.system.isNotEmpty &&
                controller.store.value.system.length == 2) {
              return _buildSection(
                title: "Lĩnh vực hoạt động",
                children: [
                  Column(
                    children: [SizedBox(height: 14.h), _buildSystemField()],
                  ),
                  SizedBox(height: 14.h),
                ],
              );
            }
            return const SizedBox();
          }),
          _buildSection(
            title: "Trạng thái",
            children: [
              Obx(
                () => SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: controller.isActive.value,
                  onChanged: controller.onChangeStatus,
                  title: Text("Hoạt động", style: AppTextStyles.medium14()),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            color: Colors.black.withOpacity(0.04),
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.semibold14().copyWith(
              color: AppColors.grayscaleColor80,
            ),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildVoucherType() {
    return TitleDefaultTextField(
      focusNode: controller.typeFocusNode,
      controller: controller.typeController,
      title: "Loại giảm giá",
      hintText: "",
      enable: true,
      readOnly: true,
      required: false,
      suffix: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: AppColors.grayscaleColor80,
      ),
    );
  }

  Widget _buildVoucherCode() {
    return TitleDefaultTextField(
      focusNode: controller.codeFocusNode,
      controller: controller.codeController,
      title: "Mã voucher",
      hintText: "",
      enable: true,
      readOnly: true,
      required: false,
    );
  }

  Widget _buildVoucherName() {
    return TitleDefaultTextField(
      focusNode: controller.nameFocusNode,
      controller: controller.nameController,
      title: "Tên voucher",
      hintText: "Nhập tên voucher",
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controllerField,
    FocusNode? focusNode,
  }) {
    return TitleDefaultTextField(
      focusNode: focusNode!,
      controller: controllerField,
      title: label,
      hintText: "Nhập $label",
      textInputType: TextInputType.number,
    );
  }

  Widget _buildDateField(
    String label,
    VoucherDateType type,
    TextEditingController controllerField,
    FocusNode? focusNode,
  ) {
    return Obx(() {
      final date =
          type == VoucherDateType.start
              ? controller.startDate.value
              : controller.expiryDate.value;

      controllerField.text =
          date != null ? "${date.day}/${date.month}/${date.year}" : "";

      return TitleDefaultTextField(
        focusNode: focusNode!,
        controller: controllerField,
        title: label,
        hintText: "Chọn ngày",
        readOnly: true,
        onTab: () {
          FocusManager.instance.primaryFocus?.unfocus();
          controller.pickDate(type);
        },
        suffix: const Icon(Icons.calendar_today, size: 20),
      );
    });
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child:
          controller.isUpdate
              ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: SizedBox(
                      height: 52.h,
                      child: OutlinedButton(
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.warningColor),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        onPressed: controller.actionDelete,
                        child: Text(
                          "delete".tr,
                          style: AppTextStyles.semibold14().copyWith(
                            color: AppColors.warningColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(flex: 2, child: _buildMainButton("update".tr)),
                ],
              )
              : _buildMainButton("create_voucher".tr),
    );
  }

  Widget _buildMainButton(String label) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        onPressed: controller.onSubmit,
        child: Text(
          label,
          style: AppTextStyles.semibold14().copyWith(color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildSystemField() {
    return TitleDefaultTextField(
      focusNode: controller.systemFocusNode,
      controller: controller.systemController,
      title: "Lĩnh vực hoạt động".tr,
      hintText: "Chọn lĩnh vực hoạt động".tr,
      readOnly: true,
      onTab: () {
        if (controller.listSystem.length > 1) {
          controller.showBottomSheetSystem();
        }
      },
      suffix: Icon(
        Icons.keyboard_arrow_down_sharp,
        color: AppColors.grayscaleColor80,
      ),
    );
  }
}
