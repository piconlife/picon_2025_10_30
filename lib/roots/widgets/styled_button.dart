import 'dart:developer';

import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../app/styles/fonts.dart';
import 'gesture.dart';
import 'text.dart';

class InAppStyledButton extends StatelessWidget {
  final String text;
  final Color? background;
  final VoidCallback? onTap;

  const InAppStyledButton({
    super.key,
    required this.text,
    this.background,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppGesture(
      onTap: () {
        log("message");
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.all(dimen.dp(8)),
        padding: EdgeInsets.all(dimen.dp(12)),
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(dimen.dp(10)),
        ),
        child: InAppText(
          text.toUpperCase(),
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: InAppFonts.secondary,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontSize: dimen.dp(14),
          ),
        ),
      ),
    );
  }
}
