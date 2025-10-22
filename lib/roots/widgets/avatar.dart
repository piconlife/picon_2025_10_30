import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/res/placeholders.dart';

class InAppAvatar extends StatelessWidget {
  final dynamic data;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderSize;
  final Color? shadowColor;
  final double shadowRadius;
  final double fadeLowerBound;
  final double fadeUpperBound;
  final double scalerLowerBound;
  final double scalerUpperBound;
  final VoidCallback? onTap;

  const InAppAvatar(
    this.data, {
    super.key,
    this.size = 40,
    this.backgroundColor,
    this.borderColor,
    this.borderSize = 0,
    this.shadowColor,
    this.shadowRadius = 5,
    this.scalerLowerBound = 0.95,
    this.scalerUpperBound = 1.0,
    this.fadeUpperBound = 1.0,
    this.fadeLowerBound = 0.75,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyGesture(
      clickEffect: AndrossyGestureEffect(
        primary:
            scalerLowerBound < 1
                ? AndrossyGestureAnimation.scale(
                  lowerBound: scalerLowerBound,
                  upperBound: scalerUpperBound,
                )
                : null,
        secondary:
            fadeLowerBound < 1
                ? AndrossyGestureAnimation.fade(
                  lowerBound: fadeLowerBound,
                  upperBound: fadeUpperBound,
                )
                : null,
      ),
      onTap: onTap,
      child: AndrossyAvatar(
        data ?? InAppPlaceholders.user,
        size: size,
        backgroundColor:
            backgroundColor ??
            (context.isDarkMode ? context.mid.shade(.5) : context.mid.tint(.5)),
        border:
            borderSize > 0
                ? Border.all(
                  color: borderColor ?? context.dark,
                  width: borderSize,
                )
                : null,
        shadow: BoxShadow(
          color:
              shadowColor ?? context.shadowColor.primary ?? Colors.transparent,
          blurRadius: shadowRadius,
        ),
      ),
    );
  }
}
