import 'package:flutter/material.dart';

import '../../app/res/logo.dart';
import 'image.dart';

class InAppLogo extends StatelessWidget {
  final double? size;
  final bool hero;

  const InAppLogo({super.key, this.size, this.hero = true});

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 90;
    Widget child = ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: InAppImage(context.logoPrimary, width: size, height: size),
    );
    if (hero) {
      child = Hero(tag: "logo", child: child);
    }
    return child;
  }
}
