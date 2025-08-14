import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../roots/widgets/text.dart';

class FeedCommentBox extends StatelessWidget {
  final String id;
  final String path;

  const FeedCommentBox({super.key, required this.id, required this.path});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Container(
      decoration: BoxDecoration(
        color: dark.t05,
        borderRadius: BorderRadius.circular(dimen.dp(25)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: dimen.dp(16),
        vertical: dimen.dp(8),
      ),
      child: InAppText(
        "Write a comment",
        style: TextStyle(color: dark, fontSize: dimen.dp(16)),
        onClick: (c) {},
      ),
    );
  }
}
