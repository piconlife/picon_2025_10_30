import 'package:flutter/material.dart';

import '../../app/res/logo.dart';
import 'image.dart';

class InAppLogo extends StatelessWidget {
  final double? size;

  const InAppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final size = this.size ?? 90;
    return Hero(
      tag: "logo",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: InAppImage(context.logoPrimary, width: size, height: size),
      ),
    );
  }
}
