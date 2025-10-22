import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/styles/fonts.dart';

class InAppFilledButton extends StatefulWidget {
  final bool enabled;
  final bool activated;
  final double? width;
  final double? height;
  final String text;
  final TextStyle textStyle;
  final dynamic icon;
  final Color? background;
  final Color? disabledBackgroundColor;
  final Color? disabledTextColor;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const InAppFilledButton({
    super.key,
    this.enabled = true,
    this.activated = false,
    this.borderRadius,
    this.background,
    this.disabledBackgroundColor,
    this.disabledTextColor,
    this.icon,
    this.text = "",
    this.textStyle = const TextStyle(),
    this.onTap,
    this.width = double.infinity,
    this.height = 50,
  });

  @override
  State<InAppFilledButton> createState() => InAppFilledButtonState();
}

class InAppFilledButtonState extends State<InAppFilledButton> {
  late bool enabled = widget.enabled;
  late bool activated = widget.activated;
  bool loading = false;

  void setEnabled(bool value) {
    if (value == enabled) return;
    setState(() => enabled = value);
  }

  void setActivated(bool value) {
    if (value == activated) return;
    setState(() => activated = value);
  }

  void showLoading() => setLoading(true);

  void hideLoading() => setLoading(false);

  void setLoading(bool value) {
    if (value == loading) return;
    setState(() {
      enabled = !value;
      loading = value;
    });
  }

  @override
  void didUpdateWidget(covariant InAppFilledButton oldWidget) {
    activated = widget.activated;
    enabled = widget.enabled;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "primary_button",
      child: AndrossyButton(
        loading: loading,
        enabled: enabled && widget.onTap != null,
        activated: activated,
        icon: widget.icon,
        iconColor: AndrossyButtonProperty.all(
          widget.textStyle.color ?? Colors.grey,
        ),
        centerText: widget.icon != null,
        padding:
            widget.icon != null
                ? EdgeInsets.symmetric(horizontal: 24)
                : EdgeInsets.all(8),
        iconOrIndicatorFlexible: widget.icon != null,
        borderRadius: widget.borderRadius ?? BorderRadius.circular(50),
        text: widget.text,
        width: widget.width,
        height: widget.height,
        textStyle: widget.textStyle.copyWith(
          fontFamily: widget.textStyle.fontFamily ?? InAppFonts.secondary,
          fontSize: widget.textStyle.fontSize ?? 16,
          fontWeight: widget.textStyle.fontWeight ?? FontWeight.w600,
        ),
        backgroundColor: AndrossyButtonProperty(
          disabled: widget.disabledBackgroundColor,
          enabled: widget.background ?? context.primary,
        ),
        textColor: AndrossyButtonProperty(
          enabled: widget.textStyle.color,
          disabled: widget.disabledTextColor,
        ),
        clickEffect: const AndrossyGestureEffect(
          primary: AndrossyGestureAnimation.scale(),
          secondary: AndrossyGestureAnimation.fade(),
        ),
        onTap: widget.onTap,
      ),
    );
  }
}
