import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_androssy_kits/widgets.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user_post.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/user_builder.dart';
import 'feed_footer.dart';
import 'feed_header.dart';

class ItemUserFeedNote extends StatefulWidget {
  final PostModel item;
  final Function(BuildContext context, PostModel item)? onClick;

  const ItemUserFeedNote({super.key, required this.item, this.onClick});

  @override
  State<ItemUserFeedNote> createState() => _ItemUserFeedNoteState();
}

class _ItemUserFeedNoteState extends State<ItemUserFeedNote> {
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
                subtitle: widget.item.timeMills.toRealtime(),
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
    final quoteColor = dark.t25;
    final quoteSize = dimen.dp(24);
    return SizedBox(
      width: double.infinity,
      child: ColoredBox(
        color: dark.t02,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: dimen.dp(24),
              left: dimen.dp(24),
              child: InAppIcon(
                InAppIcons.quoteLeft.solid,
                color: quoteColor,
                size: quoteSize,
              ),
            ),
            Positioned(
              bottom: dimen.dp(24),
              right: dimen.dp(24),
              child: InAppIcon(
                InAppIcons.quoteRight.solid,
                color: quoteColor,
                size: quoteSize,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(dimen.dp(48)),
              child: AndrossyExpandableText(
                item.description ?? "No quote found!",
                initial: 150,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: dimen.dp(18),
                  color: dark,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
