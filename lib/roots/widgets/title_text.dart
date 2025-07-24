import 'package:flutter/material.dart';

import 'text.dart';

class InAppTitleText extends StatelessWidget {
  final String? data;
  final TextStyle? style;

  const InAppTitleText(
    this.data, {
    super.key,
    this.style = const TextStyle(fontSize: 16),
  });

  @override
  Widget build(BuildContext context) {
    return InAppText(data, style: style);
  }
}
