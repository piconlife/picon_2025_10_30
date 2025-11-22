import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/base/data_cubit.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/feed_comment.dart';
import '../../../../data/models/like.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../../user/view/cubits/following_cubit.dart';
import '../../data/cubits/like_cubit.dart';
import '../cubits/comment_cubit.dart';

class FeedFooter extends StatefulWidget {
  final Feed item;

  const FeedFooter({super.key, required this.item});

  @override
  State<FeedFooter> createState() => _FeedFooterState();
}

class _FeedFooterState extends State<FeedFooter> {
  late final likeCubit = DataCubit.of<LikeCubit>(context);
  late final commentCubit = DataCubit.of<CommentCubit>(context);

  void _like() => likeCubit.toggle();

  void _seeLikes() {
    context.open(
      Routes.likes,
      args: {
        "$LikeCubit": context.read<LikeCubit>(),
        "$UserFollowingCubit": context.read<UserFollowingCubit>(),
      },
    );
  }

  void _seeComments() {
    context.open(
      Routes.comments,
      args: {
        "$CommentCubit": context.read<CommentCubit>(),
        "$UserFollowingCubit": context.read<UserFollowingCubit>(),
      },
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
          BlocBuilder<LikeCubit, Response<LikeModel>>(
            builder: (context, value) {
              final activated = value.resultByMe.isNotEmpty;
              return InAppPleasureButton(
                icon:
                    activated
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
          BlocBuilder<LikeCubit, Response<LikeModel>>(
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
          BlocBuilder<CommentCubit, Response<CommentModel>>(
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
