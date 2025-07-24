import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../app/res/defaults.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../configs/onboard.dart';

class OnboardingAuthButton extends StatelessWidget {
  final bool? hero;
  final DimenData? dimen;
  final String tag;
  final String logo;
  final Color? logoColor;
  final double? width;
  final double height;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final String text;
  final Color? borderColor;
  final Color? background;
  final Widget? suffixIcon;
  final bool expanded;
  final bool fill;
  final VoidCallback? onTap;

  const OnboardingAuthButton({
    super.key,
    this.tag = 'primary',
    required this.logo,
    this.logoColor,
    this.hero,
    this.dimen,
    this.width,
    this.height = 60,
    this.expanded = true,
    this.fill = true,
    this.margin = const EdgeInsets.only(bottom: 24, left: 20, right: 20),
    this.padding = const EdgeInsets.only(left: 24, right: 24),
    required this.text,
    this.onTap,
    this.background,
    this.borderColor,
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
          color: fill
              ? background ?? color.background.dark ?? Colors.black
              : null,
          boxShadow: InAppDefaults.shadowPrimary.applyDimen(dimen),
          borderRadius: BorderRadius.circular(100),
          border: Border.all(
            color: fill
                ? Colors.transparent
                : borderColor ?? color.background.dark ?? Colors.black,
            width: 2,
          ),
        ).applyDimen(dimen),
        child: InAppLayout(
          layout: LayoutType.row,
          mainAxisSize: expanded ? MainAxisSize.max : MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: expanded ? 1 : 0,
              child: InAppText(
                text,
                style: TextStyle(
                  color: fill
                      ? (color.text.light ?? color.base.light)
                      : (color.text.dark ?? color.base.dark),
                  fontSize: dimen.fontSize.large,
                  fontWeight: dimen.fontWeight.bold.fontWeight,
                ),
              ),
            ),
            // suffixIcon ??
            SvgPicture.asset(
              logo,
              width: 28,
              height: 28,
              colorFilter: logoColor != null
                  ? ColorFilter.mode(logoColor!, BlendMode.srcIn)
                  : null,
            ),
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
