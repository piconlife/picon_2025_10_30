import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class AuthTitleWithSubtitle extends StatelessWidget {
  final DimenData dimen;
  final String title;
  final String subtitle;
  final bool centerMode;

  const AuthTitleWithSubtitle({
    super.key,
    required this.dimen,
    required this.title,
    required this.subtitle,
    this.centerMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: centerMode
          ? CrossAxisAlignment.center
          : CrossAxisAlignment.start,
      spacing: dimen.dp(8),
      children: [
        InAppText(
          title,
          textAlign: centerMode ? TextAlign.center : null,
          style: TextStyle(
            fontSize: dimen.dp(24),
            fontWeight: context.boldFontWeight,
          ),
        ),
        InAppText(subtitle, textAlign: centerMode ? TextAlign.center : null),
      ],
    );
  }
}
