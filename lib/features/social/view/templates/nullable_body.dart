import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/button.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';

class InAppNullableBody extends StatelessWidget {
  final EdgeInsets? contentPadding;
  final double? contentSpacing;
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final double? iconSpacing;
  final TextStyle headerStyle;
  final TextStyle bodyStyle;
  final String? header;
  final double? headerSpacing;
  final String? body;
  final String? bodySpacing;
  final Color? buttonColor;
  final double? buttonWidth;
  final double? buttonHeight;
  final double? buttonSpacing;
  final String? buttonText;
  final TextStyle buttonTextStyle;
  final VoidCallback? onButtonClick;

  const InAppNullableBody({
    super.key,
    this.contentPadding,
    this.contentSpacing,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.iconSpacing,
    this.header,
    this.headerSpacing,
    this.headerStyle = const TextStyle(),
    this.body,
    this.bodySpacing,
    this.bodyStyle = const TextStyle(),
    this.buttonColor,
    this.buttonHeight,
    this.buttonWidth,
    this.buttonSpacing,
    this.buttonText,
    this.buttonTextStyle = const TextStyle(),
    this.onButtonClick,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dark = context.dark;
    final dimen = context.dimens;
    final spacing = contentSpacing ?? dimen.dp(12);
    return SingleChildScrollView(
      padding: contentPadding ?? EdgeInsets.symmetric(vertical: dimen.dp(50)),
      child: InAppColumn(
        children: [
          if (icon != null) ...[
            InAppIcon(
              icon,
              size: iconSize ?? dimen.dp(60),
              color: iconColor ?? primary,
            ),
            if ((header ?? body ?? buttonText ?? '').isNotEmpty)
              SizedBox(height: iconSpacing ?? spacing * 1.5),
          ],
          if ((header ?? '').isNotEmpty)
            InAppText(
              header,
              textAlign: TextAlign.center,
              style: headerStyle.copyWith(
                fontWeight: headerStyle.fontWeight ?? FontWeight.w500,
                color: headerStyle.color ?? dark,
                fontSize: headerStyle.fontSize ?? dimen.dp(24),
              ),
            ),
          if ((body ?? '').isNotEmpty) ...[
            if ((header ?? '').isNotEmpty)
              SizedBox(height: buttonSpacing ?? spacing),
            InAppText(
              body,
              textAlign: TextAlign.center,
              style: bodyStyle.copyWith(
                color: bodyStyle.color ?? context.dark.t50,
                fontSize: bodyStyle.fontSize ?? dimen.dp(16),
              ),
            ),
          ],
          if ((buttonText ?? '').isNotEmpty) ...[
            if ((header ?? body ?? '').isNotEmpty)
              SizedBox(height: buttonSpacing ?? spacing * 3),
            Center(
              child: InAppButton(
                backgroundColor: buttonColor ?? primary,
                minWidth: buttonWidth ?? dimen.dp(180),
                height: buttonHeight ?? dimen.dp(45),
                onTap: onButtonClick,
                text: buttonText,
                textStyle: buttonTextStyle.copyWith(
                  fontSize: buttonTextStyle.fontSize ?? dimen.dp(16),
                  fontWeight: buttonTextStyle.fontWeight ?? FontWeight.w600,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
