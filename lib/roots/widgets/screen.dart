import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';

import 'will_pop_scope.dart';

class InAppScreen extends StatelessWidget {
  final bool enabled;
  final List<double>? stops;
  final Gradient? gradient;
  final InAppWillPopCallback? onWillPop;
  final bool useBackground;
  final bool unfocusMode;
  final Widget child;

  const InAppScreen({
    super.key,
    this.enabled = true,
    this.useBackground = true,
    this.unfocusMode = false,
    this.gradient,
    required this.child,
    this.onWillPop,
    this.stops,
  });

  @override
  Widget build(BuildContext context) {
    if (!enabled) return this.child;
    Widget child = this.child;
    if (useBackground) {
      child = DecoratedBox(
        decoration: BoxDecoration(color: context.scaffoldColor.primary),
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
