import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';

class PlayPauseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const PlayPauseButton({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    return InAppGesture(
      onTap: onTap,
      child: Container(
        height: 24,
        constraints: BoxConstraints(minWidth: 84, maxWidth: 120),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color.base.primary,
          borderRadius: BorderRadius.circular(12).apply(context.dimens),
        ),
        child: InAppText(
          text,
          style: TextStyle(
            color: color.base.lightAsFixed,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
