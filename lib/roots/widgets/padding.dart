import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppPadding extends StatelessWidget {
  final EdgeInsets padding;
  final Widget child;

  const InAppPadding({super.key, required this.padding, required this.child});

  @override
  Widget build(BuildContext context) {
    if (padding == EdgeInsets.zero) return child;
    final isRtl = Translation.textDirection == TextDirection.rtl;
    return Padding(
      padding: EdgeInsets.only(
        left: isRtl ? padding.right : padding.left,
        right: isRtl ? padding.left : padding.right,
        top: padding.top,
        bottom: padding.bottom,
      ),
      child: child,
    );
  }
}
