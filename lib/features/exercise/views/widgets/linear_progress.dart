import 'package:flutter/material.dart';

class LinearShaderMask extends StatelessWidget {
  final TextDirection textDirection;
  final double progress;
  final Color progressColor;
  final Color remainingColor;
  final Widget child;

  const LinearShaderMask({
    super.key,
    required this.progress,
    this.progressColor = Colors.blue,
    this.remainingColor = Colors.grey,
    this.textDirection = TextDirection.ltr,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isLtr = textDirection == TextDirection.ltr;
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          begin: isLtr ? Alignment.centerLeft : Alignment.centerRight,
          end: isLtr ? Alignment.centerRight : Alignment.centerLeft,
          colors: [progressColor, remainingColor],
          stops: [progress, progress],
        ).createShader(bounds);
      },
      blendMode: BlendMode.srcIn,
      child: child,
    );
  }
}
