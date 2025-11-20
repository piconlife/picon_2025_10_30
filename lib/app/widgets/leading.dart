import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/route.dart';

import '../../roots/widgets/gesture.dart';
import '../../roots/widgets/icon.dart';
import '../res/icons.dart';

class InAppLeading extends StatelessWidget {
  final dynamic icon;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Color? color;
  final Widget? child;
  final VoidCallback? onTap;

  const InAppLeading({
    super.key,
    this.child,
    this.icon,
    this.borderRadius,
    this.backgroundColor,
    this.highlightColor,
    this.splashColor,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) return SizedBox();
    return Center(
      child: InAppGesture(
        onTap: onTap ?? context.close,
        splashColor: splashColor ?? Colors.transparent,
        highlightColor: highlightColor ?? context.dark.t05,
        backgroundColor: backgroundColor ?? Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: borderRadius ?? BorderRadius.circular(10),
        ),
        child: ColoredBox(
          color: Colors.transparent,
          child: SizedBox.square(
            dimension: 40,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: InAppIcon(
                icon ?? InAppIcons.leading.regular,
                color: color ?? context.dark.t95,
                flipByTextDirection: true,
                size: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
