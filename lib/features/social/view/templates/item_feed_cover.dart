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
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_footer.dart';
import 'feed_header.dart';

class ItemFeedCover extends StatefulWidget {
  final Feed item;
  final Function(BuildContext context, Feed item)? onClick;

  const ItemFeedCover({super.key, required this.item, this.onClick});

  @override
  State<ItemFeedCover> createState() => _ItemFeedCoverState();
}

class _ItemFeedCoverState extends State<ItemFeedCover> {
  String _title(User user) {
    final date = DateHelper.toRealtime(widget.item.timeMills);
    if (widget.item.isPublisher) {
      return "Updated your cover photo at $date";
    } else {
      if (user.gender == Gender.male) {
        return "Update his cover photo at $date";
      } else {
        return "Update her cover photo at $date";
      }
    }
  }

  String? _subtitle(User user) {
    return !widget.item.title.isValid
        ? null
        : widget.item.title.isValid
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
            id: widget.item.publisherId,
            builder: (context, user) {
              return FeedHeader(
                title: _title(user),
                subtitle: _subtitle(user),
                avatar: user.photo,
                actions: [
                  FeedHeaderFollowButton(publisher: widget.item.publisherId),
                ],
              );
            },
          ),
          _Body(item: widget.item),
          FeedFooter(item: widget.item),
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
    final dimen = context.dimens;
    final dark = context.dark;
    final divider = dark.t05;
    return Column(
      children: [
        ColoredBox(
          color: dark.t02,
          child: AndrossyFlex(
            flexible: Padding(
              padding: EdgeInsets.only(left: dimen.dp(3)),
              child: SizedBox(
                width: dimen.dp(57),
                height: double.infinity,
                child: Column(
                  children: [
                    Container(
                      width: dimen.dp(4),
                      height: dimen.dp(10),
                      decoration: BoxDecoration(
                        color: divider,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(dimen.dp(25)),
                          bottomRight: Radius.circular(dimen.dp(25)),
                        ),
                      ),
                    ),
                    SizedBox(height: dimen.dp(4)),
                    Container(
                      width: dimen.dp(30),
                      height: dimen.dp(30),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: context.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: InAppText(
                        item.timeMills.toDate(dateFormat: DateFormats.day),
                        style: TextStyle(
                          fontSize: dimen.dp(14),
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    SizedBox(height: dimen.dp(4)),
                    InAppText(
                      item.timeMills.toDate(
                        dateFormat: DateFormats.monthShortName,
                      ),
                      style: TextStyle(
                        color: dark.t25,
                        fontSize: dimen.dp(12),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: dimen.dp(4)),
                    Expanded(
                      child: Container(
                        width: dimen.dp(4),
                        decoration: BoxDecoration(
                          color: divider,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(dimen.dp(25)),
                            topLeft: Radius.circular(dimen.dp(25)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            child: Padding(
              padding: EdgeInsets.only(
                left: dimen.dp(56 + 12),
                top: dimen.dp(16),
                bottom: dimen.dp(16),
                right: dimen.dp(16),
              ),
              child: InAppGesture(
                onTap: () {},
                splashBorderRadius: BorderRadius.circular(dimen.dp(28)),
                child: AspectRatio(
                  aspectRatio: 9 / 6,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: dark.t01,
                      border: Border.all(
                        color: Colors.white,
                        width: dimen.dp(4),
                      ),
                    ),
                    child: InAppImage(
                      item.photoUrlAt ?? InAppPlaceholders.image,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.description.isValid)
          SizedBox(
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: dimen.dp(16),
                vertical: dimen.dp(16 * 0.75),
              ),
              child: AndrossyExpandableText(
                item.description.use,
                style: TextStyle(
                  height: 1.45,
                  color: dark,
                  fontSize: dimen.dp(16),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
