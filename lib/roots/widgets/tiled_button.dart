import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';

import 'gesture.dart';
import 'icon.dart';
import 'text.dart';

class InAppTiledButton extends StatelessWidget {
  final dynamic icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String text;
  final String? extra;
  final VoidCallback? onTap;

  const InAppTiledButton({
    super.key,
    this.icon,
    this.iconColor,
    this.iconBackgroundColor,
    required this.text,
    this.extra,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = context.dark;
    final dimen = context.dimens;
    return InAppGesture(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimen.dp(16),
          vertical: dimen.dp(iconBackgroundColor != null ? 12 : 8),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: iconBackgroundColor ?? Colors.transparent,
              radius: 20,
              child: Padding(
                padding: EdgeInsets.all(dimen.dp(8)),
                child: InAppIcon(icon, color: iconColor ?? color.t50),
              ),
            ),
            dimen.dp(24).w,
            Expanded(
              child: InAppText(text, style: TextStyle(fontSize: dimen.dp(16))),
            ),
            dimen.dp(24).w,
            if (extra != null) ...[
              InAppText(
                extra,
                style: TextStyle(fontSize: dimen.dp(14), color: color.t50),
              ),
              dimen.dp(4).w,
            ],
            InAppIcon(
              Icons.keyboard_arrow_right_rounded,
              size: dimen.dp(24),
              color: color.t50,
            ),
          ],
        ),
      ),
    );
  }
}
