import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'icon.dart';
import 'text.dart';

class InAppException extends StatelessWidget {
  final String? data;
  final String? title;
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final double? spaceBetween;
  final double? width;
  final double? minWidth;
  final double? height;
  final double? minHeight;
  final TextStyle style;
  final EdgeInsets iconAdjustment;

  const InAppException(
    this.data, {
    super.key,
    this.title,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.spaceBetween,
    this.width = double.infinity,
    this.height,
    this.minWidth,
    this.minHeight,
    this.style = const TextStyle(),
    this.iconAdjustment = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final color = context.dark;
    return Container(
      width: width,
      height: height,
      constraints: BoxConstraints(
        minHeight: minHeight ?? 0,
        minWidth: minWidth ?? 0,
      ),
      padding: EdgeInsets.all(dimen.dp(32)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) ...[
            Padding(
              padding: iconAdjustment,
              child: InAppIcon(
                icon,
                color: iconColor ?? color.t15,
                size: iconSize ?? dimen.dp(85),
              ),
            ),
            SizedBox(height: spaceBetween ?? dimen.dp(16)),
          ],
          if (title != null && title!.isNotEmpty) ...[
            InAppText(
              title,
              textAlign: TextAlign.center,
              style: style.copyWith(
                fontSize: style.fontSize ?? dimen.dp(16),
                color: (style.color ?? color.t75),
                fontWeight: style.fontWeight ?? FontWeight.w600,
              ),
            ),
            SizedBox(height: dimen.dp(4)),
          ],
          InAppText(
            data,
            textAlign: TextAlign.center,
            style: style.copyWith(
              fontSize: style.fontSize ?? dimen.dp(16),
              color: (style.color ?? color).t50,
            ),
          ),
        ],
      ),
    );
  }
}
