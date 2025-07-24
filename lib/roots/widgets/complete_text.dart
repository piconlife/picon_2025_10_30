import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'text.dart';

class InAppCompleteText extends StatelessWidget {
  final String? text;
  final TextStyle style;

  const InAppCompleteText({
    super.key,
    this.text = "COMPLETE",
    this.style = const TextStyle(),
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(dimen.dp(16)),
        child: InAppText(
          text,
          textAlign: TextAlign.center,
          style: style.copyWith(color: style.color ?? context.dark.t25),
        ),
      ),
    );
  }
}
