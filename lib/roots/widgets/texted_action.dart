import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';

class InAppTextedAction extends StatelessWidget {
  final String data;
  final Color? primary;
  final Color? background;
  final EdgeInsets? padding;
  final VoidCallback? onTap;

  const InAppTextedAction(
    this.data, {
    super.key,
    this.primary,
    this.background,
    this.padding,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = this.primary ?? context.primary;
    final background = this.background ?? primary.t10;
    final isBackgroundMode = background != Colors.transparent;
    return AndrossyButton(
      activated: context.isDarkMode,
      text: data,
      padding: EdgeInsets.symmetric(
        horizontal: dimen.dp(12),
        vertical: dimen.dp(6),
      ),
      backgroundColor: AndrossyButtonProperty.all(background),
      borderRadius: BorderRadius.circular(dimen.dp((12))),
      textStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: dimen.dp(14)),
      textAllCaps: true,
      textColor: AndrossyButtonProperty.all(primary),
      clickEffect: AndrossyGestureEffect(
        primary: AndrossyGestureAnimation.scale(),
        secondary: AndrossyGestureAnimation.fade(),
      ),
      splashColor: isBackgroundMode ? null : primary.t02,
      highlightColor: isBackgroundMode ? null : primary.t05,
      onTap: onTap,
    );
  }
}
