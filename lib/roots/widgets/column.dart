import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppColumn extends StatelessWidget {
  final MainAxisSize mainAxisSize;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final double spacing;
  final TextDirection? textDirection;
  final TextBaseline? textBaseline;
  final VerticalDirection verticalDirection;
  final List<Widget> children;

  const InAppColumn({
    super.key,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.mainAxisSize = MainAxisSize.max,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.textDirection,
    this.verticalDirection = VerticalDirection.down,
    this.textBaseline,
    this.spacing = 0.0,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      textDirection: Translation.textDirection,
      mainAxisSize: mainAxisSize,
      mainAxisAlignment: mainAxisAlignment,
      spacing: spacing,
      textBaseline: textBaseline,
      verticalDirection: verticalDirection,
      crossAxisAlignment: crossAxisAlignment,
      children: children,
    );
  }
}
