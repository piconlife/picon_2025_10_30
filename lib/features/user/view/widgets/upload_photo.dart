import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';

class InAppUploadPhoto extends StatelessWidget {
  const InAppUploadPhoto({super.key});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final primary = context.primary;
    return AspectRatio(
      aspectRatio: 1 / 0.5,
      child: Container(
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(dimen.dp(12)),
          border: Border.all(color: primary.t50, width: dimen.dp(2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InAppIcon(Remix.image_add_fill, color: primary, size: dimen.dp(40)),
            SizedBox(height: dimen.dp(8)),
            InAppText(
              "Upload your content",
              style: TextStyle(
                color: dark,
                fontSize: dimen.dp(16),
                fontWeight: dimen.semiBoldFontWeight,
              ),
            ),
            InAppText(
              'Just tap here to ',
              spans: [
                TextSpan(text: "browse ", style: TextStyle(color: primary)),
                TextSpan(text: "your gallery to\nupload content"),
              ],
              textAlign: TextAlign.center,
              style: TextStyle(color: dark.t60, fontSize: dimen.dp(14)),
            ),
          ],
        ),
      ),
    );
  }
}
