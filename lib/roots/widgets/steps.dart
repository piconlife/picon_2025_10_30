import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'text.dart';

class InAppSteps extends StatelessWidget {
  final String data;

  const InAppSteps(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppText(
      data,
      style: TextStyle(
        color: context.dark.t50,
        fontWeight: dimen.mediumFontWeight,
        fontSize: dimen.dp(14),
      ),
    );
  }
}
