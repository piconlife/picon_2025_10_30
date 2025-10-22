import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/styles/fonts.dart';

class InAppButton extends StatelessWidget {
  final Color? backgroundColor;
  final Duration duration;
  final double elevation;
  final Color? elevationColor;
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
  final BorderRadius? borderRadius;
  final InteractiveInkFeatureFactory? splashFactory;
  final WidgetStateProperty<Color?>? overlayColor;
  final VoidCallback? onTap;
  final ValueChanged<bool>? onToggle;

  final double? width;
  final double? height;
  final double? minWidth;
  final double? minHeight;
  final EdgeInsets padding;
  final dynamic icon;
  final String? text;
  final bool textAllCaps;
  final TextStyle? textStyle;

  const InAppButton({
    super.key,
    this.backgroundColor,
    this.elevation = 0,
    this.elevationColor,
    this.onTap,
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
    this.borderRadius,
    this.splashFactory,
    this.overlayColor,
    this.duration = const Duration(milliseconds: 130),
    this.icon,
    this.text,
    this.textAllCaps = false,
    this.textStyle,
    this.width,
    this.height,
    this.minWidth,
    this.minHeight,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyButton(
      width: width,
      height: height,
      textAllCaps: textAllCaps,
      constraints:
          (minWidth ?? minHeight ?? 0) > 0
              ? BoxConstraints(
                minHeight: minHeight ?? 0,
                minWidth: minWidth ?? 0,
              )
              : null,
      backgroundColor: AndrossyButtonProperty.all(
        backgroundColor ?? context.primary,
      ),
      elevation: elevation,
      elevationColor: elevationColor,
      highlightColor: highlightColor,
      hoverColor: hoverColor,
      mouseCursor: mouseCursor,
      splashColor: splashColor,
      splashFactory: splashFactory,
      borderRadius: borderRadius,
      overlayColor: overlayColor,
      padding: padding,
      clickEffect: AndrossyGestureEffect(
        primary:
            scalerLowerBound < 1
                ? AndrossyGestureAnimation.scale(
                  lowerBound: scalerLowerBound,
                  upperBound: scalerUpperBound,
                  duration: duration,
                )
                : null,
        secondary:
            fadeLowerBound < 1
                ? AndrossyGestureAnimation.fade(
                  lowerBound: fadeLowerBound,
                  upperBound: fadeUpperBound,
                  duration: duration,
                )
                : null,
      ),
      text: text,
      textStyle: (textStyle ?? TextStyle()).copyWith(
        fontFamily: textStyle?.fontFamily ?? InAppFonts.primary,
      ),
      icon: icon,
      iconColor: AndrossyButtonProperty(enabled: textStyle?.color),
      iconOrIndicatorAlignment: IconAlignment.end,
      iconOrIndicatorFlexible: true,
      centerText: true,
      enableFeedback: enableFeedback,
      onTap: onTap,
      onToggle: onToggle,
    );
  }
}
