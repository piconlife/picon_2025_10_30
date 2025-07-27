import 'package:flutter/material.dart';

class InAppSemantics extends StatelessWidget {
  final Widget child;

  const InAppSemantics({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(border: Border.all(color: Colors.red)),
      child: child,
    );
  }
}
