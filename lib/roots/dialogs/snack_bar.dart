import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';

import '../../roots/widgets/text.dart';

class InAppSnackBar extends StatelessWidget {
  final String? title;
  final String? message;
  final Color? color;

  const InAppSnackBar({
    super.key,
    required this.color,
    required this.title,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dividerColor = color ?? context.primary;
    final textColor = context.textColor.primary;
    return Align(
      alignment: const Alignment(0, 0.95),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: dimen.dp(16),
          vertical: dimen.dp(12),
        ),
        margin: EdgeInsets.all(dimen.dp(24)),
        constraints: BoxConstraints(minWidth: context.scaffoldWidth * 0.75),
        decoration: BoxDecoration(
          color: context.light,
          borderRadius: BorderRadius.circular(dimen.dp(16)),
          border: Border(
            left: BorderSide(color: dividerColor, width: dimen.dp(18)),
            right: BorderSide(color: dividerColor, width: dimen.dp(1)),
            top: BorderSide(color: dividerColor, width: dimen.dp(1)),
            bottom: BorderSide(color: dividerColor, width: dimen.dp(1)),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (title != null && title!.isNotEmpty) ...[
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
            InAppText(
              message,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor.t50,
                fontSize: dimen.dp(dimen.fontSize.normal),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
