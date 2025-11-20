import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/route.dart';

import '../../routes/paths.dart';
import 'gesture.dart';
import 'logo.dart';

class InAppLogoTrailing extends StatelessWidget {
  final bool visible;

  const InAppLogoTrailing({super.key, this.visible = true});

  @override
  Widget build(BuildContext context) {
    if (!visible) return const SizedBox();
    return Center(
      child: InAppGesture(
        onTap: () => context.open(Routes.info),
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: context.appbarColor.primary ?? Colors.transparent,
                blurRadius: 24,
              ),
            ],
          ),
          child: InAppLogo(size: 40),
        ),
      ),
    );
  }
}
