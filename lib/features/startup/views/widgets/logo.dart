import 'package:flutter/material.dart';

import '/app/res/logo.dart';
import '../../../../roots/widgets/image.dart';

class OnboardingLogo extends StatelessWidget {
  final bool? hero;

  const OnboardingLogo({super.key, this.hero});

  @override
  Widget build(BuildContext context) {
    Widget child = InAppImage(context.logoPrimary, height: 81);
    if (hero ?? false) {
      child = Hero(tag: 'onboard_logo', child: child);
    }
    return child;
  }
}
