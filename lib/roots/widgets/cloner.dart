import 'package:flutter/material.dart';

import 'image.dart';

class InAppCloner extends StatelessWidget {
  final String data;
  final double opacity;
  final Widget child;

  const InAppCloner({
    super.key,
    required this.data,
    this.opacity = 0.5,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    if (opacity == 1) return child;
    return Stack(
      fit: StackFit.expand,
      children: [
        InAppImage(data),
        Opacity(opacity: opacity, child: child),
      ],
    );
  }
}
