import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../utils/haptic.dart';

class InAppGesture extends StatelessWidget {
  final bool enabled;
  final Color? backgroundColor;
  final Widget child;
  final Duration duration;
  final double elevation;
  final bool enableFeedback;
  final double fadeLowerBound;
  final double fadeUpperBound;
  final Color? highlightColor;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;
  final double scalerLowerBound;
  final double scalerUpperBound;
  final ShapeBorder? shape;
  final Color? splashColor;
  final BorderRadius? splashBorderRadius;
  final InteractiveInkFeatureFactory? splashFactory;
  final WidgetStateProperty<Color?>? overlayColor;
  final VoidCallback? onTap;

  const InAppGesture({
    super.key,
    this.backgroundColor,
    this.elevation = 0,
    this.onTap,
    this.enabled = true,
    this.enableFeedback = true,
    this.fadeUpperBound = 1.0,
    this.fadeLowerBound = 0.75,
    this.highlightColor,
    this.hoverColor,
    this.mouseCursor,
    this.scalerLowerBound = 0.95,
    this.scalerUpperBound = 1.0,
    this.shape,
    this.splashColor,
    this.splashBorderRadius,
    this.splashFactory,
    this.overlayColor,
    required this.child,
    this.duration = const Duration(milliseconds: 130),
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyGesture(
      enabled: enabled,
      backgroundColor: backgroundColor,
      elevation: elevation,
      highlightColor: highlightColor,
      hoverColor: hoverColor,
      mouseCursor: mouseCursor,
      shape: shape,
      splashColor: splashColor,
      splashFactory: splashFactory,
      borderRadius: splashBorderRadius,
      overlayColor: overlayColor,
      clickEffect: AndrossyGestureEffect(
        primary: AndrossyGestureAnimation.scale(
          lowerBound: scalerLowerBound,
          upperBound: scalerUpperBound,
          duration: duration,
        ),
        secondary: AndrossyGestureAnimation.fade(
          lowerBound: fadeLowerBound,
          upperBound: fadeUpperBound,
          duration: duration,
        ),
      ),
      enableFeedback: false,
      onTap:
          onTap != null
              ? () {
                onTap!();
                Haptics.light();
              }
              : null,
      child: child,
    );
  }
}
