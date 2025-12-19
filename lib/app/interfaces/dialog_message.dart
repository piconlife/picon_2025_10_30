import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';

import '../../roots/widgets/text.dart';
import '../../roots/widgets/text_button.dart';

class InAppMessageDialog extends StatelessWidget {
  final String? title;
  final String? message;

  const InAppMessageDialog({super.key, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final textColor = context.textColor.primary;
    return Dialog(
      backgroundColor: context.dialogColor.primary,
      clipBehavior: Clip.antiAlias,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 16, top: 24),
            child: Column(
              children: [
                if ((title ?? '').isNotEmpty) ...[
                  InAppText(
                    title!,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: textColor,
                      fontWeight: FontWeight.bold,
                      fontSize: dimen.dp(dimen.fontSize.larger),
                    ),
                  ),
                  SizedBox(height: (message ?? '').isNotEmpty ? 8 : 4),
                ],
                if ((message ?? '').isNotEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: (title ?? '').isEmpty ? 16 : 0,
                    ),
                    child: InAppText(
                      message,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: title.isNotValid ? textColor : textColor.t75,
                        fontSize: dimen.dp(dimen.fontSize.large),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Divider(height: dimen.dp(1)),
          InAppTextButton(
            "OK",
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            height: dimen.dp(54),
            width: double.infinity,
            onTap: () => AndrossyDialog.dismiss(),
          ),
        ],
      ),
    );
  }
}
