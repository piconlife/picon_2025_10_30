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
        children: [
          dimen.dp(16).h,
          if (title.isValid) ...[
            InAppText(
              title!,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontWeight: FontWeight.bold,
                fontSize: dimen.dp(dimen.fontSize.larger),
              ),
            ),
            dimen.dp(8).h,
          ],
          dimen.dp(8).h,
          InAppText(
            message,
            maxLines: 5,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: title.isNotValid ? textColor : textColor.t75,
              fontSize: dimen.dp(dimen.fontSize.medium),
            ),
          ),
          dimen.dp(24).h,
          Divider(height: dimen.dp(1)),
          InAppTextButton(
            "OK",
            foregroundColor: context.primary,
            height: dimen.dp(54),
            width: double.infinity,
            onTap: () => AndrossyDialog.dismiss(),
          ),
        ],
      ),
    );
  }
}
