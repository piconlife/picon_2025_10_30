import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/placeholders.dart';
import '../../../../data/models/user.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_header.dart';
import 'stared_feed_footer.dart';

class ItemUserFeedVideo extends StatefulWidget {
  final UserPost item;
  final Function(BuildContext context, UserPost item)? onClick;

  const ItemUserFeedVideo({super.key, required this.item, this.onClick});

  @override
  State<ItemUserFeedVideo> createState() => _ItemUserFeedVideoState();
}

class _ItemUserFeedVideoState extends State<ItemUserFeedVideo> {
  String? _subtitle(User user) {
    return widget.item.title.isNotValid
        ? DateHelper.toRealtime(widget.item.timeMills)
        : user.title.isValid
        ? user.title
        : user.profession;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.light,
      child: Column(
        children: [
          InAppUserBuilder(
            id: widget.item.publisher,
            builder: (context, user) {
              return FeedHeader(
                title: user.username,
                subtitle: _subtitle(user),
                avatar: user.photo,
                actions: [FeedHeaderMoreAction()],
              );
            },
          ),
          _Body(item: widget.item),
          StaredFeedFooter(
            id: widget.item.id,
            path: widget.item.path.use,
            likes: widget.item.likes,
            stars: widget.item.stars,
            comments: widget.item.comments,
            onLiked: (value) {},
            onStared: (value) {},
          ),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final UserPost item;

  const _Body({required this.item});

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;
    return Column(
      children: [
        if (item.photoUrls.use.isNotEmpty)
          AndrossyThumbnail(
            item.photoUrl ?? InAppPlaceholders.image,
            frameColor: dark.t02,
            buttonBackgroundColor: context.light,
            buttonForegroundColor: context.primary,
            buttonShadowColor: dark.t25,
            buttonRadius: dimen.dp(20),
            onPlay: () {},
          ),
        if (item.title.isValid) ...[
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimen.dp(16),
                vertical: dimen.dp(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InAppText(
                    item.title,
                    style: TextStyle(color: dark, fontSize: dimen.dp(16)),
                  ),
                  InAppText(
                    item.timeMills.toRealtime(),
                    style: TextStyle(color: dark.t50, fontSize: dimen.dp(14)),
                  ),
                ],
              ),
            ),
          ),
          Divider(height: 1, indent: dimen.dp(16), endIndent: dimen.dp(16)),
        ],
        SizedBox(height: dimen.dp(12)),
        if (item.description.use.isNotEmpty) ...[
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
            child: AndrossyExpandableText(
              item.description.use,
              initial: 50,
              style: TextStyle(fontSize: dimen.dp(16), color: dark),
            ),
          ),
          SizedBox(height: dimen.dp(12)),
        ],
      ],
    );
  }
}
