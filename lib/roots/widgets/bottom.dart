import 'package:flutter/material.dart';

class InAppBottom extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const InAppBottom({super.key, this.enabled = true, required this.child});

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.maybePaddingOf(context)?.bottom;
    if (bottom == null || bottom <= 0) return child;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
