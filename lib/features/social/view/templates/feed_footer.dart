import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';
import 'package:picon/routes/paths.dart';

import '../../../../app/base/countable_response.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../data/models/feed_like.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/comment_cubit.dart';
import '../cubits/like_cubit.dart';

class FeedFooter extends StatefulWidget {
  final Feed item;

  const FeedFooter({super.key, required this.item});

  @override
  State<FeedFooter> createState() => _FeedFooterState();
}

class _FeedFooterState extends State<FeedFooter> {
  late final likeCubit = context.read<FeedLikeCubit>();
  late final commentCubit = context.read<FeedCommentCubit>();

  void _like() => likeCubit.toggle();

  void _seeLikes() {}

  void _seeComments() {
    context.open(
      Routes.comments,
      arguments: {"$FeedCommentCubit": context.read<FeedCommentCubit>()},
    );
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;

    final counterStyle = TextStyle(color: dark, fontSize: dimen.dp(14));

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: dimen.dp(10),
        vertical: dimen.dp(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          BlocBuilder<FeedLikeCubit, CountableResponse<FeedLike>>(
            builder: (context, value) {
              final activated = value.isExistByMe;
              return InAppPleasureButton(
                icon: activated
                    ? InAppIcons.heart.solid
                    : InAppIcons.heart.regular,
                iconSize: dimen.dp(26),
                iconColor: activated ? context.red : dark.t50,
                onTap: _like,
              );
            },
          ),
          SizedBox(width: dimen.dp(8)),
          InAppGesture(
            onTap: () {},
            child: Padding(
              padding: EdgeInsets.all(dimen.dp(8)),
              child: InAppIcon(
                InAppIcons.feedComment.regular,
                color: dark.t50,
                size: dimen.dp(24),
              ),
            ),
          ),
          SizedBox(width: dimen.dp(8)),
          BlocBuilder<FeedLikeCubit, CountableResponse<FeedLike>>(
            builder: (context, value) {
              return InAppGesture(
                onTap: _seeLikes,
                child: InAppText(
                  Converter.toKMB(value.count, "Like", "Likes"),
                  style: counterStyle,
                ),
              );
            },
          ),
          SizedBox(width: dimen.dp(8)),
          InAppText("&", style: counterStyle),
          SizedBox(width: dimen.dp(8)),
          BlocBuilder<FeedCommentCubit, CountableResponse<FeedComment>>(
            builder: (context, value) {
              return InAppGesture(
                onTap: _seeComments,
                child: InAppText(
                  Converter.toKMB(value.count, "Comment", "Comments"),
                  style: counterStyle,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
