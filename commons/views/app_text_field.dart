import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:get/get.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class TitleDefaultTextField extends StatelessWidget {
  final String? title;
  final TextAlign? textAlign;
  final int? maxLines;
  final int? maxLength;
  final int? fixedLines;
  final bool? softWrap;
  final EdgeInsetsGeometry? outsidePadding;
  final EdgeInsetsGeometry? innerPadding;
  final TextEditingController? controller;
  final String? errorMsg;
  final String? hintText;
  final Color? hintColor;
  final bool? isAutoFocus;
  final double? width;
  final double? height;
  final String? borderRadiusEdge;
  final FocusNode focusNode;
  final bool? isIgnorePointer;
  final ValueChanged<String>? onChanged;
  final double? blurRadius;
  final double? radius;
  final Function? onSubmitted;
  final TextInputType? textInputType;
  final bool? enabled;
  final bool? obscureText;
  final double? letterSpacing;
  final List<TextInputFormatter>? inputFormatter;
  final Widget? preIcon;
  final Widget? postIcon;
  final List<String>? autoFillHints;
  final GestureTapCallback? onTab;
  final bool? enableFocusBorder;
  final bool? filled;
  final Color? fillColor;
  final Widget? suffix;
  final GestureTapCallback? onTabSuffix;
  final FormFieldValidator<String>? validator;
  final bool? readOnly;
  final bool? required;
  final bool? enable;

  const TitleDefaultTextField({
    super.key,
    this.title,
    this.textAlign = TextAlign.left,
    this.hintText = '',
    this.errorMsg,
    this.hintColor,
    this.maxLines = 1,
    this.maxLength,
    this.fixedLines,
    this.softWrap = true,
    this.isAutoFocus = false,
    this.controller,
    this.textInputType = TextInputType.text,
    this.width = double.infinity,
    this.height,
    this.borderRadiusEdge = '',
    required this.focusNode,
    this.isIgnorePointer = false,
    this.onChanged,
    this.onSubmitted,
    this.radius = 8,
    this.blurRadius = 0,
    this.enabled = true,
    this.letterSpacing,
    this.inputFormatter,
    this.obscureText = false,
    this.preIcon,
    this.postIcon,
    this.innerPadding = const EdgeInsets.only(
      top: 12,
      bottom: 12,
      left: 12,
      right: 12,
    ),
    this.outsidePadding = EdgeInsets.zero,
    this.autoFillHints,
    this.onTab,
    this.enableFocusBorder = true,
    this.filled = true,
    this.fillColor,
    this.suffix,
    this.onTabSuffix,
    this.validator,
    this.readOnly = false,
    this.required = false,
    this.enable = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: TextFormField(
        autofillHints: autoFillHints,
        focusNode: focusNode,
        cursorColor: Colors.black,
        autofocus: isAutoFocus!,
        readOnly: readOnly ?? false,
        onTap: onTab, // ✅ xử lý tap ở đây, kể cả khi readOnly = true
        textAlign: textAlign!,
        textAlignVertical: TextAlignVertical.center,
        controller: controller,
        onChanged: onChanged,
        keyboardType: textInputType,
        maxLength: maxLength,
        maxLines: maxLines,
        inputFormatters: inputFormatter,
        obscureText: obscureText!,
        validator: validator,
        decoration: InputDecoration(
          label:
              required == true
                  ? Text.rich(
                    TextSpan(
                      text: title ?? '',
                      style: AppTextStyles.regular16().copyWith(
                        color:
                            enable == true
                                ? AppColors.grayscaleColor60
                                : AppColors.grayscaleColor90,
                      ),
                      children: [
                        TextSpan(
                          text: '*',
                          style: AppTextStyles.regular16().copyWith(
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                  )
                  : Text(
                    title ?? '',
                    style: AppTextStyles.regular16().copyWith(
                      color:
                          enable == true
                              ? AppColors.grayscaleColor60
                              : AppColors.grayscaleColor90,
                    ),
                  ),
          labelStyle: AppTextStyles.regular16().copyWith(
            color: AppColors.grayscaleColor90,
          ),
          floatingLabelStyle: AppTextStyles.regular16().copyWith(
            color: AppColors.grayscaleColor90,
          ),
          hintStyle: AppTextStyles.regular14().copyWith(
            color: hintColor ?? AppColors.grayscaleColor60,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.always,
          hintText: hintText,
          prefixIcon: preIcon,
          filled: filled,
          fillColor: fillColor ?? Colors.transparent,
          errorText: errorMsg,
          errorStyle: AppTextStyles.regular12().copyWith(
            color: AppColors.warningColor,
            height: 1.2,
          ),
          isDense: true,
          contentPadding: innerPadding,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: const BorderSide(
              color: AppColors.grayscaleColor60,
              width: 1.0,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(radius!),
            borderSide: BorderSide(
              color:
                  enable == true
                      ? AppColors.grayscaleColor30
                      : AppColors.grayscaleColor60,
              width: 1.0,
            ),
          ),
          focusedBorder:
              readOnly == false
                  ? OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius!),
                    borderSide: BorderSide(
                      color: AppColors.primaryColor,
                      width: 1.5,
                    ),
                  )
                  : OutlineInputBorder(
                    borderRadius: BorderRadius.circular(radius!),
                    borderSide: const BorderSide(
                      color: AppColors.grayscaleColor60,
                      width: 1.0,
                    ),
                  ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.warningColor, width: 2.0),
            borderRadius: BorderRadius.circular(radius!),
          ),
          suffixIcon:
              suffix != null
                  ? GestureDetector(onTap: onTabSuffix, child: suffix)
                  : null,
        ),
        style: AppTextStyles.regular14().copyWith(
          color:
              enable == true
                  ? AppColors.grayscaleColor60
                  : AppColors.grayscaleColor80,
        ),
      ),
    );
  }
}
