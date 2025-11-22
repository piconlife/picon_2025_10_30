import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/iterator.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';
import 'package:picon/routes/paths.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../roots/widgets/menu_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../user/view/cubits/follower_cubit.dart';
import '../../../user/view/cubits/post_cubit.dart';
import '../../data/cubits/feed_home_cubit.dart';

class FeedHeaderMoreAction extends StatefulWidget {
  final int index;
  final FeedModel item;
  final VoidCallback? onTranslate;

  const FeedHeaderMoreAction({
    super.key,
    required this.index,
    required this.item,
    this.onTranslate,
  });

  @override
  State<FeedHeaderMoreAction> createState() => _FeedHeaderMoreActionState();
}

class _FeedHeaderMoreActionState extends State<FeedHeaderMoreAction> {
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
    context.read<FeedHomeCubit>().deletes(context, widget.index, widget.item);
  }

  Future<void> _edit(BuildContext context) async {
    context.open(
      Routes.createUserPost,
      args: {
        "$ContentModel": widget.item,
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
    widget.onTranslate?.call();
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
    return InAppMenuButton<String>(
      onChanged: _menu,
      itemBuilder: (context) {
        final isMe = widget.item.isPublisher;
        return [
          if (isMe) PopupMenuItem(value: "edit", child: InAppText("Edit")),
          if (isMe) PopupMenuItem(value: "delete", child: InAppText("Delete")),
          if (!isMe)
            PopupMenuItem(
              value: "follow",
              child: BlocBuilder<
                UserFollowerCubit,
                Response<Selection<FollowerModel>>
              >(
                bloc: followerCubit,
                builder: (context, response) {
                  final isFollowing =
                      response.result.firstWhereOrNull((e) {
                        return UserHelper.isCurrentUser(e.data.uid);
                      }) !=
                      null;
                  return InAppText(isFollowing ? "Following" : "Follow");
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
                widget.item.isTranslated ? "Translation cancel" : "Translate",
              ),
            ),
          if (widget.item.isShareMode && widget.item.isPhotoMode)
            PopupMenuItem(value: "download", child: InAppText("Download")),
          if (!isMe)
            PopupMenuItem(
              value: "report",
              child: InAppText(false ? "Delete report" : "Send report"),
            ),
        ];
      },
    );
    // return InAppGesture(
    //   onTap: widget.onClick,
    //   backgroundColor: Colors.transparent,
    //   shape: const CircleBorder(),
    //   splashColor: context.dark.t05,
    //   child: Padding(
    //     padding: EdgeInsets.all(dimen.dp(8)),
    //     child: InAppIcon(
    //       InAppIcons.nativeMoreY.regular,
    //       size: dimen.dp(24),
    //       color: context.dark.t50,
    //     ),
    //   ),
    // );
  }
}
