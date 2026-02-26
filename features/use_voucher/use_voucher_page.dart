import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:merchant/commons/views/custom_screen.dart';
import 'use_voucher_controller.dart';

class UseVoucherPage extends GetView<UseVoucherController> {
  const UseVoucherPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScreen(title: "use_voucher".tr, child: _buildBody());
  }

  Widget _buildBody() {
    return Container();
  }
}
