import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../data/enums/audience.dart';
import '../../roots/widgets/gesture.dart';
import '../../roots/widgets/text.dart';

const kAudienceBSD = "audience_bsd";

class AudienceBSD extends StatelessWidget {
  final Audience audience;

  const AudienceBSD({super.key, this.audience = Audience.everyone});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Container(
      width: double.infinity,
      constraints: BoxConstraints(minHeight: dimen.dp(380)),
      decoration: BoxDecoration(
        color: context.dialogColor.primary,
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(dimen.dp(25)),
          topLeft: Radius.circular(dimen.dp(25)),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: dimen.dp(16)),
          Padding(
            padding: EdgeInsets.all(dimen.dp(16)),
            child: Column(
              children: [
                InAppText(
                  "Select your audience",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dark, fontSize: dimen.dp(20)),
                ),
                SizedBox(height: dimen.dp(4)),
                InAppText(
                  "Choose who can reply to this feed. Anyone mentioned can always reply.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: dark.t50, fontSize: dimen.dp(14)),
                ),
              ],
            ),
          ),
          ...List.generate(Audience.values.length, (index) {
            final item = Audience.values.elementAt(index);
            return InAppGesture(
              onTap: () => Navigator.pop(context, item),
              child: _Option(audience: item, isSelected: item == audience),
            );
          }),
        ],
      ),
    );
  }

  static Future<Audience> show(BuildContext context, [Audience? audience]) {
    final initial =
        audience ?? Audience.values.firstOrNull ?? Audience.everyone;
    return context
        .show(kAudienceBSD, content: DialogContent(args: initial))
        .onError((e, st) => initial)
        .then((v) => v ?? initial);
  }
}

class _Option extends StatelessWidget {
  final Audience audience;
  final bool isSelected;

  const _Option({required this.isSelected, required this.audience});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Padding(
      padding: EdgeInsets.all(dimen.dp(6)),
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: dimen.dp(8),
          horizontal: dimen.dp(24),
        ),
        decoration:
            isSelected
                ? BoxDecoration(
                  border: Border(
                    bottom: BorderSide(
                      color: context.primary,
                      width: dimen.dp(2),
                    ),
                  ),
                  borderRadius: BorderRadius.circular(dimen.dp(12)),
                )
                : null,
        child: InAppText(
          audience.label,
          style: TextStyle(color: dark, fontSize: dimen.dp(18)),
        ),
      ),
    );
  }
}
