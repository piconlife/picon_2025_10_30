import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';
import '../../configs/onboard.dart';

class OnboardingBody extends StatelessWidget {
  final bool? hero;
  final String data;
  final TextAlign? textAlign;

  const OnboardingBody(this.data, {super.key, this.textAlign, this.hero});

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.body;
    Widget child = InAppText(
      data,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(fontSize: 16, letterSpacing: 0.3),
    );
    if (hero) {
      child = Hero(
        tag: "onboard_body",
        child: Material(
          color: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          child: child,
        ),
      );
    }
    return child;
  }
}
