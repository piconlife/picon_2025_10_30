import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';

class InAppLeading extends StatelessWidget {
  const InAppLeading({super.key});

  @override
  Widget build(BuildContext context) {
    if (!Navigator.canPop(context)) return SizedBox();
    return InAppGesture(
      onTap: context.close,
      child: ColoredBox(
        color: Colors.transparent,
        child: SizedBox.square(
          dimension: 40,
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: InAppIcon(
              "assets/icons/ic_arrow_back.svg",
              color: context.dark,
              flipByTextDirection: true,
            ),
          ),
        ),
      ),
    );
  }
}
