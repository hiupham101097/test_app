import 'package:flutter/material.dart';

import '../../style/app_colors.dart';
import '../../style/app_text_style.dart';

class IconToastWidget extends StatefulWidget {
  final Color? backgroundColor;
  final Color? color;
  final Widget? icon;
  final String? message;
  final String? fontFamily;
  final double? fontSize;
  final double? height;
  final double? width;
  final String? assetName;
  final EdgeInsetsGeometry? padding;

  const IconToastWidget({
    super.key,
    this.backgroundColor,
    this.color,
    this.icon,
    this.message,
    this.fontFamily,
    this.fontSize,
    this.height,
    this.width,
    @required this.assetName,
    this.padding,
  });

  factory IconToastWidget.fail({
    String? msg,
    EdgeInsetsGeometry? contentPadding,
  }) => IconToastWidget(
    message: msg,
    assetName: 'assets/ic_fail.png',
    backgroundColor: const Color(0xf0f5222d),
    color: AppColors.primaryColor,
    icon: Icon(Icons.info_outline, size: 16, color: Colors.white),
    padding: contentPadding,
  );

  factory IconToastWidget.warning({
    String? msg,
    EdgeInsetsGeometry? contentPadding,
  }) => IconToastWidget(
    message: msg,
    assetName: 'assets/ic_fail.png',
    backgroundColor: const Color(0xf0ffec3d),
    color: AppColors.primaryColor,
    icon: Icon(Icons.info_outline, size: 16, color: AppColors.primaryColor),
    padding: contentPadding,
  );

  factory IconToastWidget.success({
    String? msg,
    EdgeInsetsGeometry? contentPadding,
  }) => IconToastWidget(
    message: msg,
    assetName: 'assets/ic_success.png',
    backgroundColor: const Color(0xf0a0d911),
    color: AppColors.primaryColor,
    icon: Icon(Icons.check_circle_outline, size: 16, color: Colors.white),
    padding: contentPadding,
  );

  @override
  State<StatefulWidget> createState() {
    return _IconToastWidgetState();
  }
}

class _IconToastWidgetState extends State<IconToastWidget>
    with TickerProviderStateMixin<IconToastWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Material(
      color: Colors.transparent,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 30),
        padding:
            widget.padding ??
            EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        decoration: ShapeDecoration(
          color: widget.backgroundColor ?? const Color(0x9F000000),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0.0),
              child: widget.icon,
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  widget.message ?? '',
                  style: AppTextStyles.regular12().copyWith(
                    color: Colors.white,
                    height: 1,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return content;
  }
}
