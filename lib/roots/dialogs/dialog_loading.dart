import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

class InAppLoadingDialog extends StatelessWidget {
  final String? id;

  const InAppLoadingDialog({super.key, this.id});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final background = context.light;
    final primary = context.primary;

    const dimension = 160.0;
    const loaderDimension = dimension * 0.45;
    const radius = loaderDimension * 0.07;

    return Container(
      width: dimen.dp(dimension),
      height: dimen.dp(dimension),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        boxShadow: [BoxShadow(color: context.dark.t10, blurRadius: 100)],
        borderRadius: BorderRadius.circular(dimen.dp(dimension * 0.2)),
      ),
      child: Container(
        width: loaderDimension,
        height: loaderDimension,
        padding: const EdgeInsets.all(dimension * 0.025),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: primary.t10, width: radius),
        ),
        child: CircularProgressIndicator(
          strokeCap: StrokeCap.round,
          strokeWidth: radius,
          color: primary,
          backgroundColor: Colors.transparent,
        ),
      ),
    );
  }
}
