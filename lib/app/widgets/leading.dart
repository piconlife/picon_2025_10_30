import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../roots/widgets/gesture.dart';
import '../../roots/widgets/icon.dart';
import '../res/icons.dart';

class InAppLeading extends StatelessWidget {
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final Color? highlightColor;
  final Color? splashColor;
  final Widget? child;
  final VoidCallback? onTap;

  const InAppLeading({
    super.key,
    this.child,
    this.borderRadius,
    this.backgroundColor,
    this.highlightColor,
    this.splashColor,
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
                InAppIcons.leading.regular,
                color: context.dark.t95,
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
