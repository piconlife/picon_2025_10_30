import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class OrText extends StatelessWidget {
  final String text;
  final double? marginTop;
  final double? marginBottom;
  final Color textColor;
  final Color? lineColor;

  const OrText({
    super.key,
    required this.text,
    this.marginTop,
    this.marginBottom,
    this.textColor = Colors.grey,
    this.lineColor,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        left: dimen.dp(12),
        right: dimen.dp(12),
        top: marginTop ?? 0,
        bottom: marginBottom ?? 0,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: dimen.dp(8),
        children: [
          Expanded(
            child: Container(
              color: (lineColor ?? textColor).withAlpha(50),
              height: 1.5,
            ),
          ),
          InAppText(
            text,
            style: TextStyle(color: textColor, fontSize: dimen.dp(16)),
          ),
          Expanded(
            child: Container(
              color: (lineColor ?? textColor).withAlpha(50),
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
