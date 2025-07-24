import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppToggle extends StatefulWidget {
  final bool enabled;
  final bool activated;
  final Selector<Color>? backgroundColor;
  final Duration duration;
  final double elevation;
  final bool enableFeedback;
  final double fadeLowerBound;
  final double fadeUpperBound;
  final Selector<Color>? highlightColor;
  final Color? hoverColor;
  final MouseCursor? mouseCursor;
  final double scalerLowerBound;
  final double scalerUpperBound;
  final ShapeBorder? shape;
  final Selector<Color>? splashColor;
  final BorderRadius? splashBorderRadius;
  final InteractiveInkFeatureFactory? splashFactory;
  final WidgetStateProperty<Color?>? overlayColor;
  final ValueChanged<bool>? onChanged;
  final Widget Function(BuildContext context, bool value) builder;

  const InAppToggle({
    super.key,
    this.backgroundColor,
    this.elevation = 0,
    this.onChanged,
    this.enabled = true,
    this.activated = false,
    this.enableFeedback = true,
    this.fadeUpperBound = 1.0,
    this.fadeLowerBound = 0.75,
    this.highlightColor,
    this.hoverColor,
    this.mouseCursor,
    this.scalerLowerBound = 0.95,
    this.scalerUpperBound = 1.0,
    this.splashColor,
    this.splashBorderRadius,
    this.splashFactory,
    this.overlayColor,
    this.shape,
    required this.builder,
    this.duration = const Duration(milliseconds: 130),
  });

  @override
  State<InAppToggle> createState() => _InAppToggleState();
}

class _InAppToggleState extends State<InAppToggle> {
  late bool activated = widget.activated;

  @override
  void didUpdateWidget(covariant InAppToggle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (activated != oldWidget.activated) {
      activated = widget.activated;
    }
  }

  void _change() {
    setState(() {
      activated = !activated;
      if (widget.onChanged != null) widget.onChanged!(activated);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AndrossyGesture(
      enabled: widget.enabled,
      backgroundColor: widget.backgroundColor?.select(
        activated,
        disabled: widget.enabled,
      ),
      elevation: widget.elevation,
      highlightColor: widget.highlightColor?.select(
        activated,
        disabled: widget.enabled,
      ),
      hoverColor: widget.hoverColor,
      mouseCursor: widget.mouseCursor,
      shape: widget.shape,
      splashColor: widget.splashColor?.select(
        activated,
        disabled: widget.enabled,
      ),
      splashFactory: widget.splashFactory,
      borderRadius: widget.splashBorderRadius,
      overlayColor: widget.overlayColor,
      clickEffect: AndrossyGestureEffect(
        primary: AndrossyGestureAnimation.scale(
          lowerBound: widget.scalerLowerBound,
          upperBound: widget.scalerUpperBound,
          duration: widget.duration,
        ),
        secondary: AndrossyGestureAnimation.fade(
          lowerBound: widget.fadeLowerBound,
          upperBound: widget.fadeUpperBound,
          duration: widget.duration,
        ),
      ),
      enableFeedback: widget.enableFeedback,
      onTap: _change,
      child: widget.builder(context, activated),
    );
  }
}
