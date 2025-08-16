import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/core.dart';

import '../../../../app/helpers/user.dart';
import '../../../../app/res/icons.dart';
import '../../../../app/styles/fonts.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/preferences/preferences.dart';
import '../../../../roots/widgets/action.dart';
import '../../../../roots/widgets/appbar.dart';
import '../../../../roots/widgets/screen.dart';
import '../widgets/profile_details_bar.dart';
import 'profile/abouts.dart';
import 'profile/notes.dart';
import 'profile/photos.dart';
import 'profile/posts.dart';
import 'profile/stories.dart';
import 'profile/videos.dart';

const _kProfileTabIndex = "_kProfileTabIndex";

class UserProfilePage extends StatefulWidget {
  final Object? args;

  const UserProfilePage({super.key, this.args});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage>
    with SingleTickerProviderStateMixin {
  User? user;
  String? uid;
  bool isCurrentUser = false;

  late TabController controller;

  @override
  void initState() {
    super.initState();
    user = widget.args.findOrNull(key: "$User");
    uid =
        user?.id ??
        widget.args.findOrNull(key: "uid") ??
        widget.args?.findOrNull();
    isCurrentUser = UserHelper.isCurrentUser(uid ?? user?.id);
    controller = TabController(
      initialIndex: isCurrentUser ? Preferences.getInt(_kProfileTabIndex) : 0,
      length: _tabs.length,
      vsync: this,
    );
  }

  void _menu(BuildContext context) {}

  final List<String> _tabs = [
    "Posts",
    "Photos",
    "Notes",
    "Stories",
    "Videos",
    "Abouts",
  ];

  @override
  Widget build(context) {
    final dimen = context.dimens;
    final dark = context.dark;
    return InAppScreen(
      theme: ThemeType.secondary,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: InAppAppbar(
          titleText: UserHelper.username,
          actions: [
            InAppAction(
              InAppIcons.nativeMenuWithDot.regular,
              onTap: () => _menu(context),
            ),
          ],
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, isNestedScrolling) {
            return [
              SliverToBoxAdapter(
                child: ProfileDetailsBar(uid: uid, user: user),
              ),
              SliverAppBar(
                elevation: 0.0,
                titleSpacing: 0,
                floating: true,
                toolbarHeight: kToolbarHeight - 5,
                primary: false,
                pinned: true,
                automaticallyImplyLeading: false,
                backgroundColor: Colors.red,
                scrolledUnderElevation: 0,
                title: Container(
                  height: kToolbarHeight - 5,
                  decoration: BoxDecoration(
                    color: context.scaffoldColor.secondary,
                  ),
                  child: TabBar(
                    controller: controller,
                    dividerHeight: 1,
                    dividerColor: context.dark.t05,
                    isScrollable: true,
                    tabAlignment: TabAlignment.center,
                    padding: EdgeInsets.symmetric(horizontal: dimen.dp(8)),
                    indicatorPadding: EdgeInsets.zero,
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorWeight: 3,
                    splashBorderRadius: BorderRadius.circular(dimen.dp(16)),
                    onTap: (index) {
                      if (!isCurrentUser) return;
                      Preferences.setInt(_kProfileTabIndex, index);
                    },
                    labelStyle: TextStyle(
                      color: dark,
                      fontWeight: dimen.semiBoldFontWeight,
                      fontSize: dimen.dp(15),
                      fontFamily: InAppFonts.secondary,
                    ),
                    unselectedLabelStyle: TextStyle(
                      color: dark.t50,
                      fontWeight: dimen.semiBoldFontWeight,
                      fontSize: dimen.dp(15),
                      fontFamily: InAppFonts.secondary,
                    ),
                    tabs: _tabs.map((e) {
                      return Tab(text: e);
                    }).toList(),
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: controller,
            children: [
              ProfilePostsSegment(uid: user?.id),
              ProfilePhotosSegment(uid: user?.id),
              ProfileNotesSegment(uid: user?.id),
              ProfileStoriesSegment(uid: user?.id),
              ProfileVideosSegment(uid: user?.id),
              ProfileAboutsSegment(user: user),
            ],
          ),
        ),
      ),
    );
  }
}
