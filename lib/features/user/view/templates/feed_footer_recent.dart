import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';

import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';

class FooterRecentFeed extends StatelessWidget {
  final String? image;
  final String? title;
  final String? description;

  const FooterRecentFeed({super.key, this.image, this.title, this.description});

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;
    return Row(
      children: [
        SizedBox(width: dimen.dx(8)),
        if (image.isValid)
          InAppImage(
            image,
            fit: BoxFit.cover,
            decoration: BoxDecoration(
              color: dark.t05,
              borderRadius: BorderRadius.circular(dimen.dp(4)),
            ),
            width: dimen.dp(100),
            height: dimen.dp(80),
          ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InAppText(
                  title ?? "Unknown",
                  style: TextStyle(fontSize: dimen.dp(16), color: dark),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const Divider(),
                InAppText(
                  description ?? "No description found!",
                  style: TextStyle(
                    fontSize: dimen.dp(14),
                    color: dark.t50,
                    fontWeight: FontWeight.w300,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: dimen.dx(8)),
      ],
    );
  }
}
