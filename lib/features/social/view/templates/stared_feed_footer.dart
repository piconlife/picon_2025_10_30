import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:data_management/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/converter.dart';
import 'package:flutter_andomie/utils/validator.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/constants/keys.dart';
import '../../../../data/enums/privacy.dart';
import '../../../../data/models/feed_star.dart';
import '../../../../data/use_cases/feed_star/create.dart';
import '../../../../data/use_cases/feed_star/delete.dart';
import '../../../../data/use_cases/user_post/update.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';
import 'feed_comment_box.dart';

class StaredFeedFooter extends StatefulWidget {
  final String id;
  final String path;
  final int? likes;
  final List<String>? stars;
  final List<String>? comments;
  final void Function(List<String> likes) onLiked;
  final void Function(List<String> stars) onStared;

  const StaredFeedFooter({
    super.key,
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
  late final _observerLikes = widget.likes.use.obx;
  late final _observerStars = widget.stars.use.obx;

  Future<bool> _like(bool like) async {
    return false;
  }

  Future<bool> _star(bool value) {
    if (!value) {
      return CreateFeedStarUseCase.i(
        FeedStar.create(
          id: UserHelper.uid,
          parentId: widget.id,
          parentPath: widget.path,
          privacy: Privacy.onlyMe,
        ),
      ).then((value) {
        if (value.isSuccessful) {
          return UpdateUserPostUseCase.i(widget.id, {
            Keys.i.stars: DataFieldValue.arrayUnion([UserHelper.uid]),
          }).then((value) {
            return value.isSuccessful;
          });
        } else {
          return false;
        }
      });
    } else {
      return DeleteFeedStarUseCase.i(
        id: UserHelper.uid,
        path: widget.path.use,
      ).then((value) {
        if (value.isSuccessful) {
          return UpdateUserPostUseCase.i(widget.id, {
            Keys.i.stars: DataFieldValue.arrayRemove([UserHelper.uid]),
          }).then((value) {
            return value.isSuccessful;
          });
        } else {
          return false;
        }
      });
    }
  }

  void _updateLikes(BuildContext context, bool selected) async {
    _like(selected);
  }

  Future<void> _updateStars(BuildContext context, bool selected) async {
    _observerStars.toggle(UserHelper.uid, selected);
    widget.onStared(_observerStars.value);
    _star(selected);
  }

  @override
  void dispose() {
    _observerLikes.dispose();
    _observerStars.dispose();
    super.dispose();
  }

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
            AndrossyObserver(
              observer: _observerLikes,
              builder: (context, value) {
                return InAppText(
                  Converter.toKMB(value, "Like", "Likes"),
                  style: counterStyle,
                );
              },
            ),
            InAppText(",", style: counterStyle),
            SizedBox(width: dimen.dp(8)),
            AndrossyObserver(
              observer: _observerStars,
              builder: (context, value) {
                return InAppText(
                  Converter.toKMBFromList(value, "Star", "Stars"),
                  style: counterStyle,
                );
              },
            ),
            SizedBox(width: dimen.dp(8)),
            InAppText("&", style: counterStyle),
            SizedBox(width: dimen.dp(8)),
            InAppText(
              Converter.toKMBFromList(
                widget.comments.use,
                "Comment",
                "Comments",
              ),
              style: counterStyle,
            ),
            SizedBox(width: dimen.dp(16)),
          ],
        ),
        SizedBox(height: dimen.dp(12)),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: dimen.dp(8)),
            AndrossyObserver(
              observer: _observerLikes,
              builder: (context, value) {
                final activated = false;
                return InAppPleasureButton(
                  icon:
                      activated
                          ? InAppIcons.heart.solid
                          : InAppIcons.heart.regular,
                  iconSize: dimen.dp(28),
                  iconColor: activated ? context.red : dark.t50,
                  onTap: () => _updateLikes(context, activated),
                );
              },
            ),
            AndrossyObserver(
              observer: _observerStars,
              builder: (context, value) {
                final activated = Validator.isChecked(UserHelper.uid, value);
                return InAppPleasureButton(
                  icon:
                      activated
                          ? InAppIcons.star.solid
                          : InAppIcons.star.regular,
                  iconSize: dimen.dp(28),
                  iconColor: activated ? context.yellow : dark.t50,
                  onTap: () => _updateStars(context, activated),
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
