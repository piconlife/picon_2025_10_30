import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import 'shimmer.dart';

class InAppScaffoldShimmer extends StatelessWidget {
  final Color? background;
  final Widget? child;

  const InAppScaffoldShimmer({super.key, this.background, this.child});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final scaffold = context.scaffoldSize;
    return InAppShimmer(
      background: background ?? context.scaffoldColor.primary,
      child: SizedBox(
        width: scaffold.width,
        height: scaffold.height,
        child: ColoredBox(
          color: dark.t10,
          child: Align(
            alignment: Alignment(0, -0.1),
            child:
                child ??
                Text(
                  "Loading...",
                  style: TextStyle(
                    color: dark.t50,
                    fontSize: dimen.dp(24),
                    fontWeight: FontWeight.w300,
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
