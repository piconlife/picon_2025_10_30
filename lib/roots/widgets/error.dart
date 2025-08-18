import 'package:flutter/material.dart';

import 'align.dart';
import 'button.dart';
import 'column.dart';
import 'icon.dart';
import 'padding.dart';
import 'text.dart';

enum InAppErrorType { internet, nullable }

class InAppErrorProperties<T extends Object?> {
  final T? internet;
  final T? nullable;

  const InAppErrorProperties({this.internet, this.nullable});

  const InAppErrorProperties.all(T? value)
    : this(internet: value, nullable: value);

  T? apply(InAppErrorType type, [InAppErrorProperties<T>? defaults]) {
    switch (type) {
      case InAppErrorType.internet:
        return internet ?? defaults?.internet;
      case InAppErrorType.nullable:
        return nullable ?? defaults?.nullable;
    }
  }
}

extension _Helper<T extends Object?> on InAppErrorProperties<T>? {
  InAppErrorProperties<T> get use => this ?? InAppErrorProperties();
}

class InAppError extends StatelessWidget {
  final InAppErrorType type;
  final InAppErrorProperties<Alignment>? alignment;
  final InAppErrorProperties<Color>? backgroundColor;
  final InAppErrorProperties<Widget>? body;
  final InAppErrorProperties<double>? titleSpacing;
  final InAppErrorProperties<String>? bodyText;
  final InAppErrorProperties<TextStyle>? bodyTextStyle;
  final InAppErrorProperties<Widget>? button;
  final InAppErrorProperties<double>? buttonMinWidth;
  final InAppErrorProperties<EdgeInsets>? buttonPadding;
  final InAppErrorProperties<double>? buttonSpacing;
  final InAppErrorProperties<String>? buttonText;
  final InAppErrorProperties<TextStyle>? buttonTextStyle;
  final InAppErrorProperties<Color>? foregroundColor;
  final InAppErrorProperties<Widget>? icon;
  final InAppErrorProperties<Color>? iconColor;
  final InAppErrorProperties<dynamic>? iconData;
  final InAppErrorProperties<double>? iconSize;
  final InAppErrorProperties<double>? iconSpacing;
  final InAppErrorProperties<EdgeInsets>? padding;
  final InAppErrorProperties<Widget>? title;
  final InAppErrorProperties<String>? titleText;
  final InAppErrorProperties<TextStyle>? titleTextStyle;
  final InAppErrorProperties<VoidCallback>? onRetry;

  const InAppError({
    super.key,
    required this.type,
    this.alignment,
    this.backgroundColor,
    this.body,
    this.titleSpacing,
    this.bodyText,
    this.bodyTextStyle,
    this.button,
    this.buttonMinWidth,
    this.buttonPadding,
    this.buttonSpacing,
    this.buttonText,
    this.buttonTextStyle,
    this.foregroundColor,
    this.icon,
    this.iconColor,
    this.iconData,
    this.iconSize,
    this.iconSpacing,
    this.padding,
    this.title,
    this.titleText,
    this.titleTextStyle,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final fc =
        foregroundColor?.apply(type) ??
        Theme.of(context).textTheme.bodyMedium?.color ??
        Colors.black;
    final bc = backgroundColor?.apply(type) ?? Theme.of(context).primaryColor;
    final padding = this.padding.use.apply(type);
    final bodyText = this.bodyText.use.apply(
      type,
      InAppErrorProperties(
        internet:
            "Your internet service has disconnected. Please confirm your internet connection.",
      ),
    );
    final bodyTextStyle = this.bodyTextStyle.use.apply(type) ?? TextStyle();
    final buttonPadding = this.buttonPadding.use.apply(type);
    final buttonText = this.buttonText.use.apply(
      type,
      InAppErrorProperties(internet: "Try again", nullable: "Refresh"),
    );
    final buttonTextStyle = this.buttonTextStyle.use.apply(type) ?? TextStyle();
    final iconData = this.iconData.use.apply(
      type,
      InAppErrorProperties(
        internet: "assets/icons/ic_network_error.svg",
        nullable: Icons.info_outline_rounded,
      ),
    );
    final titleText = this.titleText.use.apply(
      type,
      InAppErrorProperties(internet: "You are currently offline"),
    );
    final titleTextStyle = this.titleTextStyle.use.apply(type) ?? TextStyle();
    final onRetry = this.onRetry?.apply(type);
    return InAppAlign(
      alignment: alignment?.apply(type) ?? Alignment.center,
      child: InAppPadding(
        padding: (padding ?? EdgeInsets.zero).copyWith(
          left: padding?.left ?? 24,
          right: padding?.right ?? 24,
          top: padding?.top ?? 50,
          bottom: padding?.bottom ?? 50,
        ),
        child: InAppColumn(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null || iconData != null) ...[
              ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: 50,
                  minWidth: 50,
                  maxHeight: 250,
                  maxWidth: 250,
                ),
                child: FittedBox(
                  child:
                      icon?.apply(type) ??
                      InAppIcon(
                        iconData,
                        color:
                            iconColor?.apply(type) ??
                            fc.withValues(alpha: 0.15),
                        size: iconSize?.apply(type) ?? 85,
                      ),
                ),
              ),
              SizedBox(height: iconSpacing?.apply(type) ?? 24),
            ],
            if (title != null || (titleText ?? '').isNotEmpty) ...[
              title?.apply(type) ??
                  InAppText(
                    titleText,
                    textAlign: TextAlign.center,
                    style: titleTextStyle.copyWith(
                      fontWeight: titleTextStyle.fontWeight ?? FontWeight.w600,
                      fontSize: titleTextStyle.fontSize ?? 24,
                      color: titleTextStyle.color ?? fc,
                    ),
                  ),
              SizedBox(height: titleSpacing?.apply(type) ?? 8),
            ],
            if (body != null || (bodyText ?? '').isNotEmpty) ...[
              body?.apply(type) ??
                  InAppText(
                    bodyText,
                    textAlign: TextAlign.center,
                    style: bodyTextStyle.copyWith(
                      fontSize: bodyTextStyle.fontSize ?? 16,
                      color: bodyTextStyle.color ?? fc.withValues(alpha: 0.5),
                    ),
                  ),
            ],
            if (button != null ||
                (onRetry != null && (buttonText ?? '').isNotEmpty)) ...[
              SizedBox(height: buttonSpacing?.apply(type) ?? 24),
              button?.apply(type) ??
                  InAppButton(
                    text: buttonText,
                    onTap: onRetry,
                    backgroundColor: bc,
                    padding: (buttonPadding ?? EdgeInsets.zero).copyWith(
                      left: buttonPadding?.left ?? 24,
                      right: buttonPadding?.right ?? 24,
                      top: buttonPadding?.top ?? 12,
                      bottom: buttonPadding?.bottom ?? 12,
                    ),
                    minWidth: buttonMinWidth?.apply(type) ?? 180,
                    textStyle: buttonTextStyle.copyWith(
                      fontSize: buttonTextStyle.fontSize ?? 16,
                      color: buttonTextStyle.color ?? Colors.white,
                    ),
                  ),
            ],
          ],
        ),
      ),
    );
  }
}
