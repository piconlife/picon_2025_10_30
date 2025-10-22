import 'package:flutter/material.dart';
import 'package:in_app_translation/in_app_translation.dart';

class InAppPositioned extends StatelessWidget {
  final double? left;
  final double? top;
  final double? right;
  final double? bottom;
  final double? width;
  final double? height;
  final Widget child;

  const InAppPositioned({
    super.key,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.width,
    this.height,
    required this.child,
  });

  const InAppPositioned.fill({
    super.key,
    this.left = 0.0,
    this.top = 0.0,
    this.right = 0.0,
    this.bottom = 0.0,
    required this.child,
  }) : width = null,
       height = null;

  @override
  Widget build(BuildContext context) {
    return Positioned.directional(
      textDirection: Translation.textDirection,
      start: left,
      end: right,
      top: top,
      bottom: bottom,
      width: width,
      height: height,
      child: child,
    );
  }
}
