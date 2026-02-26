import 'package:merchant/commons/views/app_button.dart';
import 'package:merchant/commons/views/app_text_field.dart';
import 'package:merchant/commons/views/cached_image.dart';
import 'package:merchant/commons/views/custom_app_bar.dart';
import 'package:merchant/domain/data/models/product_group_category_model.dart';
import 'package:merchant/domain/data/models/product_model.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';
import 'package:merchant/utils/app_util.dart';
import 'package:merchant/utils/helpers/formatter/numericFormatter.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputAddProductPromotion extends StatefulWidget {
  final List<ProductModel> listProductSelected;
  final Function(List<ProductModel>) onConfirm;
  const InputAddProductPromotion({
    super.key,
    required this.listProductSelected,
    required this.onConfirm,
  });

  @override
  State<InputAddProductPromotion> createState() =>
      _InputAddProductPromotionState();
}

class _InputAddProductPromotionState extends State<InputAddProductPromotion> {
  final data = <ProductGroupCategoryModel>[];
  final Map<String, TextEditingController> _quantityControllers = {};
  final Map<String, FocusNode> _quantityFocusNodes = {};
  final Map<String, bool> _quantityError = {};

  final Map<String, TextEditingController> priceSaleControllers = {};
  final Map<String, FocusNode> priceSaleFocusNodes = {};
  final Map<String, String> priceSaleError = {};
  @override
  void initState() {
    super.initState();
    data.addAll(AppUtil.groupByCategory(widget.listProductSelected));
    for (final group in data) {
      for (final product in group.products) {
        _quantityControllers.putIfAbsent(
          product.id,
          () => TextEditingController(),
        );
        _quantityFocusNodes.putIfAbsent(product.id, () => FocusNode());
        _quantityError.putIfAbsent(product.id, () => false);
        priceSaleControllers.putIfAbsent(
          product.id,
          () => TextEditingController(),
        );
        priceSaleControllers[product.id]?.text =
            product.uniformCost > 0
                ? AppUtil.formatNumber(product.uniformCost.toDouble())
                : "";
        priceSaleFocusNodes.putIfAbsent(product.id, () => FocusNode());
        priceSaleError.putIfAbsent(product.id, () => "");
      }
    }
  }

  void actionConfirm() {
    bool hasError = false;
    FocusNode? focusFirstInvalid;
    for (final group in data) {
      for (final product in group.products) {
        final priceController = priceSaleControllers[product.id];
        final priceText = priceController?.text.trim() ?? '';
        final isPriceEmpty = priceText.isEmpty;
        final parsedPrice = double.tryParse(priceText.replaceAll(',', '')) ?? 0;

        String priceErrorMessage = "";
        if (isPriceEmpty) {
          priceErrorMessage = "please_do_not_leave_blank".tr;
        } else if (parsedPrice <= 0) {
          priceErrorMessage = "price_must_be_greater_than_zero".tr;
        } else if (parsedPrice >=
            (product.priceSale != 0 && product.priceSale > 0
                ? product.priceSale
                : product.price)) {
          priceErrorMessage =
              "promotion_price_must_be_less_than_original_price".tr;
        }

        priceSaleError[product.id] = priceErrorMessage;
        if (priceErrorMessage.isNotEmpty && focusFirstInvalid == null) {
          focusFirstInvalid = priceSaleFocusNodes[product.id];
          hasError = true;
        }
        final quantityController = _quantityControllers[product.id];
        final quantityText = quantityController?.text.trim() ?? '';
        final isQuantityEmpty = quantityText.isEmpty;
        _quantityError[product.id] = isQuantityEmpty;
        if (isQuantityEmpty && focusFirstInvalid == null) {
          focusFirstInvalid = _quantityFocusNodes[product.id];
          hasError = true;
        }
      }
    }
    if (hasError) {
      setState(() {});
      Future.delayed(Duration(milliseconds: 50), () {
        focusFirstInvalid?.requestFocus();
      });
      return;
    }
    final productPromotion = <ProductModel>[];
    for (final group in data) {
      for (final product in group.products) {
        final priceController = priceSaleControllers[product.id];
        final quantityController = _quantityControllers[product.id];
        final priceText = priceController?.text.trim() ?? '';
        final quantityText = quantityController?.text.trim() ?? '';
        product.quantity.value = int.tryParse(quantityText) ?? 0;
        product.priceSalePromotion.value =
            int.tryParse(priceText.replaceAll(',', '')) ?? 0;
        productPromotion.add(product);
      }
    }

    widget.onConfirm(productPromotion);
    Get.back(result: true);
  }

  @override
  void dispose() {
    for (final c in _quantityControllers.values) {
      c.dispose();
    }
    for (final f in _quantityFocusNodes.values) {
      f.dispose();
    }
    for (final c in priceSaleControllers.values) {
      c.dispose();
    }
    for (final f in priceSaleFocusNodes.values) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor24,
        appBar: CustomAppBar(
          title: "add_product_promotion".tr,
          enableBack: true,
        ),
        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    spacing: 12.h,
                    children: List.generate(
                      data.length,
                      (index) => _buildItemMenu(data[index]),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              child: AppButton(title: "confirm".tr, onPressed: actionConfirm),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemMenu(ProductGroupCategoryModel groupProduct) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 12.h,
      children: [
        Text(
          '${groupProduct.category} (${groupProduct.categoryLength})',
          style: AppTextStyles.semibold14().copyWith(
            color: AppColors.grayscaleColor80,
          ),
        ),
        Column(
          spacing: 8.h,
          children: List.generate(
            groupProduct.products.length,
            (index) => _buildItemMenuProduct(groupProduct.products[index]),
          ),
        ),
      ],
    );
  }

  Widget _buildItemMenuProduct(ProductModel product) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: AppColors.grayscaleColor30, width: 0.3),
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CachedImage(
                  url: product.imageUrlMap,
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
                    Text(product.name, style: AppTextStyles.medium14()),
                    Text(
                      AppUtil().convertHtmlToPlainText(product.description),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.regular10(),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: AppUtil.formatMoney(
                              product.priceSale != 0
                                  ? product.priceSale.toDouble()
                                  : product.price.toDouble(),
                            ),
                            style: AppTextStyles.medium12().copyWith(
                              color: AppColors.primaryColor60,
                            ),
                          ),
                          TextSpan(text: "  ", style: AppTextStyles.medium12()),
                          if (product.priceSale != 0 &&
                              product.price != 0 &&
                              product.priceSale < product.price)
                            TextSpan(
                              text: AppUtil.formatMoney(
                                product.price.toDouble(),
                              ),
                              style: AppTextStyles.medium10().copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: AppColors.grayscaleColor40,
                              ),
                            ),
                        ],
                      ),
                    ),
                    if (product.productOptionFood.isNotEmpty)
                      Row(
                        children: [
                          Icon(
                            Icons.edit_note_outlined,
                            size: 12.w,
                            color: AppColors.grayscaleColor80,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            "${"product_has_options".tr} ${product.productOptionFood.length} ${"custom_options".tr}",
                            style: AppTextStyles.medium10().copyWith(
                              color: AppColors.grayscaleColor80,
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
              SizedBox(width: 20.w),
            ],
          ),
          SizedBox(height: 24.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 16.w,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleDefaultTextField(
                      title: "promotion_price".tr,
                      focusNode: priceSaleFocusNodes[product.id] ?? FocusNode(),
                      controller: priceSaleControllers[product.id],
                      textInputType: TextInputType.number,
                      inputFormatter: [ThousandsFormatter()],
                      hintText: '000.000',
                      required: true,
                      readOnly:
                          product.uniformCost != null &&
                          product.uniformCost != 0,
                      suffix: Container(
                        margin: EdgeInsets.only(top: 13),
                        child: Text(
                          "currency_symbol".tr,
                          style: AppTextStyles.regular14().copyWith(
                            color: AppColors.grayscaleColor80,
                          ),
                        ),
                      ),
                    ),
                    if (priceSaleError[product.id]?.isNotEmpty == true)
                      Text(
                        priceSaleError[product.id]!,
                        style: AppTextStyles.regular10().copyWith(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TitleDefaultTextField(
                      title: "max_quantity_hardcoded".tr,
                      focusNode: _quantityFocusNodes[product.id] ?? FocusNode(),
                      controller: _quantityControllers[product.id],
                      textInputType: TextInputType.number,
                      hintText: 'Số lượng',
                      required: true,
                    ),
                    if (_quantityError[product.id] == true)
                      Text(
                        "please_do_not_leave_blank".tr,
                        style: AppTextStyles.regular10().copyWith(
                          color: Colors.red,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
