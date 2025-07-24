import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppIconButton extends StatelessWidget {
  final dynamic data;
  final double size;
  final bool loading;
  final bool enabled;
  final bool activated;
  final Color? primaryColor;
  final Color? activatedColor;
  final Color? disableColor;
  final BorderRadius? borderRadius;
  final double iconScale;
  final Color? iconColor;
  final Color? activatedIconColor;
  final AndrossyGestureEffect? effect;
  final VoidCallback? onTap;

  const InAppIconButton(
    this.data, {
    super.key,
    this.size = 40,
    this.loading = false,
    this.enabled = true,
    this.activated = false,
    this.iconColor,
    this.iconScale = 1,
    this.activatedIconColor,
    this.primaryColor,
    this.activatedColor,
    this.disableColor,
    this.borderRadius,
    this.effect,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyButton(
      width: size,
      height: size,
      iconSize: size * 0.5 * iconScale,
      indicatorSize: size * 0.8,
      loading: loading,
      activated: activated,
      enabled: enabled,
      primary: primaryColor ?? context.primary,
      borderRadius: borderRadius ?? BorderRadius.circular(size),
      backgroundColor: AndrossyButtonProperty(
        disabled: disableColor,
        activated: activatedColor,
      ),
      clickEffect: effect ?? AndrossyGestureEffect.scale(),
      indicatorColor: AndrossyButtonProperty.all(Colors.white),
      icon: data,
      iconColor: AndrossyButtonProperty(
        enabled: iconColor,
        activated: activatedIconColor,
      ),
      onTap: onTap,
    );
  }
}
