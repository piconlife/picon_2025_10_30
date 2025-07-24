import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class InAppDialogTitle extends StatelessWidget {
  final String text;

  const InAppDialogTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return InAppText(
      text,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }
}
