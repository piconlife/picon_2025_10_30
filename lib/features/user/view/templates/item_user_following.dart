import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user_following.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../social/view/widgets/follow_button.dart';

class ItemUserFollowing extends StatelessWidget {
  final FollowingModel data;

  const ItemUserFollowing({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final light = context.light;
    final primary = context.secondary;
    return InAppUserBuilder(
      id: data.id,
      builder: (context, user) {
        return Container(
          width: double.infinity,
          color: light,
          padding: EdgeInsets.symmetric(
            horizontal: dimen.normalPadding,
            vertical: dimen.normalPadding,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox.square(
                dimension: dimen.mediumAvatar,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Container(
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
                    if (user.isHeartUser || user.isCelebrityUser)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          alignment: Alignment.center,
                          padding: EdgeInsets.all(dimen.smallerPadding),
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
                            color:
                                user.isHeartUser ? context.red : context.yellow,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: dimen.mediumMargin),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InAppText(
                      user.name,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: dark,
                        fontSize: dimen.fontSize.medium,
                        fontWeight: dimen.mediumFontWeight,
                      ),
                    ),
                    SizedBox(height: dimen.margin.smaller),
                    InAppText(
                      user.username,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                      style: TextStyle(
                        color: dark.t50,
                        fontSize: dimen.fontSize.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: dimen.smallMargin),
              InAppFollowBuilder(
                id: data.id,
                builder: (context, isFollowing, callback) {
                  return InAppGesture(
                    onTap: callback,
                    scalerLowerBound: 1,
                    fadeLowerBound: 1,
                    child: Container(
                      width: dimen.dp(90),
                      height: dimen.dp(35),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: isFollowing ? primary.t10 : primary,
                        borderRadius: BorderRadius.circular(dimen.largeCorner),
                      ),
                      child: InAppText(
                        isFollowing ? "Following" : "Follow",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isFollowing ? primary : light,
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
        );
      },
    );
  }
}
