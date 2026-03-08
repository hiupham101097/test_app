import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'package:merchant/features/voucher_discount/create_voucher/create_voucher_controller.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/screen_util_extensions.dart';

class CreateVoucherPage extends GetView<CreateVoucherController> {
  const CreateVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    // TỐI ƯU: Bọc toàn bộ màn hình bằng GestureDetector để bắt sự kiện chạm ra ngoài
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      behavior: HitTestBehavior.opaque,
      child: CustomScreen(
        backgroundColor: AppColors.backgroundColor24,
        title: controller.isUpdate ? "Cập nhật mã giảm giá" : "Thêm mới mã giảm giá",
        bottomNavigationBar: _buildBottomButton(),
        child: _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      // TỐI ƯU: Tự động đóng bàn phím khi người dùng bắt đầu cuộn trang (UX chuẩn)
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
              ),
            ],
          ),
          SizedBox(height: 20.h),
          _buildSection(
            title: "Thời gian và số lượng",
            children: [
              _buildDateField("Ngày bắt đầu", VoucherDateType.start),
              SizedBox(height: 14.h),
              _buildDateField("Ngày kết thúc", VoucherDateType.expiry),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Số lượng voucher",
                controllerField: controller.usageCountController,
              ),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Sử dụng mỗi người",
                controllerField: controller.usagePerUserController,
              ),
              SizedBox(height: 14.h),
              _buildNumberField(
                label: "Giá đơn hàng tối thiểu",
                controllerField: controller.minOrderController,
              ),
            ],
          ),
          SizedBox(height: 20.h),
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
          SizedBox(height: 20.h),
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
            style: AppTextStyles.semibold14()
                .copyWith(color: AppColors.grayscaleColor80),
          ),
          SizedBox(height: 14.h),
          ...children,
        ],
      ),
    );
  }

  Widget _buildVoucherType() {
    return TextFormField(
      initialValue: "Giảm giá",
      enabled: false,
      decoration: _inputDecoration("Loại giảm giá"),
    );
  }

  Widget _buildVoucherCode() {
    return TextFormField(
      initialValue: controller.code,
      enabled: false,
      decoration: _inputDecoration("Mã voucher"),
    );
  }

  Widget _buildVoucherName() {
    return TextFormField(
      controller: controller.nameController,
      decoration: _inputDecoration("Tên voucher"),
    );
  }

  Widget _buildNumberField({
    required String label,
    required TextEditingController controllerField,
  }) {
    return TextFormField(
      controller: controllerField,
      keyboardType: TextInputType.number,
      decoration: _inputDecoration(label),
    );
  }

  Widget _buildDateField(String label, VoucherDateType type) {
    return Obx(() {
      final date = type == VoucherDateType.start
          ? controller.startDate.value
          : controller.expiryDate.value;

      final text = date != null
          ? "${date.day}/${date.month}/${date.year}"
          : "Chọn ngày";

      return InkWell(
        onTap: () {
          // TỐI ƯU: Đóng bàn phím trước khi mở Picker để tránh chồng chéo giao diện
          FocusManager.instance.primaryFocus?.unfocus();
          controller.pickDate(type);
        },
        child: InputDecorator(
          decoration: _inputDecoration(label).copyWith(
            suffixIcon: const Icon(Icons.calendar_today, size: 20),
          ),
          child: Text(
            text,
            style: AppTextStyles.regular14(),
          ),
        ),
      );
    });
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      labelStyle: AppTextStyles.regular12()
          .copyWith(color: AppColors.grayscaleColor60),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide.none,
      ),
      // Giúp label không bị che khuất khi có giá trị
      floatingLabelBehavior: FloatingLabelBehavior.auto,
    );
  }

  Widget _buildBottomButton() {
    return Padding(
      padding: EdgeInsets.all(16.r),
      child: SizedBox(
        width: double.infinity, // Đảm bảo nút full width
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
            controller.isUpdate ? "Cập nhật" : "Tạo voucher",
            style: AppTextStyles.semibold14().copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }
}