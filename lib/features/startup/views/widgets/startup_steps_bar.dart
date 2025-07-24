import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../../../app/styles/fonts.dart';
import '../../../../roots/widgets/text.dart';

class StartupStepsBar extends StatelessWidget {
  final bool titled;
  final DimenData? dimen;
  final String text;
  final String step;
  final String total;

  const StartupStepsBar({
    super.key,
    this.dimen,
    this.titled = true,
    required this.text,
    required this.step,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final x = TextParser.parse(text);
    final a = x.firstOrNull?.text;
    final b = x.lastOrNull?.text;
    final color = context.color;
    final dimen = this.dimen ?? context.dimens;
    return InAppText(
      titled ? a ?? step : a ?? "Step $step",
      suffix: titled ? b ?? "/$total" : b ?? " of $total",
      style: TextStyle(
        color: color.text.dark,
        fontSize: dimen.fontSize.medium,
        fontWeight: dimen.boldFontWeight,
        fontFamily: InAppFonts.secondary,
      ),
      suffixStyle: TextStyle(
        color: color.text.mid,
        fontWeight: FontWeight.normal,
      ),
    );
  }
}
