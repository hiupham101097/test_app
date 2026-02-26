import 'package:merchant/utils/screen_util_extensions.dart';
import 'package:flutter/material.dart';
import 'package:merchant/style/app_colors.dart';
import 'package:merchant/style/app_text_style.dart';

class CustomDropdown<T> extends StatefulWidget {
  final String? title;
  final String? hintText;
  final T? value;
  final List<T> items;
  final String Function(T item)? itemToString;
  final Widget Function(T item)? itemBuilder;
  final ValueChanged<T?>? onChanged;
  final String? errorMsg;
  final bool? enabled;
  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<T>? validator;
  final bool? isRequired;
  final Function()? onTap;

  const CustomDropdown({
    super.key,
    this.title,
    this.hintText,
    this.value,
    required this.items,
    this.itemToString,
    this.itemBuilder,
    this.onChanged,
    this.errorMsg,
    this.enabled = true,
    this.width,
    this.height,
    this.radius = 8,
    this.padding,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isRequired = false,
    this.onTap,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  @override
  Widget build(BuildContext context) {
    Widget dropdownField = DropdownButtonFormField<T>(
      value: widget.value,
      items:
          widget.items.map((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child:
                  widget.itemBuilder?.call(item) ??
                  Text(
                    widget.itemToString?.call(item) ?? item.toString(),
                    style: AppTextStyles.regular14().copyWith(
                      color: AppColors.grayscaleColor80,
                    ),
                  ),
            );
          }).toList(),
      onChanged: null, // Tắt menu dropdown
      validator: widget.validator,
      decoration: InputDecoration(
        label:
            widget.isRequired == true
                ? Text.rich(
                  TextSpan(
                    text: widget.title ?? '',
                    style: AppTextStyles.regular16().copyWith(
                      color: AppColors.grayscaleColor90,
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
                  widget.title ?? '',
                  style: AppTextStyles.regular16().copyWith(
                    color: AppColors.grayscaleColor90,
                  ),
                ),
        labelStyle: AppTextStyles.regular16().copyWith(
          color: AppColors.grayscaleColor90,
        ),
        floatingLabelStyle: AppTextStyles.regular16().copyWith(
          color: AppColors.grayscaleColor90,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.grayscaleColor60,
            width: 1.0,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.grayscaleColor60,
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.grayscaleColor60,
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.warningColor,
            width: 2.0,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.grayscaleColor60,
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.radius!),
          borderSide: const BorderSide(
            color: AppColors.grayscaleColor60,
            width: 1.0,
          ),
        ),
        floatingLabelBehavior: FloatingLabelBehavior.always,
        hintText: widget.hintText,
        hintStyle: AppTextStyles.regular14().copyWith(
          color: AppColors.grayscaleColor60,
        ),
        prefixIcon: widget.prefixIcon,
        suffixIcon:
            widget.suffixIcon ??
            Icon(Icons.keyboard_arrow_down, color: AppColors.grayscaleColor60),
        filled: true,
        fillColor: widget.fillColor ?? Colors.transparent,
        errorText: widget.errorMsg,
        errorStyle: AppTextStyles.regular12().copyWith(
          color: AppColors.warningColor,
          height: 1.2,
        ),
        isDense: true,
      ),
      style: AppTextStyles.regular14().copyWith(
        color: AppColors.grayscaleColor80,
      ),
      icon:
          widget.suffixIcon ??
          Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.grayscaleColor60,
            size: 18.sp,
          ),
      dropdownColor: Colors.white,
      menuMaxHeight: 0, // Tắt menu
      isExpanded: true,
      isDense: true,
    );

    if (widget.onTap != null) {
      return GestureDetector(onTap: widget.onTap, child: dropdownField);
    }

    return dropdownField;
  }
}

// Specialized dropdown for common use cases
class StringDropdown extends StatelessWidget {
  final String? title;
  final String? hintText;
  final String? value;
  final List<String> items;
  final ValueChanged<String?>? onChanged;
  final String? errorMsg;
  final bool? enabled;
  final double? width;
  final double? height;
  final double? radius;
  final EdgeInsetsGeometry? padding;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator<String>? validator;
  final bool? isRequired;

  const StringDropdown({
    super.key,
    this.title,
    this.hintText,
    this.value,
    required this.items,
    this.onChanged,
    this.errorMsg,
    this.enabled = true,
    this.width,
    this.height,
    this.radius = 8,
    this.padding,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return CustomDropdown<String>(
      title: title,
      hintText: hintText,
      value: value,
      items: items,
      onChanged: onChanged,
      errorMsg: errorMsg,
      enabled: enabled,
      width: width,
      height: height,
      radius: radius,
      padding: padding,
      fillColor: fillColor,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      validator: validator,
      isRequired: isRequired,
    );
  }
}
