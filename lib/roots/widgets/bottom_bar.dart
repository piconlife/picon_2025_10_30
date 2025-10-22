import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

import 'bottom.dart';
import 'padding.dart';

class InAppBottomBar extends StatelessWidget {
  final bool enabled;
  final Color? backgroundColor;
  final double elevation;
  final Color? elevationColor;
  final double? height;
  final bool ignoreBackgroundColor;
  final bool ignoreSystemPadding;
  final EdgeInsets padding;
  final double shadowBlurRadius;
  final Color? shadowColor;
  final Widget child;

  const InAppBottomBar({
    super.key,
    this.enabled = true,
    this.backgroundColor,
    this.elevation = 1,
    this.elevationColor,
    this.height,
    this.ignoreBackgroundColor = false,
    this.ignoreSystemPadding = false,
    this.padding = EdgeInsets.zero,
    this.shadowBlurRadius = 50,
    this.shadowColor,
    required this.child,
  });

  const InAppBottomBar.minimalist({
    super.key,
    this.enabled = true,
    this.backgroundColor,
    this.elevation = 0,
    this.elevationColor,
    this.height,
    this.ignoreBackgroundColor = true,
    this.ignoreSystemPadding = false,
    this.padding = EdgeInsets.zero,
    this.shadowBlurRadius = 0,
    this.shadowColor,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return const SizedBox();
    Widget child = this.child;
    if (height != null && height! > 0) {
      child = SizedBox(height: height, child: child);
    }
    if (padding != EdgeInsets.zero) {
      child = InAppPadding(
        padding: padding.copyWith(bottom: context.isBottom ? 0 : null),
        child: child,
      );
    }
    if (!ignoreSystemPadding) {
      child = InAppBottom(child: child);
    }
    if (!ignoreBackgroundColor || elevation > 0 || shadowBlurRadius > 0) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: backgroundColor ?? context.bottomColor.primary,
          border:
              elevation > 0
                  ? Border(
                    top: BorderSide(
                      color: elevationColor ?? context.grey.t25,
                      width: elevation,
                    ),
                  )
                  : null,
          boxShadow:
              shadowBlurRadius > 0
                  ? [
                    BoxShadow(
                      color: shadowColor ?? context.dark.t10,
                      blurRadius: shadowBlurRadius,
                    ),
                  ]
                  : null,
        ),
        child: child,
      );
    }
    return child;
  }
}
