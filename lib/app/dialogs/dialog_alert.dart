import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/icon.dart';
import '../../roots/widgets/text.dart';
import '../../roots/widgets/text_button.dart';

class InAppAlertDialog extends StatelessWidget {
  final dynamic icon;
  final String title;
  final List<String>? titleSpans;
  final String subtitle;
  final List<String>? subtitleSpans;
  final String? positiveButtonText;
  final String? negativeButtonText;

  const InAppAlertDialog({
    super.key,
    this.icon,
    required this.title,
    this.titleSpans,
    required this.subtitle,
    this.subtitleSpans,
    this.positiveButtonText,
    this.negativeButtonText,
  });

  static Future<bool> show(
    BuildContext context, {
    dynamic icon,
    required String title,
    List<String>? titleSpans,
    String? message,
    List<String>? messageSpans,
    String? positiveButtonText,
    String? negativeButtonText,
  }) {
    return context
        .showAlert(
          title: title,
          message: message,
          content: AlertDialogContent(
            titleSpans: titleSpans,
            bodySpans: messageSpans,
            positiveButtonText: positiveButtonText,
            negativeButtonText: negativeButtonText,
            args: icon,
          ),
        )
        .onError((_, __) => false)
        .then((value) => value);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    final dark = context.dark;
    final isTitled = title.isNotEmpty || (titleSpans ?? []).isNotEmpty;
    final isSubtitled = subtitle.isNotEmpty || (subtitleSpans ?? []).isNotEmpty;
    return Dialog(
      backgroundColor: context.dialogColor.primary,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: dimen.dp(32)),
          if (icon != null) ...[
            InAppIcon(icon, size: dimen.dp(50), color: primary),
            SizedBox(height: dimen.dp(8)),
          ],
          Padding(
            padding: EdgeInsets.symmetric(horizontal: dimen.dp(32)),
            child: Column(
              children: [
                if (isTitled)
                  InAppText(
                    title,
                    spans: titleSpans != null
                        ? List.generate(titleSpans!.length, (index) {
                            return TextSpan(
                              text: titleSpans![index],
                              style: TextStyle(
                                fontWeight: index.isEven
                                    ? dimen.boldFontWeight
                                    : dimen.normalFontWeight,
                              ),
                            );
                          })
                        : [],
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: dimen.dp(18),
                      height: 1.4,
                      color: dark,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                if (isTitled && isSubtitled) SizedBox(height: dimen.dp(8)),
                if (isSubtitled)
                  InAppText(
                    subtitle,
                    spans: subtitleSpans != null
                        ? List.generate(subtitleSpans!.length, (index) {
                            return TextSpan(
                              text: subtitleSpans![index],
                              style: TextStyle(
                                fontWeight: index.isEven
                                    ? dimen.boldFontWeight
                                    : dimen.normalFontWeight,
                              ),
                            );
                          })
                        : [],
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    maxLines: 4,
                    style: TextStyle(
                      fontSize: dimen.dp(16),
                      height: 1.6,
                      color: dark.t75,
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: dimen.dp(12)),
          Padding(
            padding: EdgeInsets.all(dimen.dp(12)),
            child: SizedBox(
              width: double.infinity,
              height: dimen.dp(40),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: InAppTextButton(
                      negativeButtonText ?? "CANCEL",
                      height: double.infinity,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(dimen.dp(50)),
                      foregroundColor: context.red,
                      onTap: () => context.dismiss(result: false),
                    ),
                  ),
                  VerticalDivider(
                    width: dimen.dp(16),
                    indent: dimen.dp(6),
                    endIndent: dimen.dp(6),
                    color: context.dark.t05,
                  ),
                  Expanded(
                    child: InAppTextButton(
                      positiveButtonText ?? "OK",
                      height: double.infinity,
                      foregroundColor: primary,
                      padding: EdgeInsets.zero,
                      borderRadius: BorderRadius.circular(dimen.dp(50)),
                      onTap: () => context.dismiss(result: true),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
