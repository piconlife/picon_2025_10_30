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
import '../../../../roots/widgets/hero.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../preview/view/pages/preview_photos.dart';
import '../widgets/menu_button.dart';
import 'feed_footer_recent.dart';
import 'feed_header.dart';
import 'stared_feed_footer.dart';

class ItemFeedPost extends StatefulWidget {
  final int index;
  final FeedModel item;
  final Function(BuildContext context, FeedModel item)? onClick;

  const ItemFeedPost({
    super.key,
    required this.index,
    required this.item,
    this.onClick,
  });

  @override
  State<ItemFeedPost> createState() => _ItemFeedPostState();
}

class _ItemFeedPostState extends State<ItemFeedPost> {
  String? _subtitle(UserModel user) {
    return widget.item.content.title.isNotValid
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
            id: widget.item.publisherId,
            builder: (context, user) {
              return FeedHeader(
                title: user.username,
                subtitle: _subtitle(user),
                avatar: user.photo,
                state: widget.item.uiState,
                actions: [
                  FeedHeaderMoreAction(index: widget.index, item: widget.item),
                ],
              );
            },
          ),
          _Body(item: widget.item),
          StaredFeedFooter(
            index: widget.index,
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
  final FeedModel item;

  const _Body({required this.item});

  Future<void> _preview(BuildContext context, int index) async {
    PreviewPhotosPage.open(context, item, index);
  }

  @override
  Widget build(BuildContext context) {
    final dark = context.dark;
    final dimen = context.dimens;
    return Column(
      children: [
        if (item.content.title.isValid) ...[
          Divider(height: 1, indent: dimen.dp(16), endIndent: dimen.dp(16)),
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
                    item.content.title,
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
        ],
        if (item.content.photos.use.isNotEmpty) ...[
          Divider(height: dimen.dp(1)),
          AndrossyImageGrid(
            itemBackground: dark.t05,
            itemCount: item.content.photos.use.length,
            itemBuilder: (context, index) {
              final image = item.content.photos.use.elementAtOrNull(index);
              return InAppGesture(
                onTap: () => _preview(context, index),
                child: InAppHero(
                  tag: image?.photoUrl,
                  child: InAppImage(
                    image?.photoUrl ?? InAppPlaceholders.image,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ],
        SizedBox(height: dimen.dp(12)),
        if (item.content.description.use.isNotEmpty) ...[
          Divider(height: dimen.dp(1)),
          Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
            child: AndrossyExpandableText(
              item.content.description.use,
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
