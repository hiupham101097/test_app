// Removed unused evaluation_item_model import
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/constants/app_constants.dart';
import 'package:merchant/di_container.dart';
import 'package:merchant/domain/client/local_client.dart';
import 'package:merchant/domain/data/models/store_model.dart';
import 'package:merchant/domain/data/models/wallet_user_model.dart';
import 'package:merchant/domain/database/store_db.dart';
import 'package:merchant/domain/database/wallet_db.dart';
import 'package:merchant/features/home_page/home_controller.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/dialog_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class BuildAppBarWidget extends GetView<HomeController> {
  const BuildAppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // final domain =
    //     '${AppConstants.domainImage}/food/store/${controller.store.value.id}/image_url/';
    // final imageUrlMap = domain + controller.store.value.imageUrl;
    return Obx(
      () => Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 110.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors:
                    controller.isOpenStatus
                        ? [Color(0xff2D007A), Color(0xff5200E0)]
                        : [Color(0xffFFDB7F), Color(0xffFFF6E1)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(
                bottom: BorderSide(
                  color: AppColors.grayscaleColor20,
                  width: 0.5.w,
                ),
              ),
            ),
          ),
          Positioned(
            left: Get.width * 0.15,
            right: 0,
            bottom: -20.h,
            child: Lottie.asset(
              controller.isOpenStatus
                  ? AssetConstants.gifLight
                  : AssetConstants.gifDark,
              width: 78.w,
              height: 78.w,
              fit: BoxFit.contain,
            ),
          ),

          Positioned(
            bottom: 10.h,
            left: 12.w,
            right: 12.w,
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(2.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(360),
                    border: Border.all(
                      color:
                          controller.isOpenStatus
                              ? Colors.white
                              : AppColors.primaryColor70,
                      width: 2.w,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(360),
                    child: CachedImage(
                      url: controller.store.value.imageUrlMap,
                      width: 40.w,
                      height: 40.w,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 8.w,
                        children: [
                          Flexible(
                            child: Text(
                              "hello_new_day".tr,
                              style: AppTextStyles.regular12().copyWith(
                                color:
                                    controller.isOpenStatus
                                        ? Colors.white
                                        : AppColors.grayscaleColor60,
                              ),
                            ),
                          ),
                          Image.asset(
                            AssetConstants.icWelcome,
                            width: 16.w,
                            height: 16.w,
                          ),
                        ],
                      ),
                      Text(
                        controller.store.value.name,
                        style: AppTextStyles.semibold14().copyWith(
                          color:
                              controller.isOpenStatus
                                  ? Colors.white
                                  : AppColors.primaryColor90,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20.w),
                Stack(
                  children: [
                    Column(
                      children: [
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Get.toNamed(Routes.notifycation);
                              },
                              child: Image.asset(
                                AssetConstants.icNotification,
                                width: 28.w,
                                height: 28.w,
                                color:
                                    controller.isOpenStatus
                                        ? Colors.white
                                        : AppColors.primaryColor60,
                              ),
                            ),
                            SizedBox(width: 2.w),
                          ],
                        ),
                      ],
                    ),
                    if (controller.totalNotification.value > 0)
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          alignment: Alignment.center,
                          width: 18.w,
                          height: 18.w,
                          decoration: BoxDecoration(
                            color: AppColors.warningColor,
                            borderRadius: BorderRadius.circular(360),
                          ),
                          child: Text(
                            controller.totalNotification.value > 99
                                ? "99+"
                                : controller.totalNotification.value.toString(),
                            style: AppTextStyles.regular10().copyWith(
                              color: Colors.white,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),

                SizedBox(width: 8.w),
                GestureDetector(
                  onTap: () {
                    final amountSetting = sl<LocalClient>().amountSetting;
                    final walletUser =
                        WalletDB().currentWalletUser() ?? WalletUserModel();
                    if (walletUser.wallet != null &&
                        walletUser.wallet! < int.parse(amountSetting)) {
                      final amountSettingDouble = double.parse(amountSetting);
                      DialogUtil.showErrorMessage(
                        "Ví phải duy trì số dư tối thiểu ${AppUtil.formatMoney(amountSettingDouble)}. Nếu số dư nhỏ hơn ${AppUtil.formatMoney(amountSettingDouble)}đ, bạn sẽ không thể nhận đơn mới.",
                      );
                      return;
                    }
                    controller.toggleStatus();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 4.w,
                    ),
                    decoration: BoxDecoration(
                      color:
                          controller.isOpenStatus
                              ? Color(0xff5200E0)
                              : AppColors.primaryColor70,
                      borderRadius: BorderRadius.circular(360),
                      border: Border.all(
                        color:
                            controller.isOpenStatus
                                ? Colors.white.withOpacity(0.4)
                                : Colors.transparent,
                        width: 0.5.w,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          blurRadius: 1,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        controller.loadingToggleStatus.value
                            ? SizedBox(
                              width: 20.w,
                              height: 20.w,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.w,
                              ),
                            )
                            : Image.asset(
                              controller.isOpenStatus
                                  ? AssetConstants.icTurnOff
                                  : AssetConstants.icTurnOn,
                              width: 20.w,
                              height: 20.w,
                            ),
                        SizedBox(width: 2.w),
                        Text(
                          controller.loadingToggleStatus.value
                              ? "Bật/ tắt".tr
                              : controller.isOpenStatus
                              ? "turn_off".tr
                              : "turn_on".tr,
                          style: AppTextStyles.medium10().copyWith(
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
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
