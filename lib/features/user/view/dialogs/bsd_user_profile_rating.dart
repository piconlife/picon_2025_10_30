import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/text_button.dart';

class UserProfileRatingBSD extends StatelessWidget {
  final User user;

  const UserProfileRatingBSD({super.key, required this.user});

  static Future show(BuildContext context, User user) {
    return showModalBottomSheet(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      builder: (context) {
        return UserProfileRatingBSD(user: user);
      },
    );
  }

  List get flags {
    return [
      InAppIcons.star.solid,
      InAppIcons.heart.solid,
      InAppIcons.circle.solid,
      InAppIcons.circle.solid,
      InAppIcons.circle.solid,
    ];
  }

  List<String> get titles {
    return ["Star", "Heart", "User", "Warner", "Inactive"];
  }

  List<String> get subtitles {
    return [
      "Any time visit to ${AppConstants.name} with provide a PID Card",
      "Live Chatting with ${AppConstants.name} Owner",
      "Read and write any information",
      "Read only public information",
      "Inactive account with reader mode only",
    ];
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final index = 4 - (user.rating.toInt() - 1);
    final colors = [
      context.yellow,
      context.red,
      context.primary,
      context.warning,
      context.error,
    ];
    final color = colors.elementAt(index);

    return Container(
      width: double.infinity,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: context.dialogColor.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(dimen.dp(32)),
          topRight: Radius.circular(dimen.dp(32)),
        ),
        boxShadow: [
          BoxShadow(color: context.mid.t05, blurRadius: dimen.dp(50)),
        ],
      ),
      child: DraggableScrollableSheet(
        expand: false,
        snap: true,
        initialChildSize: 0.75,
        builder: (context, controller) {
          return ListView(
            controller: controller,
            padding: EdgeInsets.all(dimen.dp(16)),
            children: [
              Column(
                children: [
                  SizedBox(height: dimen.dp(40)),
                  CircleAvatar(
                    backgroundColor: color.t10,
                    radius: dimen.dp(60),
                    child: Padding(
                      padding: EdgeInsets.all(dimen.dp(24)),
                      child: InAppIcon(
                        flags.elementAtOrNull(index),
                        size: double.infinity,
                        color: color,
                      ),
                    ),
                  ),
                  SizedBox(height: dimen.dp(24)),
                  InAppText(
                    user.rating.toStringAsFixed(1),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: dark,
                      fontWeight: dimen.mediumFontWeight,
                      fontSize: dimen.dp(20),
                    ),
                  ),
                  SizedBox(height: dimen.dp(8)),
                  Container(
                    decoration: BoxDecoration(
                      color: color.t10,
                      borderRadius: BorderRadius.circular(dimen.dp(10)),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: dimen.dp(16),
                      vertical: dimen.dp(8),
                    ),
                    child: InAppText(
                      titles.elementAt(index).toUpperCase(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: color,
                        letterSpacing: 2,
                        height: 1,
                        fontWeight: dimen.boldFontWeight,
                        fontSize: dimen.dp(20),
                      ),
                    ),
                  ),
                  SizedBox(height: dimen.dp(8)),
                  InAppText(
                    subtitles.elementAt(index),
                    textAlign: TextAlign.center,
                    style: TextStyle(color: dark.t50, fontSize: dimen.dp(14)),
                  ),
                ],
              ),
              SizedBox(height: dimen.dp(16)),
              ...List.generate(titles.length, (index) {
                return _Child(
                  color: colors.elementAt(index),
                  title: titles.elementAt(index),
                  subtitle: subtitles.elementAt(index),
                  icon: flags.elementAtOrNull(index),
                  dimen: dimen,
                  selected: false,
                  rating: 5.0 - index,
                );
              }),
              dimen.dp(24).h,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: dimen.mediumMargin),
                child: InAppTextButton(
                  "Cancel",
                  backgroundColor: context.primary.t10,
                  borderRadius: BorderRadius.circular(dimen.normalCorner),
                  onTap: context.close,
                ),
              ),
              SizedBox(height: dimen.dp(32)),
            ],
          );
        },
      ),
    );
  }
}

class _Child extends StatelessWidget {
  final DimenData dimen;
  final Color? color;
  final dynamic icon;
  final String title;
  final String subtitle;
  final double rating;
  final bool selected;

  const _Child({
    this.color,
    this.icon,
    required this.dimen,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final dark = context.dark;
    final primary = color;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(dimen.dp(16)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: dimen.dp(22),
            backgroundColor: selected ? primary : primary.t10,
            child: InAppIcon(
              icon,
              size: dimen.dp(24),
              color: selected ? Colors.white : primary,
            ),
          ),
          dimen.dp(16).w,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InAppText(
                        title,
                        style: TextStyle(color: dark, fontSize: dimen.dp(18)),
                      ),
                    ),
                    InAppText(
                      rating.toStringAsFixed(1),
                      style: TextStyle(color: dark, fontSize: dimen.dp(18)),
                    ),
                  ],
                ),
                InAppText(
                  subtitle,
                  style: TextStyle(
                    color: dark.t50,
                    fontSize: dimen.normalFontSize,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
