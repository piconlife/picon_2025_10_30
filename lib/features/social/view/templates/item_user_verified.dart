import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions.dart';
import 'package:flutter_andomie/models/selection.dart';

import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/image.dart';
import '../../../../roots/widgets/text.dart';

class ItemVerifiedUser extends StatelessWidget {
  final Selection<User> selection;
  final VoidCallback? onTap;
  final VoidCallback? onFollow;

  const ItemVerifiedUser({
    super.key,
    required this.selection,
    this.onTap,
    this.onFollow,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final light = context.light;
    final secondary = context.secondary;
    final user = selection.data;
    return Container(
      width: double.infinity,
      color: light,
      padding: EdgeInsets.symmetric(
        horizontal: dimen.normalPadding,
        vertical: dimen.normalPadding,
      ),
      child: Row(
        children: [
          SizedBox.square(
            dimension: dimen.mediumAvatar,
            child: Stack(
              fit: StackFit.expand,
              children: [
                InAppGesture(
                  onTap: onTap,
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
                        (user.isHeartUser ? InAppIcons.heart : InAppIcons.star)
                            .solid,
                        size: dimen.smallerIcon,
                        color: user.isHeartUser ? context.red : context.primary,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: dimen.dp(8)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          InAppGesture(
                            onTap: onTap,
                            child: InAppText(
                              user.name,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              style: TextStyle(
                                color: dark,
                                fontSize: dimen.fontSize.medium,
                                fontWeight: dimen.boldFontWeight,
                              ),
                            ),
                          ),
                          if (user.username.isValid)
                            InAppGesture(
                              onTap: onTap,
                              child: InAppText(
                                user.username,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: dark.t50,
                                  fontSize: dimen.fontSize.normal,
                                  fontWeight: dimen.mediumFontWeight,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                    SizedBox(width: dimen.dp(8)),
                    InAppGesture(
                      scalerLowerBound: 1,
                      onTap: onFollow,
                      child: Container(
                        width: dimen.dp(90),
                        height: dimen.dp(35),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: selection.selected ? secondary.t10 : secondary,
                          borderRadius: BorderRadius.circular(
                            dimen.largeCorner,
                          ),
                        ),
                        child:
                            selection.selected
                                ? InAppIcon(
                                  InAppIcons.nativeCheckMark.regular,
                                  color: secondary,
                                )
                                : InAppText(
                                  "Add",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: light,
                                    fontSize: dimen.fontSize.normal,
                                    fontWeight: dimen.mediumFontWeight,
                                  ),
                                ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
