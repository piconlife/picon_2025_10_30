import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/feed_like.dart';
import '../../../../roots/widgets/column.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../user/view/cubits/following_cubit.dart';
import '../widgets/follow_button.dart';

class ItemFeedLike extends StatefulWidget {
  final FeedLike data;

  const ItemFeedLike({super.key, required this.data});

  @override
  State<ItemFeedLike> createState() => _ItemFeedLikeState();
}

class _ItemFeedLikeState extends State<ItemFeedLike> {
  late final followCubit = context.read<UserFollowingCubit>();

  void _tap() {}

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final light = context.light;
    final secondary = context.secondary;
    return InAppUserBuilder(
      id: widget.data.id,
      builder: (context, user) {
        return Container(
          width: double.infinity,
          color: light,
          padding: EdgeInsets.all(dimen.dp(12)),
          child: InAppRow(
            spacing: dimen.dp(8),
            children: [
              SizedBox.square(
                dimension: dimen.mediumAvatar,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    InAppGesture(
                      onTap: _tap,
                      child: Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          color: dark.t05,
                          shape: BoxShape.circle,
                        ),
                        margin: EdgeInsets.only(
                          right: dimen.margin.smallest,
                          bottom: dimen.margin.smallest,
                        ),
                        child: InAppImage(user.avatar, fit: BoxFit.cover),
                      ),
                    ),
                    if (user.isHeartUser || user.isCelebrityUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: dimen.dp(20),
                          height: dimen.dp(20),
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(dimen.dp(3)),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: light,
                          ),
                          child: InAppIcon(
                            (user.isHeartUser
                                    ? InAppIcons.heart
                                    : InAppIcons.star)
                                .solid,
                            size: dimen.smallerIcon,
                            color: user.isHeartUser
                                ? context.red
                                : context.primary,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: InAppColumn(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppRow(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      spacing: dimen.dp(8),
                      children: [
                        Expanded(
                          child: InAppColumn(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (user.protectedName.isValid)
                                InAppGesture(
                                  onTap: _tap,
                                  child: InAppText(
                                    user.protectedName ?? user.username,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: dark,
                                      fontSize: dimen.fontSize.medium,
                                      fontWeight: dimen.boldFontWeight,
                                    ),
                                  ),
                                ),
                              InAppGesture(
                                onTap: _tap,
                                child: InAppText(
                                  user.username,
                                  prefix: user.protectedName.isValid
                                      ? "@"
                                      : null,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                  style: TextStyle(
                                    color: dark.t50,
                                    fontSize: dimen.fontSize.medium,
                                    fontWeight: dimen.mediumFontWeight,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (!user.isCurrentUser)
                          InAppFollowBuilder(
                            id: user.id,
                            builder: (context, isFollowing, callback) {
                              final x = isFollowing;
                              return InAppGesture(
                                scalerLowerBound: 1,
                                onTap: callback,
                                child: Container(
                                  width: dimen.dp(90),
                                  height: dimen.dp(30),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isFollowing
                                        ? secondary.t10
                                        : secondary,
                                    borderRadius: BorderRadius.circular(
                                      dimen.largeCorner,
                                    ),
                                  ),
                                  child: isFollowing
                                      ? InAppIcon(
                                          InAppIcons.nativeCheckMark.regular,
                                          color: secondary,
                                        )
                                      : InAppText(
                                          "Follow",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: light,
                                            fontSize: dimen.fontSize.normal,
                                            fontWeight: dimen.mediumFontWeight,
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                    if (user.protectedBio.isValid)
                      InAppText(
                        user.protectedBio,
                        prefix: user.protectedProfession.isValid
                            ? "${user.protectedProfession} - "
                            : null,
                        prefixStyle: TextStyle(color: dark.t50),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                        style: TextStyle(color: dark, fontSize: 14),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
