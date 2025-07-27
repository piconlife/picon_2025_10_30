import 'package:flutter/material.dart';

import '../views/linear_layout/view.dart';
import '../views/view/view.dart' show OnViewClickListener;

class SettingTile extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? content;
  final Widget? leading;
  final Widget? tailing;
  final Widget? subscription;
  final Color? background;
  final Color? pressedColor;
  final Color? rippleColor;
  final EdgeInsets padding;
  final OnViewClickListener? onClick;

  const SettingTile({
    super.key,
    this.header,
    this.body,
    this.content,
    this.leading,
    this.tailing,
    this.subscription,
    this.background,
    this.rippleColor,
    this.pressedColor,
    this.padding = const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 12,
    ),
    this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return LinearLayout(
      background: background,
      orientation: Axis.horizontal,
      crossGravity: CrossAxisAlignment.center,
      paddingTop: padding.top,
      paddingBottom: padding.bottom,
      paddingStart: padding.left,
      paddingEnd: padding.right,
      pressedColor: pressedColor ?? Colors.black.withOpacity(0.05),
      rippleColor: rippleColor ?? Colors.black.withOpacity(0.05),
      onClick: onClick,
      children: [
        if (leading != null) leading!,
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (header != null) header!,
              if (body != null) body!,
            ],
          ),
        ),
        if (content != null) content!,
        if (tailing != null) tailing!,
      ],
    );
  }
}
