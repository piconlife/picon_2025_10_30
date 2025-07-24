import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';

class OnboardingSkip extends StatelessWidget {
  final VoidCallback? onTap;

  const OnboardingSkip({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final dimen = context.dimens;
    return InAppGesture(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 12,
        ).apply(dimen),
        child: InAppText(
          "skip".trWithOption(defaultValue: "Skip"),
          style: TextStyle(color: color.text.dark, fontSize: 16.0.sp(dimen)),
        ),
      ),
    );
  }
}
