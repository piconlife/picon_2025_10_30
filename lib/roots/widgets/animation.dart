import 'package:flutter/material.dart';

typedef AnimationBuilder =
    Widget Function(
      BuildContext context,
      Animation<double> animation,
      Widget? child,
    );

class InAppAnimation extends StatefulWidget {
  final bool enabled;
  final bool repeat;
  final Duration duration;
  final Duration? reverseDuration;
  final double initial;
  final double upperBound;
  final double lowerBound;
  final Curve curve;
  final AnimationBuilder builder;
  final Widget? child;

  const InAppAnimation({
    super.key,
    this.enabled = true,
    this.repeat = true,
    this.duration = const Duration(milliseconds: 700),
    this.reverseDuration,
    this.initial = 1.0,
    this.upperBound = 1.0,
    this.lowerBound = 0.95,
    this.curve = Curves.easeIn,
    required this.builder,
    this.child,
  });

  @override
  State<InAppAnimation> createState() => _InAppAnimationState();
}

class _InAppAnimationState extends State<InAppAnimation>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  void _init() {
    if (!widget.enabled) return;
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: widget.reverseDuration ?? widget.duration,
      value: widget.initial,
      upperBound: widget.upperBound,
      lowerBound: widget.lowerBound,
    )..repeat(reverse: widget.repeat);
    _animation = CurvedAnimation(parent: _controller, curve: widget.curve);
  }

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void didUpdateWidget(covariant InAppAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled != oldWidget.enabled ||
        widget.repeat != oldWidget.repeat ||
        widget.duration != oldWidget.duration ||
        widget.reverseDuration != oldWidget.reverseDuration ||
        widget.upperBound != oldWidget.upperBound ||
        widget.lowerBound != oldWidget.lowerBound ||
        widget.curve != oldWidget.curve) {
      if (oldWidget.enabled) _controller.dispose();
      _init();
    }
  }

  @override
  void dispose() {
    if (widget.enabled) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: widget.builder(context, _animation, widget.child),
    );
  }
}
