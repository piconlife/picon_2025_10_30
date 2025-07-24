import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'gesture.dart';
import 'icon.dart';

class InAppFAButton extends StatelessWidget {
  final dynamic icon;
  final VoidCallback? onTap;

  const InAppFAButton({super.key, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final dimen = context.dimens;
    return InAppGesture(
      onTap: onTap,
      child: CircleAvatar(
        radius: dimen.dp(30),
        backgroundColor: primary,
        child: InAppIcon(icon, size: dimen.dp(28), color: context.lightAsFixed),
      ),
    );
  }
}
