import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/enums/content_state.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/menu_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import '../../../social/data/cubits/feed_home_cubit.dart';
import '../cubits/follower_cubit.dart';
import '../cubits/post_cubit.dart';

class UserPostHeader extends StatefulWidget {
  final UserPost item;
  final VoidCallback onTranslate;

  const UserPostHeader({
    super.key,
    required this.item,
    required this.onTranslate,
  });

  @override
  State<UserPostHeader> createState() => _UserPostHeaderState();
}

class _UserPostHeaderState extends State<UserPostHeader> {
  late UserFollowerCubit followerCubit = context.read();

  void _menu(String value) {
    switch (value) {
      case "edit":
        _edit(context);
        return;
      case "delete":
        _delete(context);
        return;
      case "share":
        _share(context);
        return;
      case "follow":
        _follow(context);
        return;
      case "copy":
        _copy(context);
        return;
      case "translate":
        _translate(context);
        return;
      case "download":
        _download(context);
        return;
      case "report":
        _report(context);
        return;
    }
  }

  Future<void> _delete(BuildContext context) async {
    context.read<UserPostCubit>().delete(widget.item);
  }

  Future<void> _edit(BuildContext context) async {
    context.open(
      Routes.createUserPost,
      args: {
        "$Content": widget.item,
        "$FeedHomeCubit": context.read<FeedHomeCubit>(),
        "$UserPostCubit": context.read<UserPostCubit>(),
      },
    );
  }

  Future<void> _share(BuildContext context) async {
    context.read<UserPostCubit>().share(context, widget.item.id);
  }

  Future<void> _follow(BuildContext context) async {
    context.read<UserPostCubit>().follow(context, widget.item.id);
  }

  Future<void> _copy(BuildContext context) async {
    context.read<UserPostCubit>().copy(context, widget.item.id);
  }

  Future<void> _translate(BuildContext context) async {
    widget.onTranslate();
  }

  Future<void> _download(BuildContext context) async {
    context.read<UserPostCubit>().download(context, widget.item.id);
  }

  Future<void> _report(BuildContext context) async {
    context.read<UserPostCubit>().report(context, widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    Widget child = Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: dimen.dp(12)),
      child: InAppUserBuilder(
        id: widget.item.publisherId,
        builder: (context, user) {
          final title =
              (widget.item.title.isValid
                  ? widget.item.isTranslated
                      ? widget.item.translatedTitle
                      : widget.item.title
                  : null) ??
              (widget.item.isPublisher ? UserHelper.username : user.username);
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(width: dimen.dp(12)),
              InAppAvatar(
                // url: widget.item.publisherPhoto,
                // isLocal: widget.item.isPublisher,
                user.photo,
              ),
              SizedBox(width: dimen.dp(16)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InAppText(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: dark,
                        fontSize: dimen.dp(16),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    InAppText(
                      widget.item.timeMills.toRealtime(),
                      style: TextStyle(
                        color: dark.withValues(alpha: 0.5),
                        fontSize: dimen.dp(14),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: dimen.dp(8)),
              InAppMenuButton<String>(
                onChanged: _menu,
                itemBuilder: (context) {
                  final isMe = widget.item.isPublisher;
                  return [
                    if (isMe)
                      PopupMenuItem(value: "edit", child: InAppText("Edit")),
                    if (isMe)
                      PopupMenuItem(
                        value: "delete",
                        child: InAppText("Delete"),
                      ),
                    if (!isMe)
                      PopupMenuItem(
                        value: "follow",
                        child: BlocBuilder<
                          UserFollowerCubit,
                          Response<Selection<UserFollower>>
                        >(
                          bloc: followerCubit,
                          builder: (context, response) {
                            final isFollowing =
                                response.result.firstWhereOrNull((e) {
                                  return UserHelper.isCurrentUser(e.data.uid);
                                }) !=
                                null;
                            return InAppText(
                              isFollowing ? "Following" : "Follow",
                            );
                          },
                        ),
                      ),
                    if (widget.item.isShareMode)
                      PopupMenuItem(value: "share", child: InAppText("Share")),
                    if (widget.item.isShareMode && widget.item.isDescription)
                      PopupMenuItem(value: "copy", child: InAppText("Copy")),
                    if (widget.item.isTranslatable)
                      PopupMenuItem(
                        value: "translate",
                        child: InAppText(
                          widget.item.isTranslated
                              ? "Translation cancel"
                              : "Translate",
                        ),
                      ),
                    if (widget.item.isShareMode && widget.item.isPhotoMode)
                      PopupMenuItem(
                        value: "download",
                        child: InAppText("Download"),
                      ),
                    if (!isMe)
                      PopupMenuItem(
                        value: "report",
                        child: InAppText(
                          false ? "Delete report" : "Send report",
                        ),
                      ),
                  ];
                },
              ),
              SizedBox(width: dimen.dp(4)),
            ],
          );
        },
      ),
    );
    if (widget.item.uiState.isProcessing) {
      child = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            child: InAppText("Processing..."),
          ),
          child,
        ],
      );
    }
    return child;
  }
}
