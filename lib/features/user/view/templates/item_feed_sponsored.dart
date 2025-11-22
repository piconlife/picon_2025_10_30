import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_footer.dart';
import 'feed_header.dart';

class ItemUserFeedSponsored extends StatefulWidget {
  final PostModel item;
  final Function(BuildContext context, PostModel item)? onClick;

  const ItemUserFeedSponsored({super.key, required this.item, this.onClick});

  @override
  State<ItemUserFeedSponsored> createState() => _ItemUserFeedSponsoredState();
}

class _ItemUserFeedSponsoredState extends State<ItemUserFeedSponsored> {
  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.light,
      child: Column(
        children: [
          InAppUserBuilder(
            id: widget.item.publisherId,
            builder: (context, user) {
              return UserFeedHeader(
                title: user.name,
                subtitle: FeedType.sponsored.value,
                avatar: user.photo,
                actions: [FeedHeaderMoreAction()],
              );
            },
          ),
          _Body(item: widget.item),
          UserFeedFooter(item: widget.item, onLiked: (value) {}),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final PostModel item;

  const _Body({required this.item});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final yellow = context.yellow;
    final divider = dark.t05;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (item.photoUrls.isNotEmpty)
          AndrossySlider(
            frameRatio: 9 / 9,
            itemCount: item.photoUrls.use.length,
            builder: (context, index) {
              return InAppGesture(
                onTap: () {},
                scalerLowerBound: 1,
                child: InAppImage(
                  item.photoUrls.use.elementAt(index),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: dimen.dp(20)),
                width: dimen.dp(4),
                height: dimen.dp(12),
                decoration: BoxDecoration(
                  color: divider,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(dimen.dp(25)),
                    bottomRight: Radius.circular(dimen.dp(25)),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: dimen.dp(8),
                  vertical: dimen.dp(8),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    InAppIcon(
                      InAppIcons.info.regular,
                      size: dimen.dp(30),
                      color: yellow,
                    ),
                    SizedBox(width: dimen.dp(16)),
                    InAppGesture(
                      onTap: () {},
                      child: Container(
                        width: dimen.dp(100),
                        height: dimen.dp(30),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: yellow.t10,
                          borderRadius: BorderRadius.circular(dimen.dp(10)),
                        ),
                        child: InAppText(
                          "Visit",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: yellow,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              if (item.description.isValid)
                Container(
                  margin: EdgeInsets.only(left: dimen.dp(20)),
                  width: dimen.dp(4),
                  height: dimen.dp(12),
                  decoration: BoxDecoration(
                    color: divider,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(dimen.dp(25)),
                      topRight: Radius.circular(dimen.dp(25)),
                    ),
                  ),
                ),
            ],
          ),
        ),
        if (item.description.isValid)
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: dimen.dp(12)),
            decoration: BoxDecoration(
              color: dark.t02,
              border: Border(
                left: BorderSide(width: dimen.dp(4), color: divider),
                right: BorderSide(width: dimen.dp(0.1), color: divider),
                top: BorderSide(width: dimen.dp(2), color: divider),
                bottom: BorderSide(width: dimen.dp(2), color: divider),
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(dimen.dp(16)),
                topLeft: Radius.circular(dimen.dp(16)),
              ),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: dimen.dp(16),
              vertical: dimen.dp(16 * 0.75),
            ),
            child: AndrossyExpandableText(
              item.description.use,
              initial: 50,
              style: TextStyle(
                color: dark,
                fontSize: dimen.dp(16),
                height: 1.4,
              ),
            ),
          ),
      ],
    );
  }
}
