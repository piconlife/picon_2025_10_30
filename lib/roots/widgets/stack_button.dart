import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'button.dart';

class InAppStackButton extends StatelessWidget {
  final Color? primary;
  final Color? bottomColor;
  final double? width;
  final double? height;
  final String text;
  final TextStyle style;
  final EdgeInsets padding;
  final bool activated;
  final bool enabled;
  final VoidCallback? onTap;

  const InAppStackButton(
    this.text, {
    super.key,
    this.primary,
    this.bottomColor,
    this.width,
    this.height,
    this.padding = const EdgeInsets.only(bottom: 8),
    this.style = const TextStyle(),
    this.activated = false,
    this.enabled = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = this.primary ?? context.primary;
    final bg =
        bottomColor ??
        context.bottomColor.primary ??
        context.scaffoldColor.primary ??
        context.light ??
        Theme.of(context).scaffoldBackgroundColor;

    final enabled = this.enabled && onTap != null;

    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              bg.withValues(alpha: 0.001),
              bg.withValues(alpha: 0.85),
              bg,
              bg,
            ],
          ),
        ),
        child: Padding(
          padding: padding.copyWith(
            top: padding.top + dimen.dp(4),
            bottom:
                padding.bottom +
                (MediaQuery.maybePaddingOf(context)?.bottom ?? dimen.dp(4)),
          ),
          child: Center(
            child: InAppButton(
              text: text,
              width: width ?? (dimen.width * .75),
              height: height ?? dimen.button.normal?.height ?? dimen.dp(45),
              backgroundColor:
                  activated ? primary.withValues(alpha: 0.1) : primary,
              textStyle: style.copyWith(
                color: style.color ?? (activated ? primary : Colors.white),
                fontWeight:
                    style.fontWeight ??
                    (enabled ? dimen.boldFontWeight : dimen.normalFontWeight),
              ),
              onTap: enabled ? onTap : null,
            ),
          ),
        ),
      ),
    );
  }
}
