import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../app/styles/fonts.dart';

class InAppTextButton extends StatefulWidget {
  final String data;
  final bool enabled;
  final bool activated;
  final bool textAllCaps;
  final double? width;
  final double? height;
  final TextStyle style;
  final Color? foregroundColor;
  final Color? backgroundColor;
  final Color? splashColor;
  final Color? highlightColor;
  final Color? hoverColor;
  final BorderRadius borderRadius;
  final AndrossyButtonProperty<Color> borderColor;
  final double borderWidth;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  const InAppTextButton(
    this.data, {
    super.key,
    this.enabled = true,
    this.activated = false,
    this.textAllCaps = false,
    this.borderRadius = BorderRadius.zero,
    this.foregroundColor,
    this.backgroundColor,
    this.borderColor = const AndrossyButtonProperty(),
    this.borderWidth = 0,
    this.splashColor,
    this.highlightColor,
    this.hoverColor,
    this.style = const TextStyle(),
    this.onTap,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
  });

  @override
  State<InAppTextButton> createState() => InAppTextButtonState();
}

class InAppTextButtonState extends State<InAppTextButton> {
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
  void didUpdateWidget(covariant InAppTextButton oldWidget) {
    activated = widget.activated;
    enabled = widget.enabled;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final foregroundColor = widget.foregroundColor ?? context.primary;
    return AndrossyButton(
      loading: loading,
      enabled: enabled,
      activated: activated,
      borderRadius: widget.borderRadius,
      text: widget.data,
      textAllCaps: widget.textAllCaps,
      width: widget.width,
      height: widget.height,
      splashColor: widget.splashColor ?? foregroundColor.t02,
      highlightColor: widget.highlightColor ?? foregroundColor.t05,
      hoverColor: widget.hoverColor ?? foregroundColor.t05,
      textStyle: widget.style.copyWith(
        fontFamily: widget.style.fontFamily ?? InAppFonts.secondary,
        color: widget.style.color ?? foregroundColor,
      ),
      backgroundColor: AndrossyButtonProperty(
        enabled: widget.backgroundColor ?? Colors.transparent,
      ),
      borderColor: widget.borderColor,
      borderWidth: widget.borderWidth,
      clickEffect: const AndrossyGestureEffect(
        secondary: AndrossyGestureAnimation.fade(),
      ),
      padding: widget.padding,
      onTap: widget.onTap,
    );
  }
}
