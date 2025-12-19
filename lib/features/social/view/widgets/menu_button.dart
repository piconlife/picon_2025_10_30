import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/iterator.dart';
import 'package:flutter_andomie/helpers/clipboard_helper.dart';
import 'package:flutter_andomie/models/selection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_entity/entity.dart';
import 'package:in_app_navigator/route.dart';
import 'package:picon/routes/paths.dart';

import '../../../../app/helpers/user.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user_follower.dart';
import '../../../../roots/utils/utils.dart';
import '../../../../roots/widgets/menu_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../user/view/cubits/follower_cubit.dart';
import '../../../user/view/cubits/post_cubit.dart';
import '../../data/cubits/feed_home_cubit.dart';

class FeedHeaderMoreAction extends StatefulWidget {
  final int index;
  final ContentModel item;
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
    if (widget.item is! FeedModel) return;
    context.read<FeedHomeCubit>().deletes(
      context,
      widget.index,
      widget.item as FeedModel,
    );
  }

  Future<void> _edit(BuildContext context) async {
    context.open(Routes.createUserPost, args: {"$ContentModel": widget.item});
  }

  Future<void> _share(BuildContext context) async {
    if (!widget.item.isShareMode) {
      return;
    }
    Utils.share(
      context,
      subject:
          widget.item.isTranslated
              ? widget.item.translatedTitle ?? widget.item.title
              : widget.item.title,
      body:
          widget.item.isTranslated
              ? widget.item.translatedDescription ?? widget.item.description
              : widget.item.description,
      urls: widget.item.photoUrls,
    );
  }

  Future<void> _follow(BuildContext context) async {
    // context.read<UserFollowerCubit>().toggle(widget.item.id);
  }

  Future<void> _copy(BuildContext context) async {
    if (!widget.item.isShareMode) return;
    if (!widget.item.isDescription) return;
    final title =
        widget.item.isTranslated
            ? widget.item.translatedTitle ?? widget.item.title ?? ''
            : widget.item.title ?? '';
    final description =
        widget.item.isTranslated
            ? widget.item.translatedDescription ?? widget.item.description ?? ''
            : widget.item.description ?? '';
    ClipboardHelper.setText(
      title.isEmpty
          ? description
          : description.isEmpty
          ? title
          : "$title\n\n$description",
    );
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
          if (widget.item.isTranslatable && widget.onTranslate != null)
            PopupMenuItem(
              value: "translate",
              child: InAppText(
                widget.item.isTranslated ? "Translation Cancel" : "Translate",
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
