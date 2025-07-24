import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';
import '../../configs/onboard.dart';

class OnboardingOutlinedButton extends StatelessWidget {
  final bool? hero;
  final DimenData? dimen;
  final String tag;
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String text;
  final Color borderColor;
  final Widget? suffixIcon;
  final bool expanded;
  final VoidCallback? onTap;

  const OnboardingOutlinedButton({
    super.key,
    this.tag = 'primary',
    this.hero,
    this.dimen,
    this.width,
    this.height = 60,
    this.expanded = true,
    this.margin = const EdgeInsets.only(bottom: 24, left: 20, right: 20),
    this.padding = const EdgeInsets.only(left: 24, right: 24),
    required this.text,
    this.onTap,
    this.borderColor = Colors.black,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final hero = this.hero ?? OnboardHeroConfigs.i.outlinedButton;
    final dimen = this.dimen ?? context.dimens;
    final color = context.color;
    Widget child = InAppGesture(
      onTap: onTap,
      child: Container(
        width: width.dx(dimen),
        height: height.dy(dimen),
        margin: margin.apply(dimen),
        padding: padding.apply(dimen),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          border: Border.all(color: borderColor, width: 2),
        ).applyDimen(dimen),
        child: Row(
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: expanded ? 1 : 0,
              child: InAppText(
                text,
                style: TextStyle(
                  color: color.text.dark ?? color.base.dark,
                  fontSize: dimen.fontSize.large,
                  fontWeight: dimen.fontWeight.bold.fontWeight,
                ),
              ),
            ),
            if (suffixIcon != null) suffixIcon!,
          ],
        ),
      ),
    );
    if (hero) {
      child = Hero(
        tag: "onboarding_outlined_button_$tag",
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
