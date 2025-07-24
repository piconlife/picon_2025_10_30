import 'package:flutter/material.dart';

import 'text.dart';

class InAppTitledBody extends StatelessWidget {
  final String? data;
  final TextStyle? style;
  final double spaceBetween;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? child;

  const InAppTitledBody(
    this.data, {
    super.key,
    this.style = const TextStyle(fontSize: 16),
    this.spaceBetween = 4,
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final title = InAppText(data, style: style);
    if (child == null) return title;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: crossAxisAlignment,
      children: [
        title,
        SizedBox(height: spaceBetween),
        child!,
      ],
    );
  }
}
