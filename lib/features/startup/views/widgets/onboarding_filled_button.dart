import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../app/res/defaults.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../configs/onboard.dart';

class OnboardingFilledButton extends StatelessWidget {
  final bool? hero;
  final DimenData? dimen;
  final double? width;
  final double height;
  final String text;
  final VoidCallback? onTap;
  final Color background;
  final EdgeInsets? margin;
  final Widget? suffixIcon;
  final String tag;

  const OnboardingFilledButton({
    super.key,
    this.tag = 'primary',
    this.hero,
    this.dimen,
    this.width,
    this.height = 56,
    this.margin = const EdgeInsets.only(left: 20, right: 20, bottom: 24),
    required this.text,
    this.onTap,
    this.background = Colors.black,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.filledButton;
    final dimen = this.dimen ?? context.dimens;
    final color = context.color;
    Widget child = InAppGesture(
      onTap: onTap,
      child: Container(
        width: width.dx(dimen),
        height: height.dy(dimen),
        margin: margin.apply(dimen),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: background,
          boxShadow: InAppDefaults.shadowPrimary.applyDimen(dimen),
          borderRadius: BorderRadius.circular(100),
        ).applyDimen(dimen),
        child: InAppLayout(
          layout: LayoutType.row,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InAppText(
              text,
              style: TextStyle(
                color: color.text.lightAsFixed ?? color.base.lightAsFixed,
                fontSize: dimen.fontSize.large,
                fontWeight: dimen.fontWeight.medium.fontWeight,
              ).applyDimen(dimen),
            ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
      ),
    );
    if (hero) {
      child = Hero(
        tag: "onboarding_filled_button_$tag",
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
