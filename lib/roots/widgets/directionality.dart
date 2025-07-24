import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppDirectionality extends StatelessWidget {
  final bool isForce;
  final Widget child;

  const InAppDirectionality({
    super.key,
    required this.child,
    this.isForce = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isForce) {
      return Transform.flip(
        flipX: Translation.textDirection == TextDirection.rtl,
        child: child,
      );
    }
    return Directionality(
      textDirection: Translation.textDirection,
      child: child,
    );
  }
}
