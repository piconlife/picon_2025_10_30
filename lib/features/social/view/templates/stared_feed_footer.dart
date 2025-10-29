import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/converter.dart';

import '../../../../app/base/countable_builder.dart';
import '../../../../app/base/exist_by_me_builder.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../data/models/feed_like.dart';
import '../../../../data/models/feed_star.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';
import '../cubits/comment_cubit.dart';
import '../cubits/like_cubit.dart';
import '../cubits/star_cubit.dart';
import 'feed_comment_box.dart';

class StaredFeedFooter extends StatefulWidget {
  final int index;
  final String id;
  final String path;
  final int? likes;
  final List<String>? stars;
  final List<String>? comments;
  final void Function(List<String> likes) onLiked;
  final void Function(List<String> stars) onStared;

  const StaredFeedFooter({
    super.key,
    required this.index,
    required this.id,
    required this.path,
    required this.onLiked,
    required this.onStared,
    this.likes,
    this.stars,
    this.comments,
  });

  @override
  State<StaredFeedFooter> createState() => _StaredFeedFooterState();
}

class _StaredFeedFooterState extends State<StaredFeedFooter> {
  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;

    final counterStyle = TextStyle(color: dark, fontSize: dimen.dp(14));

    return Column(
      children: [
        Row(
          children: [
            SizedBox(width: dimen.dp(16)),
            CountableBuilder<FeedLikeCubit, FeedLike>(
              builder: (context, value) {
                return InAppText(
                  Converter.toKMB(value, "Like", "Likes"),
                  style: counterStyle,
                );
              },
            ),
            InAppText(",", style: counterStyle),
            SizedBox(width: dimen.dp(8)),
            CountableBuilder<FeedStarCubit, FeedStar>(
              builder: (context, value) {
                return InAppText(
                  Converter.toKMB(value, "Star", "Stars"),
                  style: counterStyle,
                );
              },
            ),
            SizedBox(width: dimen.dp(8)),
            InAppText("&", style: counterStyle),
            SizedBox(width: dimen.dp(8)),
            CountableBuilder<FeedCommentCubit, FeedComment>(
              builder: (context, value) {
                return InAppText(
                  Converter.toKMB(value, "Comment", "Comments"),
                  style: counterStyle,
                );
              },
            ),
            SizedBox(width: dimen.dp(16)),
          ],
        ),
        SizedBox(height: dimen.dp(12)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: dimen.dp(8)),
            ExistByMeBuilder<FeedLikeCubit, FeedLike>(
              index: widget.index,
              builder: (context, value, toggle) {
                return InAppPleasureButton(
                  icon:
                      value ? InAppIcons.heart.solid : InAppIcons.heart.regular,
                  iconSize: dimen.dp(28),
                  iconColor: value ? context.red : dark.t50,
                  onTap: toggle,
                );
              },
            ),
            ExistByMeBuilder<FeedStarCubit, FeedStar>(
              index: widget.index,
              builder: (context, value, toggle) {
                return InAppPleasureButton(
                  icon: value ? InAppIcons.star.solid : InAppIcons.star.regular,
                  iconSize: dimen.dp(28),
                  iconColor: value ? context.yellow : dark.t50,
                  onTap: toggle,
                );
              },
            ),
            SizedBox(width: dimen.dp(8)),
            Expanded(
              child: InAppGesture(
                onTap: () {},
                child: FeedCommentBox(id: widget.id, path: widget.path),
              ),
            ),
            SizedBox(width: dimen.dp(16)),
          ],
        ),
      ],
    );
  }
}
