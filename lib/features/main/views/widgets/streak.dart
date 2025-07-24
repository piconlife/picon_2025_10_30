import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/res/defaults.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../logics/score_service.dart';

class StreakButton extends StatelessWidget {
  const StreakButton({super.key});

  void _openStreak(BuildContext context) => context.open(Routes.streak);

  @override
  Widget build(BuildContext context) {
    final color = context.color;
    final dimen = context.dimens;
    return InAppGesture(
      onTap: () => _openStreak(context),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 6,
        ).apply(dimen),
        decoration: BoxDecoration(
          color: color.base.light,
          borderRadius: BorderRadius.circular(8).apply(dimen),
          boxShadow: InAppDefaults.shadowPrimary,
        ),
        child: InAppLayout(
          layout: LayoutType.row,
          mainAxisSize: MainAxisSize.min,
          children: [
            ValueListenableBuilder(
              valueListenable: Streak.i,
              builder: (context, value, child) {
                return InAppText(
                  value.trNumber,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: color.base.secondary,
                  ),
                );
              },
            ),
            const SizedBox(width: 10),
            InAppIcon(
              "assets/icons/ic_fire.svg",
              size: 18,
              color: color.base.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
