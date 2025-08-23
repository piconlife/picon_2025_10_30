import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/placeholders.dart';
import '../../../../data/enums/feed_type.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_footer.dart';
import 'feed_header.dart';

class ItemUserFeedBusiness extends StatefulWidget {
  final UserPost item;
  final Function(BuildContext context, UserPost item)? onClick;

  const ItemUserFeedBusiness({super.key, required this.item, this.onClick});

  @override
  State<ItemUserFeedBusiness> createState() => _ItemUserFeedBusinessState();
}

class _ItemUserFeedBusinessState extends State<ItemUserFeedBusiness> {
  @override
  Widget build(BuildContext context) {
    if (widget.item.contents.use.isEmpty) return const SizedBox();
    return ColoredBox(
      color: context.light,
      child: Column(
        children: [
          InAppUserBuilder(
            id: widget.item.publisherId,
            builder: (context, user) {
              return UserFeedHeader(
                avatar: user.photo,
                title: user.name,
                subtitle: FeedType.business.value,
                actions: [FeedHeaderMoreAction(onClick: () {})],
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

class _Body extends StatefulWidget {
  final UserPost item;

  const _Body({required this.item});

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  bool _expand = false;
  Map<int, bool> isTextExpands = {};

  @override
  Widget build(BuildContext context) {
    final roots = widget.item.contents.use;
    final items = _expand ? roots : roots.take(1);
    return ColoredBox(
      color: context.dark.t02,
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length + 1,
        itemBuilder: (context, index) {
          final content = items.elementAtOrNull(index);
          if (content != null) {
            return _Content(
              item: content,
              index: index,
              isExpanded: isTextExpands[index] ?? false,
              onChanged: (value) => isTextExpands[index] = value,
            );
          } else {
            return _Increment(
              expanded: _expand,
              onClick: (value) => setState(() => _expand = value),
            );
          }
        },
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final bool isExpanded;
  final Content item;
  final int index;
  final ValueChanged<bool>? onChanged;

  const _Content({
    required this.item,
    required this.index,
    required this.isExpanded,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final yellow = context.yellow;
    final divider = dark.t05;
    return AndrossyFlex(
      flexible: Container(
        width: dimen.dp(30),
        margin: EdgeInsets.symmetric(horizontal: dimen.dp(17)),
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
              decoration: BoxDecoration(color: yellow, shape: BoxShape.circle),
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
              item.timeMills.toDate(dateFormat: DateFormats.monthShortName),
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
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(
          left: dimen.dp(64),
          right: dimen.dp(16),
          top: dimen.dp(16),
        ),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(dimen.dp(25)),
              child: AndrossyImageGrid(
                itemSpace: dimen.dp(2),
                itemBackground: dark.t05,
                itemCount: item.photoUrls?.length ?? 0,
                itemBuilder: (context, index) {
                  final image = item.photoUrls?.elementAtOrNull(index);
                  return InAppGesture(
                    scalerLowerBound: 1,
                    onTap: () {},
                    child: InAppImage(
                      image ?? InAppPlaceholders.image,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: dimen.dp(8)),
            SizedBox(
              width: double.infinity,
              child: AndrossyExpandableText(
                item.description.use,
                initial: 50,
                style: TextStyle(fontSize: dimen.dp(18), color: dark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Increment extends StatelessWidget {
  final bool expanded;
  final ValueChanged<bool>? onClick;

  const _Increment({required this.expanded, required this.onClick});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final yellow = context.yellow;
    final divider = dark.t05;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(width: dimen.dp(17)),
        SizedBox(
          width: dimen.dp(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              InAppGesture(
                onTap: onClick != null ? () => onClick!(!expanded) : null,
                child: AspectRatio(
                  aspectRatio: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: yellow,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(dimen.dp(4)),
                      child: InAppIcon(
                        expanded
                            ? InAppIcons.arrowSmallUp.regular
                            : InAppIcons.arrowSmallDown.regular,
                        size: dimen.dp(22),
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: dimen.dp(4)),
              Container(
                width: dimen.dp(4),
                height: dimen.dp(12),
                decoration: BoxDecoration(
                  color: divider,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(dimen.dp(25)),
                    topLeft: Radius.circular(dimen.dp(25)),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: dimen.dp(16)),
        InAppGesture(
          onTap: onClick != null ? () => onClick!(!expanded) : null,
          child: Container(
            width: dimen.dp(100),
            height: dimen.dp(30),
            decoration: BoxDecoration(
              color: yellow.t10,
              borderRadius: BorderRadius.circular(dimen.dp(10)),
            ),
            alignment: Alignment.center,
            child: InAppText(
              expanded ? "Less" : "More",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, color: yellow),
            ),
          ),
        ),
      ],
    );
  }
}
