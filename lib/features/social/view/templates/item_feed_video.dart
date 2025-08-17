import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/placeholders.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_footer_recent.dart';
import 'feed_header.dart';
import 'stared_feed_footer.dart';

class ItemFeedVideo extends StatefulWidget {
  final Feed item;
  final Function(BuildContext context, Feed item)? onClick;

  const ItemFeedVideo({super.key, required this.item, this.onClick});

  @override
  State<ItemFeedVideo> createState() => _ItemFeedVideoState();
}

class _ItemFeedVideoState extends State<ItemFeedVideo> {
  String? _subtitle(User user) {
    return widget.item.title.isNotValid
        ? DateHelper.toRealtime(widget.item.timeMills)
        : user.title.isValid
        ? user.title
        : user.profession;
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
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
            onLiked: (value) {},
            onStared: (value) {},
          ),
          SizedBox(height: dimen.dp(8)),
          if (widget.item.recent.title.isValid) ...[
            SizedBox(height: dimen.dp(8)),
            InAppGesture(
              onTap: () {},
              child: FooterRecentFeed(
                image: widget.item.recent.photoUrl,
                title: widget.item.recent.title,
                description: widget.item.recent.description,
              ),
            ),
            SizedBox(height: dimen.dp(8)),
          ],
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Feed item;

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
