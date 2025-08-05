import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets/fade.dart';

class InAppFade extends StatelessWidget {
  final double fadeWidthFraction;
  final FadeSide side;
  final Widget child;

  const InAppFade({
    super.key,
    this.fadeWidthFraction = 0.1,
    this.side = FadeSide.vertical,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AndrossyFade(
      fadeWidthFraction: fadeWidthFraction,
      side: side,
      child: child,
    );
  }
}
