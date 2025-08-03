import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

class StartupProgressBar extends StatelessWidget {
  final DimenData? dimen;
  final int step;
  final int total;
  final String text;

  const StartupProgressBar({
    super.key,
    this.dimen,
    required this.step,
    required this.total,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = this.dimen ?? context.dimens;
    return SizedBox(
      height: 16.0.dy(dimen),
      child: LinearProgressIndicator(
        value: (step / total).clamp(0, 1),
        color: context.secondary,
        backgroundColor: context.dark.t05,
        borderRadius: BorderRadius.circular(context.largestRadius).apply(dimen),
      ),
    );
  }
}
