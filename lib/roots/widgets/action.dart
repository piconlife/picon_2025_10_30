import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../app/res/icons.dart';
import '../../packages/imports.dart'
    show AndrossyButton, AndrossyButtonProperty, GestureAnimation;

class InAppAction extends StatelessWidget {
  final Color? primary;
  final dynamic icon;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const InAppAction(
    this.icon, {
    super.key,
    this.primary,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final color = primary ?? context.dark;
    return Center(
      child: AndrossyButton(
        padding: padding ?? EdgeInsets.all(dimen.smallPadding),
        borderRadius: BorderRadius.circular(
          dimen.smallCorner - dimen.smallestCorner,
        ),
        clickEffects: [GestureAnimation.scale(), GestureAnimation.fade()],
        icon: icon ?? InAppIcons.leading.regular,
        iconSize: dimen.normalIcon,
        iconColor: AndrossyButtonProperty(enabled: color, disabled: color.t50),
        splashColor: color.t02,
        highlightColor: color.t05,
        backgroundColor: const AndrossyButtonProperty.all(Colors.transparent),
        onTap: onTap,
      ),
    );
  }
}
