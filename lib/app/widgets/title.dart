import 'package:flutter/material.dart';

import '../../roots/widgets/text.dart';

class InAppTitle extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const InAppTitle(this.text, {super.key, this.style});

  @override
  Widget build(BuildContext context) {
    return InAppText(
      text,
      style: (style ?? TextStyle()).copyWith(fontSize: style?.fontSize ?? 18),
    );
  }
}
