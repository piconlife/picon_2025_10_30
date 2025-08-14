import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/constants/app.dart';
import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/res/size.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/styled_button.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../roots/widgets/tiled_button.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../roots/widgets/user_builder.dart';
import '../../../../routes/paths.dart';
import '../../../social/view/cubits/follower_cubit.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  void _visitAboutUs(BuildContext context) {
    context.open(Routes.info);
  }

  void _visitProfile(BuildContext context, User? user) {
    if (user == null) return;
    context.open(
      Routes.userProfile,
      arguments: {
        "$FollowerCubit": context.read<FollowerCubit>(),
        "$User": user,
      },
    );
  }

  void _visitStore(BuildContext context) {
    context.open(Routes.userGrocery);
  }

  void _visitShop(BuildContext context) {
    context.open(Routes.userMarket);
  }

  void _visitByName(BuildContext context, String route) {
    context.open(route);
  }

  void _visitSettings(BuildContext context) {
    context.open(Routes.settings);
  }

  void _logout(BuildContext context) {
    UserHelper.signOut(context, Routes.main);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    final color = context.dark;
    final bg = context.isDarkMode ? Colors.white.t05 : Colors.white;
    return Scaffold(
      appBar: const InAppAppbar(titleText: "Me"),
      body: ListView(
        children: [
          ColoredBox(
            color: bg,
            child: Column(
              children: [
                InAppUserBuilder(
                  currentUser: true,
                  builder: (context, user) {
                    return InAppGesture(
                      onTap: () => _visitProfile(context, user),
                      child: Container(
                        color: Colors.transparent,
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          horizontal: dimen.dp(16),
                          vertical: dimen.dp(12),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InAppUserAvatar(
                              url: user.avatar,
                              size: InAppSizes.avatarSizeMedium,
                              border: dimen.dp(2),
                              borderColor: context.light,
                              onTap: () => _visitProfile(context, user),
                            ),
                            dimen.dp(16).w,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InAppText(
                                    user.name ?? "Unknown name",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(fontSize: dimen.dp(18)),
                                  ),
                                  InAppText(
                                    user.email ?? "support@picon.com",
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: color.t50,
                                      fontSize: dimen.dp(14),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (user.verified.use) ...[
                              dimen.dp(16).w,
                              InAppIcon(
                                InAppIcons.shieldCheck.bold,
                                color: primary,
                                size: dimen.dp(24),
                              ),
                            ],
                          ],
                        ),
                      ),
                    );
                  },
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: InAppStyledButton(
                          text: "Store",
                          background: primary,
                          onTap: () => _visitStore(context),
                        ),
                      ),
                      Expanded(
                        child: InAppStyledButton(
                          text: "Shop",
                          background: context.secondary,
                          onTap: () => _visitShop(context),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          dimen.dp(8).h,
          ColoredBox(
            color: bg,
            child: Column(
              children: List.generate(MeIconContent.items.length, (i) {
                final e = MeIconContent.items.elementAt(i);
                return InAppTiledButton(
                  icon: e.icon,
                  iconBackgroundColor: e.iconBackgroundColor,
                  iconColor: e.iconColor,
                  text: e.text,
                  onTap: () => _visitByName(context, e.route),
                );
              }),
            ),
          ),
          dimen.dp(8).h,
          ColoredBox(
            color: bg,
            child: Column(
              children: [
                InAppTiledButton(
                  text: "About of ${AppConstants.name}",
                  extra: AppConstants.website,
                  icon: InAppIcons.about.regular,
                  onTap: () => _visitAboutUs(context),
                ),
                InAppTiledButton(
                  text: "Settings",
                  icon: InAppIcons.nativeSettings.regular,
                  onTap: () => _visitSettings(context),
                ),
                InAppTiledButton(
                  text: "Logout",
                  icon: InAppIcons.logout.regular,
                  onTap: () => _logout(context),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MeIconContent {
  final dynamic icon;
  final Color? iconBackgroundColor;
  final Color? iconColor;
  final String text;
  final String route;

  const MeIconContent({
    required this.icon,
    required this.iconBackgroundColor,
    required this.iconColor,
    required this.text,
    required this.route,
  });

  static final items = [
    MeIconContent(
      icon: InAppIcons.relationship.regular,
      iconBackgroundColor: const Color(0xff4B8BEB),
      iconColor: Colors.white,
      text: "Relationship",
      route: Routes.relationship,
    ),
    MeIconContent(
      icon: InAppIcons.guideForStudent.regular,
      iconBackgroundColor: const Color(0xffEBB64B),
      iconColor: Colors.white,
      text: "Guide for student",
      route: Routes.guideForStudent,
    ),
    MeIconContent(
      icon: InAppIcons.location.regular,
      iconBackgroundColor: const Color(0xffEB9F4B),
      iconColor: Colors.white,
      text: "Guide for traveller",
      route: Routes.guideForTraveller,
    ),
    MeIconContent(
      icon: InAppIcons.marketplace.regular,
      iconBackgroundColor: const Color(0xff4BABEB),
      iconColor: Colors.white,
      text: "Marketplace",
      route: Routes.marketplace,
    ),
    MeIconContent(
      icon: InAppIcons.notes.regular,
      iconBackgroundColor: const Color(0xffEB784B),
      iconColor: Colors.white,
      text: "My Notes",
      route: Routes.myNotes,
    ),
    MeIconContent(
      icon: InAppIcons.nativeWallet.regular,
      iconBackgroundColor: const Color(0xff4BBEEB),
      iconColor: Colors.white,
      text: "Wallet",
      route: Routes.wallet,
    ),
  ];
}
