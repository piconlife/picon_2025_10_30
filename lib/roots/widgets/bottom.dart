import 'package:flutter/material.dart';

class InAppBottom extends StatelessWidget {
  final Widget child;

  const InAppBottom({super.key, required this.child});

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

extension BottomPaddingHelper on BuildContext {
  EdgeInsets get _ => MediaQuery.maybePaddingOf(this) ?? EdgeInsets.zero;

  bool get isBottom => _.bottom > 0;
}
