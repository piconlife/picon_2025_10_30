import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/utils/date_helper.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/res/placeholders.dart';
import '../../../../data/enums/gender.dart';
import '../../../../data/models/content.dart';
import '../../../../data/models/feed.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/padding.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import 'feed_footer.dart';
import 'feed_header.dart';

class ItemFeedAvatar extends StatelessWidget {
  final int index;
  final Feed item;
  final Function(BuildContext context, Feed item)? onClick;

  const ItemFeedAvatar({
    super.key,
    required this.index,
    required this.item,
    this.onClick,
  });

  String _title(User user) {
    final date = DateHelper.toRealtime(item.timeMills);
    if (item.isPublisher) {
      return "Updated your profile photo at $date";
    } else {
      if (user.gender == Gender.male) {
        return "Update his profile photo at $date";
      } else {
        return "Update her profile photo at $date";
      }
    }
  }

  String? _subtitle(User user) {
    return !item.title.isValid
        ? null
        : item.title.isValid
        ? user.title
        : user.profession;
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: context.light,
      child: InAppColumn(
        children: [
          InAppUserBuilder(
            id: item.publisherId,
            builder: (context, user) {
              return FeedHeader(
                title: _title(user),
                subtitle: _subtitle(user),
                avatar: user.photo,
                actions: [FeedHeaderFollowButton(publisher: item.publisherId)],
              );
            },
          ),
          _Body(item: item),
          FeedFooter(item: item),
        ],
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Feed item;

  const _Body({required this.item});

  Future<void> _preview(BuildContext context, int index) async {
    context.open(
      Routes.previewPhotos,
      args: {"$Content": item, "index": index},
    );
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final divider = dark.t05;
    return InAppColumn(
      children: [
        ColoredBox(
          color: dark.t02,
          child: AndrossyFlex(
            flexible: InAppPadding(
              padding: EdgeInsets.only(left: dimen.dp(3)),
              child: SizedBox(
                width: dimen.dp(57),
                height: double.infinity,
                child: InAppColumn(
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
            child: InAppPadding(
              padding: EdgeInsets.only(
                left: dimen.dp(64),
                top: dimen.dp(32),
                bottom: dimen.dp(32),
                right: dimen.dp(32),
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: InAppGesture(
                  onTap: () => _preview(context, 0),
                  child: InAppAvatar(
                    item.photoUrl ?? InAppPlaceholders.image,
                    borderColor: Colors.white,
                    borderSize: dimen.dp(4),
                    backgroundColor: dark.t01,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (item.description.isValid)
          SizedBox(
            width: double.infinity,
            child: InAppPadding(
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
