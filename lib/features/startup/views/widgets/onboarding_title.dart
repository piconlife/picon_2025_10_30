import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';
import '../../configs/onboard.dart';

const kOnboardTitleHeroAnimation = '';

class OnboardingTitle extends StatelessWidget {
  final bool? hero;
  final DimenData? dimen;
  final String data;
  final TextAlign? textAlign;

  const OnboardingTitle(
    this.data, {
    super.key,
    this.textAlign,
    this.hero,
    this.dimen,
  });

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.title;
    final dimen = context.dimens;
    Widget child = InAppText(
      data,
      textAlign: textAlign ?? TextAlign.center,
      style: TextStyle(
        fontWeight: dimen.boldFontWeight,
        fontSize: dimen.fontSize.larger,
      ),
    );

    if (hero) {
      child = Hero(
        tag: "onboard_title",
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
