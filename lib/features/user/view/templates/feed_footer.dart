import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/pleasure_button.dart';
import '../../../../roots/widgets/text.dart';

class UserFeedFooter extends StatefulWidget {
  final UserPost item;
  final void Function(List<String> likes) onLiked;

  const UserFeedFooter({super.key, required this.item, required this.onLiked});

  @override
  State<UserFeedFooter> createState() => _UserFeedFooterState();
}

class _UserFeedFooterState extends State<UserFeedFooter> {
  late final _observerLikes = widget.item.likes.use.obx;

  Future<bool> _like(bool like) async {
    return false;
  }

  void _updateLikes(BuildContext context, bool selected) async {
    _observerLikes.toggle(UserHelper.uid, selected);
    widget.onLiked(_observerLikes.value);
    _like(selected);
  }

  @override
  void dispose() {
    _observerLikes.dispose();
    super.dispose();
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
          AndrossyObserver(
            observer: _observerLikes,
            builder: (context, value) {
              final activated = Validator.isChecked(UserHelper.uid, value);
              return InAppPleasureButton(
                icon: activated
                    ? InAppIcons.heart.solid
                    : InAppIcons.heart.regular,
                iconSize: dimen.dp(26),
                iconColor: activated ? context.red : dark.t50,
                onTap: () => _updateLikes(context, activated),
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
          AndrossyObserver(
            observer: _observerLikes,
            builder: (context, value) {
              return InAppText(
                Converter.toKMBFromList(value, "Like", "Likes"),
                style: counterStyle,
              );
            },
          ),
          SizedBox(width: dimen.dp(8)),
          InAppText("&", style: counterStyle),
          SizedBox(width: dimen.dp(8)),
          InAppText(
            Converter.toKMBFromList(
              widget.item.comments.use,
              "Comment",
              "Comments",
            ),
            style: counterStyle,
          ),
        ],
      ),
    );
  }
}
