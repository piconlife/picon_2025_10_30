import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../app/res/icons.dart';
import '../../../../app/res/placeholders.dart';
import '../../../../roots/widgets/avatar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';
import '../widgets/follow_button.dart';

class FeedHeader extends StatelessWidget {
  final String? avatar;
  final String? title;
  final String? subtitle;
  final List<Widget> actions;

  const FeedHeader({
    super.key,
    required this.avatar,
    required this.title,
    required this.subtitle,
    this.actions = const [],
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: dimen.dp(12)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(width: dimen.dp(12)),
          InAppAvatar(
            avatar ?? InAppPlaceholders.user,
            backgroundColor: dark.withValues(alpha: 0.1),
          ),
          SizedBox(width: dimen.dp(16)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InAppText(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: dark,
                    fontSize: dimen.dp(16),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                InAppText(
                  subtitle,
                  style: TextStyle(
                    color: dark.withValues(alpha: 0.5),
                    fontSize: dimen.dp(14),
                  ),
                ),
              ],
            ),
          ),
          ...actions,
          SizedBox(width: dimen.dp(4)),
        ],
      ),
    );
  }
}

class FeedHeaderMoreAction extends StatelessWidget {
  final VoidCallback? onClick;

  const FeedHeaderMoreAction({super.key, this.onClick});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return InAppGesture(
      onTap: onClick,
      backgroundColor: Colors.transparent,
      shape: const CircleBorder(),
      splashColor: context.dark.t05,
      child: Padding(
        padding: EdgeInsets.all(dimen.dp(8)),
        child: InAppIcon(
          InAppIcons.nativeMoreY.regular,
          size: dimen.dp(24),
          color: context.dark.t50,
        ),
      ),
    );
  }
}

class FeedHeaderFollowButton extends StatelessWidget {
  final String? publisher;

  const FeedHeaderFollowButton({super.key, required this.publisher});

  @override
  Widget build(BuildContext context) {
    if (publisher == null || publisher!.isEmpty) return SizedBox();
    final dimen = context.dimens;
    final dark = context.dark;
    final primary = context.primary;
    return InAppFollowBuilder(
      id: publisher!,
      builder: (context, isFollowing, callback) {
        final splashColor = isFollowing ? dark.t05 : primary.t05;
        return InAppGesture(
          splashColor: splashColor,
          highlightColor: splashColor,
          backgroundColor: Colors.transparent,
          splashBorderRadius: BorderRadius.circular(dimen.dp(50)),
          onTap: callback,
          child: Padding(
            padding: EdgeInsets.all(dimen.dp(8)),
            child: InAppIcon(
              isFollowing
                  ? InAppIcons.alreadyFollow.regular
                  : InAppIcons.addFollow.regular,
              color: isFollowing ? dark.t25 : context.primary,
              size: dimen.dp(24),
            ),
          ),
        );
      },
    );
  }
}
