import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import 'will_pop_scope.dart';

enum ThemeType {
  primary,
  secondary,
  tertiary,
  error,
  warning,
  disable,
  light,
  lightAsFixed,
  dark,
  darkAsFixed,
  mid,
  holo,
  soft,
  deep;

  Color? colorOf(ThemeColors color) {
    switch (this) {
      case ThemeType.primary:
        return color.primary;
      case ThemeType.secondary:
        return color.secondary;
      case ThemeType.tertiary:
        return color.tertiary;
      case ThemeType.error:
        return color.error;
      case ThemeType.warning:
        return color.warning;
      case ThemeType.disable:
        return color.disable;
      case ThemeType.light:
        return color.light;
      case ThemeType.lightAsFixed:
        return color.lightAsFixed;
      case ThemeType.dark:
        return color.dark;
      case ThemeType.darkAsFixed:
        return color.darkAsFixed;
      case ThemeType.mid:
        return color.mid;
      case ThemeType.holo:
        return color.holo;
      case ThemeType.soft:
        return color.soft;
      case ThemeType.deep:
        return color.deep;
    }
  }

  Gradient? gradientOf(String id) {
    final gradient = ThemeGradients.of(id);
    switch (this) {
      case ThemeType.primary:
        return gradient.primary;
      case ThemeType.secondary:
        return gradient.secondary;
      case ThemeType.tertiary:
        return gradient.tertiary;
      case ThemeType.error:
        return gradient.error;
      case ThemeType.warning:
        return gradient.warning;
      case ThemeType.disable:
        return gradient.disable;
      case ThemeType.light:
        return gradient.light;
      case ThemeType.lightAsFixed:
        return gradient.lightAsFixed;
      case ThemeType.dark:
        return gradient.dark;
      case ThemeType.darkAsFixed:
        return gradient.darkAsFixed;
      case ThemeType.mid:
        return gradient.mid;
      case ThemeType.holo:
        return gradient.holo;
      case ThemeType.soft:
        return gradient.soft;
      case ThemeType.deep:
        return gradient.deep;
    }
  }
}

class InAppScreen extends StatelessWidget {
  final bool enabled;
  final List<double>? stops;
  final Gradient? gradient;
  final InAppWillPopCallback? onWillPop;
  final bool useBackground;
  final bool unfocusMode;
  final ThemeType theme;
  final Widget child;

  const InAppScreen({
    super.key,
    this.enabled = true,
    this.useBackground = true,
    this.unfocusMode = false,
    this.gradient,
    required this.child,
    this.onWillPop,
    this.theme = ThemeType.primary,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return this.child;
    Widget child = this.child;
    if (useBackground) {
      child = DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorOf(context.scaffoldColor),
          gradient: theme.gradientOf("scaffold"),
        ),
        child: child,
      );
    }
    if (unfocusMode) {
      child = GestureDetector(
        child: child,
        onTap: () => FocusScope.of(context).unfocus(),
      );
    }
    if (onWillPop != null) {
      child = InAppWillPopScope(onWillPop: onWillPop, child: child);
    }
    return child;
  }
}
