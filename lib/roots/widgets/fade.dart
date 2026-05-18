import 'package:flutter/material.dart';

import '../../packages/imports.dart' show FadeSide, AndrossyFade;

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
