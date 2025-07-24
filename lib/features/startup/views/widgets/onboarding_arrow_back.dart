import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../configs/onboard.dart';

class OnboardingArrowBack extends StatelessWidget {
  final bool? hero;
  final DimenData? dimen;
  final VoidCallback? onTap;

  const OnboardingArrowBack({super.key, this.hero, this.dimen, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.appbarLeading;
    final dimen = this.dimen ?? context.dimens;
    Widget child = InAppGesture(
      onTap: onTap ?? context.close,
      child: Container(
        color: Colors.transparent,
        height: 40.0.dy(dimen),
        width: 40.0.dx(dimen),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10).apply(dimen),
        child: InAppIcon(
          InAppIcons.arrowBack.regular,
          size: double.infinity,
          color: Color(0xff454545),
          flipByTextDirection: true,
        ),
      ),
    );
    if (hero) {
      child = Hero(
        tag: "onboard_appbar_leading",
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
