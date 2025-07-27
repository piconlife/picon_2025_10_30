import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../routes/paths.dart';
import '../extensions/logo.dart';
import 'gesture.dart';
import 'image.dart';

class InAppLogoTrailing extends StatelessWidget {
  final bool visible;

  const InAppLogoTrailing({super.key, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox();
    final dimen = context.dimens;
    return Center(
      child: InAppGesture(
        onTap: () => context.open(Routes.info),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(dimen.normalCorner),
            boxShadow: [
              BoxShadow(
                color: context.appbarColor.primary ?? Colors.transparent,
                blurRadius: dimen.dp(24),
              ),
            ],
          ),
          child: SizedBox(
            width: dimen.dp(40),
            height: dimen.dp(40),
            child: InAppImage(context.logoHeader),
          ),
        ),
      ),
    );
  }
}
