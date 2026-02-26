import 'package:merchant/commons/views/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:merchant/domain/data/models/promotion_model.dart';
import 'package:merchant/navigations/app_pages.dart';
import 'package:merchant/utils/date_util.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:merchant/constants/asset_constants.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:get/get.dart';

import '../../../utils/dialog_util.dart';

class VoucherItemWidget extends StatelessWidget {
  PromotionModel promotion;
  final bool isJoin;
  final VoidCallback? onJoin;
  VoucherItemWidget({
    super.key,
    required this.promotion,
    this.isJoin = false,
    required this.onJoin,
  });

  @override
  Widget build(BuildContext context) {
    var checkSlug =
        promotion.slug == 'quan-an-noi-bat' ||
                promotion.slug == 'deal-chop-nhoang'
            ? true
            : false;
    return CustomPaint(
      painter: TicketBorderPainter(),
      child: ClipPath(
        clipper: TicketClipper(),
        child: GestureDetector(
          onTap: () {
            if (promotion.isExisted) {
              if (checkSlug) {
                DialogUtil.showConfirmDialog(
                  context,
                  image: AssetConstants.icSuccess,
                  title: "${"participated".tr} ${promotion.name}",
                  button: "close".tr,
                  action: () {
                    // if (Get.isDialogOpen == true) {
                    //   Navigator.of(Get.overlayContext!).pop();
                    // }
                  },
                  isShowCancel: false,
                );
              } else {
                Get.toNamed(
                  Routes.addProductPromotion,
                  arguments: {'promotionId': promotion.id},
                );
              }
            }
          },
          child: Container(
            color: AppColors.primaryColor10,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.r),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(360),
                        child: CachedImage(
                          url: promotion.imageUrlMap,
                          width: 40.r,
                          height: 40.r,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Text("🔥"),
                                SizedBox(width: 4.w),
                                Text(
                                  promotion.name,
                                  style: AppTextStyles.semibold12().copyWith(
                                    color: AppColors.grayscaleColor80,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              promotion.description,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: AppTextStyles.regular12(),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: 8.w),
                      Icon(
                        Icons.error_outline,
                        color: AppColors.grayscaleColor80,
                        size: 16.r,
                      ),
                    ],
                  ),
                ),

                // dashed line
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 16.w),
                  child: CustomPaint(
                    painter: _DashedLinePainter(),
                    size: const Size(double.infinity, 1),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "HSD: ${DateUtil.formatDate(DateTime.tryParse(promotion.endTime.isEmpty ? promotion.endTime2 : promotion.endTime), format: 'dd/MM/yyyy')}",
                            style: AppTextStyles.regular12(),
                          ),
                        ],
                      ),
                      const Spacer(),
                      GestureDetector(
                        onTap: () {
                          if (!promotion.isExisted && !isJoin) {
                            Get.toNamed(
                              Routes.voucherDetail,
                              arguments: {'idVoucher': promotion.id},
                            );
                          } else if (isJoin && onJoin != null) {
                            onJoin?.call();
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 20.w,
                            vertical: 4.h,
                          ),
                          decoration: BoxDecoration(
                            color: promotion.isExisted ? null : Colors.white,
                            border:
                                promotion.isExisted
                                    ? null
                                    : Border.all(
                                      color: AppColors.primaryColor80,
                                      width: 0.5.r,
                                    ),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            promotion.isExisted ? "joined".tr : "join".tr,
                            style: AppTextStyles.semibold10().copyWith(
                              color: AppColors.primaryColor60,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final radius = 8.0.r;
    final notchWidth = 8.0.r;
    final notchDepth = 12.0.r;
    final notchPosition = 55.h;

    final path =
        Path()
          ..moveTo(radius, 0)
          ..lineTo(size.width - radius, 0)
          ..quadraticBezierTo(size.width, 0, size.width, radius)
          ..lineTo(size.width, notchPosition - notchDepth)
          ..cubicTo(
            size.width,
            notchPosition - notchDepth / 2,
            size.width - notchWidth,
            notchPosition - notchDepth / 2,
            size.width - notchWidth,
            notchPosition,
          )
          ..cubicTo(
            size.width - notchWidth,
            notchPosition + notchDepth / 2,
            size.width,
            notchPosition + notchDepth / 2,
            size.width,
            notchPosition + notchDepth,
          )
          ..lineTo(size.width, size.height - radius)
          ..quadraticBezierTo(
            size.width,
            size.height,
            size.width - radius,
            size.height,
          )
          ..lineTo(radius, size.height)
          ..quadraticBezierTo(0, size.height, 0, size.height - radius)
          ..lineTo(0, notchPosition + notchDepth)
          ..cubicTo(
            0,
            notchPosition + notchDepth / 2,
            notchWidth,
            notchPosition + notchDepth / 2,
            notchWidth,
            notchPosition,
          )
          ..cubicTo(
            notchWidth,
            notchPosition - notchDepth / 2,
            0,
            notchPosition - notchDepth / 2,
            0,
            notchPosition - notchDepth,
          )
          ..lineTo(0, radius)
          ..quadraticBezierTo(0, 0, radius, 0)
          ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class TicketBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = TicketClipper().getClip(size);

    final paint =
        Paint()
          ..color = Colors.transparent
          ..style = PaintingStyle.stroke
          ..strokeWidth = 0.7.r
          ..strokeJoin = StrokeJoin.round
          ..shader = null
          ..strokeCap = StrokeCap.round;

    paint.color = AppColors.primaryColor60;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    const dashWidth = 3.0;
    const dashSpace = 4.0;
    double startX = 0;
    final paint =
        Paint()
          ..color = AppColors.grayscaleColor30
          ..strokeWidth = 1;

    while (startX < size.width) {
      canvas.drawLine(Offset(startX, 0), Offset(startX + dashWidth, 0), paint);
      startX += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
