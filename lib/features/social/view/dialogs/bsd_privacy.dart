import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../../../data/enums/privacy.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';

class PrivacyBSD extends StatelessWidget {
  final Privacy privacy;

  const PrivacyBSD({super.key, this.privacy = Privacy.everyone});

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
                  "Who can reply?",
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
          ...List.generate(Privacy.values.length, (index) {
            final item = Privacy.values.elementAt(index);
            return InAppGesture(
              onTap: () => Navigator.pop(context, item),
              child: _Option(privacy: item, isSelected: item == privacy),
            );
          }),
        ],
      ),
    );
  }

  static Future<Privacy> show(BuildContext context, [Privacy? privacy]) {
    final initial = privacy ?? Privacy.values.firstOrNull ?? Privacy.everyone;
    return context
        .show("privacy_bsd", content: DialogContent(args: initial))
        .onError((e, st) => initial)
        .then((v) => v ?? initial);
  }
}

class _Option extends StatelessWidget {
  final Privacy privacy;
  final bool isSelected;

  const _Option({required this.isSelected, required this.privacy});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final primary = context.primary;
    return Padding(
      padding: EdgeInsets.all(dimen.dp(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: isSelected ? primary : primary.t10,
            radius: dimen.dp(20),
            child: Center(
              child: InAppIcon(
                privacy.icon.regular,
                size: dimen.dp(24),
                color: isSelected ? Colors.white : primary,
              ),
            ),
          ),
          SizedBox(width: dimen.dp(16)),
          Expanded(
            child: InAppText(
              privacy.title,
              style: TextStyle(color: dark, fontSize: dimen.dp(18)),
            ),
          ),
        ],
      ),
    );
  }
}
