import 'package:flutter/material.dart';

class Marquee extends StatefulWidget {
  final AxisDirection direction;
  final double dimension;
  final Duration duration;
  final Widget child;

  const Marquee({
    super.key,
    this.direction = AxisDirection.left,
    required this.dimension,
    this.duration = const Duration(seconds: 5),
    required this.child,
  });

  @override
  State<Marquee> createState() => _MarqueeState();
}

class _MarqueeState extends State<Marquee> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  (double?, double?, double?, double?) get _x1 {
    final o = widget.direction;
    final d = widget.dimension;
    final x = _controller.value * d;
    final t = d - x;
    return (
      o == AxisDirection.left ? t : null,
      o == AxisDirection.right ? t : null,
      o == AxisDirection.up ? t : null,
      o == AxisDirection.down ? t : null,
    );
  }

  (double?, double?, double?, double?) get _x2 {
    final o = widget.direction;
    final d = widget.dimension;
    final x = _controller.value * d;
    final t = -x;
    return (
      o == AxisDirection.left ? t : null,
      o == AxisDirection.right ? t : null,
      o == AxisDirection.up ? t : null,
      o == AxisDirection.down ? t : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final a = _x1;
        final b = _x2;
        return Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: a.$1,
              right: a.$2,
              top: a.$3,
              bottom: a.$4,
              child: widget.child,
            ),
            Positioned(
              left: b.$1,
              right: b.$2,
              top: b.$3,
              bottom: b.$4,
              child: widget.child,
            ),
          ],
        );
      },
    );
  }
}
