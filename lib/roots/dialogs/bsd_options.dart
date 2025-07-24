import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/text.dart';
import '../../roots/widgets/text_button.dart';

class InAppOptionBottomSheet extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final int initialIndex;
  final List<String> options;

  const InAppOptionBottomSheet({
    super.key,
    this.title,
    this.subtitle,
    this.initialIndex = 0,
    this.options = const [],
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final color = context.dark;
    return BottomSheet(
      clipBehavior: Clip.antiAlias,
      onClosing: context.dismiss,
      constraints: BoxConstraints(minHeight: dimen.height * 0.45),
      builder: (context) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: options.length + 2,
          padding: EdgeInsets.zero,
          itemBuilder: (context, index) {
            if (index == 0) {
              return Container(
                color: color.t05,
                margin: EdgeInsets.only(bottom: dimen.dp(12)),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: dimen.dp(60),
                        vertical: dimen.dp(16),
                      ),
                      child: InAppText(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: dimen.dp(18),
                          fontWeight: dimen.fontWeight.medium.fontWeight,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            final cancel = index == options.length + 1;
            return Padding(
              padding: EdgeInsets.only(bottom: cancel ? dimen.dp(8) : 0),
              child: InAppTextButton(
                cancel
                    ? "dialog_button_negative".trWithOption(
                        defaultValue: "Cancel",
                        name: "bsd_options",
                      )
                    : options.elementAt(index - 1),
                style: TextStyle(
                  fontSize: dimen.dp(16),
                  fontWeight: cancel ? FontWeight.bold : FontWeight.normal,
                ),
                borderRadius: BorderRadius.circular(dimen.dp(25)),
                width: double.infinity,
                padding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(24),
                  vertical: dimen.dp(12),
                ),
                foregroundColor: index == options.length + 1
                    ? context.error
                    : color,
                backgroundColor: Colors.transparent,
                onTap: () => context.dismiss(result: index - 1),
              ),
            );
          },
          separatorBuilder: (context, index) {
            if (index == 0) return SizedBox.shrink();
            Widget child = Divider(
              color: color.t05,
              height: dimen.dp(1),
              indent: dimen.dp(24),
              endIndent: dimen.dp(24),
            );
            if (index == options.length) {
              return Column(
                children: [
                  child,
                  SizedBox(height: dimen.dp(8)),
                ],
              );
            }
            return child;
          },
        );
      },
    );
  }
}
