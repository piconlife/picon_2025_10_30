import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../extensions/logo.dart';
import 'image.dart';

class InAppLogo extends StatelessWidget {
  final double? size;

  const InAppLogo({super.key, this.size});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final size = this.size ?? dimen.largerLogo;
    final corner = dimen.largeCorner;
    return Hero(
      tag: "logo",
      child: ClipRRect(
        borderRadius: BorderRadius.circular(corner),
        child: InAppImage(context.logo, width: size, height: size),
      ),
    );
  }
}
