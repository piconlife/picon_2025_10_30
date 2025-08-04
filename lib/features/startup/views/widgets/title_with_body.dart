import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class AuthTitleAndBody extends StatelessWidget {
  final bool strongTitle;
  final String title;
  final String? subtitle;
  final String? prefix;
  final String? suffix;
  final ValueChanged<BuildContext>? onPrefix;
  final ValueChanged<BuildContext>? onSuffix;

  const AuthTitleAndBody({
    super.key,
    this.strongTitle = false,
    required this.title,
    this.subtitle,
    this.prefix,
    this.suffix,
    this.onPrefix,
    this.onSuffix,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: dimen.dp(8),
      children: [
        InAppText(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: dimen.dp(24),
            fontWeight: strongTitle ? context.boldFontWeight : null,
          ),
        ),
        InAppText(
          subtitle,
          style: TextStyle(
            color: context.textColor.mid,
            fontSize: dimen.dp(14),
          ),
          prefix: prefix,
          prefixStyle: TextStyle(color: primary, fontWeight: FontWeight.w600),
          suffixStyle: TextStyle(color: primary, fontWeight: FontWeight.w600),
          onPrefixClick: onPrefix,
          suffix: suffix,
          onSuffixClick: onSuffix,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
