import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/image.dart';
import '../../configs/onboard.dart';

class OnboardingImage extends StatelessWidget {
  final bool? hero;
  final dynamic data;
  final DimenData? dimen;
  final double? width;

  const OnboardingImage(
    this.data, {
    super.key,
    this.dimen,
    this.hero,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.image;
    final dimen = this.dimen ?? context.dimens;
    Widget child = Container(
      padding: EdgeInsets.symmetric(horizontal: dimen.largePadding),
      constraints: BoxConstraints(maxWidth: 400, minWidth: 200),
      child: InAppImage(
        data,
        dimen: dimen,
        fit: BoxFit.fitWidth,
        width: width ?? double.infinity,
      ),
    );
    if (hero) {
      child = Hero(
        tag: "onboard_image",
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
