import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';

class MainSearchBox extends StatelessWidget {
  final String text;
  final VoidCallback? onSearch;

  const MainSearchBox({
    this.text = "Search",
    required this.onSearch,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Expanded(
      child: InAppGesture(
        onTap: onSearch,
        scalerLowerBound: 1,
        child: Container(
          decoration: BoxDecoration(
            color: context.isDarkMode ? Colors.white.t02 : Colors.black.t05,
            borderRadius: BorderRadius.circular(dimen.dp(25)),
          ),
          height: dimen.dp(40),
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.symmetric(horizontal: dimen.dp(24)),
          child: InAppText(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: dimen.dp(16),
              color: dark.t30,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
