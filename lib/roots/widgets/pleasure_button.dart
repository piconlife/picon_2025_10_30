import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppPleasureButton extends StatelessWidget {
  final dynamic icon;
  final Color? iconColor;
  final double? iconSize;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final Duration duration;
  final VoidCallback? onTap;

  const InAppPleasureButton({
    super.key,
    this.icon,
    this.iconColor,
    this.iconSize,
    this.backgroundColor,
    this.borderRadius = BorderRadius.zero,
    this.duration = const Duration(milliseconds: 200),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyButton(
      borderRadius: borderRadius,
      backgroundColor: AndrossyButtonProperty.all(
        backgroundColor ?? Colors.transparent,
      ),
      onTap: onTap != null
          ? () {
              Future.delayed(duration).whenComplete(() {
                if (context.mounted) onTap!();
              });
            }
          : null,
      clickEffect: AndrossyGestureEffect.scale(
        lowerBound: 0,
        duration: duration,
      ),
      icon: icon,
      iconColor: AndrossyButtonProperty.all(iconColor ?? Colors.grey),
      iconSize: iconSize ?? 24,
    );
  }
}
