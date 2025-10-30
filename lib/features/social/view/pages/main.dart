import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/devs/nav_content.dart';
import '../../../../app/res/icons.dart';
import '../../../../features/profile/routes.dart';
import '../../../../roots/widgets/floating_action_button.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/row.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../routes/paths.dart';
import '../../../main/views/widgets/search_box.dart';
import '../../../user/view/cubits/memory_cubit.dart';
import '../../../user/view/cubits/note_cubit.dart';
import '../../../user/view/cubits/post_cubit.dart';
import '../../../user/view/cubits/video_cubit.dart';
import '../../data/cubits/feed_home_cubit.dart';
import '../dialogs/bsd_feed_format.dart';
import 'home.dart';
import 'notification.dart';
import 'verified.dart';
import 'verifier.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({super.key});

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage>
    with SingleTickerProviderStateMixin {
  final floatingBtnScale = ValueNotifier(1.0);
  final index = ValueNotifier(0);
  late TabController controller = TabController(
    length: tabs.length,
    vsync: this,
  );

  late List<NavigationContent> tabs = [
    NavigationContent(
      label: "Stars",
      activeIcon: InAppIcons.navHome1.solid,
      inactiveIcon: InAppIcons.navHome1.regular,
    ),
    NavigationContent(
      label: "Verified",
      activeIcon: InAppIcons.navHome2.solid,
      inactiveIcon: InAppIcons.navHome2.regular,
    ),
    NavigationContent(
      label: "Verifier",
      activeIcon: InAppIcons.navHome3.solid,
      inactiveIcon: InAppIcons.navHome3.regular,
    ),
    NavigationContent(
      label: "Notifications",
      activeIcon: InAppIcons.navHome4.solid,
      inactiveIcon: InAppIcons.navHome4.regular,
    ),
  ];

  void _changeIndex(int index) {
    floatingBtnScale.value = index == 0 || index == 1 ? 1 : 0;
    this.index.value = index;
  }

  void _createANew(BuildContext context) async {
    final value = await InAppFeedFormatBSD.show(context);
    if (!context.mounted) return;
    Map args = {"$FeedHomeCubit": context.read<FeedHomeCubit>()};
    Object? result;
    if (value == FeedFormats.memory) {
      result = await context.open(
        Routes.createAMemory,
        arguments: {
          ...args,
          "$UserMemoryCubit": context.read<UserMemoryCubit>(),
        },
      );
      return;
    }
    if (value == FeedFormats.note) {
      result = await context.open(
        Routes.createANote,
        arguments: {...args, "$UserNoteCubit": context.read<UserNoteCubit>()},
      );
      return;
    }
    if (value == FeedFormats.post) {
      result = await context.open(
        Routes.createUserPost,
        arguments: {...args, "$UserPostCubit": context.read<UserPostCubit>()},
      );
      return;
    }
    if (value == FeedFormats.video) {
      result = await context.open(
        Routes.createAVideo,
        arguments: {...args, "$UserVideoCubit": context.read<UserVideoCubit>()},
      );
      return;
    }
    _finally(result);
  }

  void _finally(Object? value) {}

  void _visitMenu(BuildContext context) {
    context.openProfile();
  }

  void _visitSearch(BuildContext context) {
    context.open(Routes.searchFeeds);
  }

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final secondary = context.iconColor.mid;
    final dimen = context.dimens;
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: ValueListenableBuilder(
        valueListenable: floatingBtnScale,
        builder: (context, value, child) {
          return AnimatedScale(
            scale: value,
            duration: const Duration(milliseconds: 200),
            child: IgnorePointer(
              ignoring: value <= 0,
              child: InAppFAButton(
                icon: InAppIcons.write.solid,
                onTap: () => _createANew(context),
              ),
            ),
          );
        },
      ),
      appBar: AppBar(
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: context.light,
        title: Container(
          height: kToolbarHeight,
          padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
          width: double.infinity,
          child: InAppRow(
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: dimen.dp(8),
            children: [
              MainSearchBox(
                text: "Search feeds",
                onSearch: () => _visitSearch(context),
              ),
              InAppUserAvatar(isLocal: true, onTap: () => _visitMenu(context)),
            ],
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(dimen.dp(kToolbarHeight - 12)),
          child: ValueListenableBuilder(
            valueListenable: index,
            builder: (context, value, child) {
              return AndrossyTab(
                onChanged: _changeIndex,
                controller: controller,
                dividerColor: context.dark.t05,
                dividerHeight: dimen.divider.smaller,
                indicatorWeight: dimen.dp(2),
                splashBorderRadius: BorderRadius.circular(dimen.dp(25)),
                builder: (context, index, selected) {
                  final item = tabs.elementAt(index);
                  return Container(
                    padding: EdgeInsets.all(dimen.dp(8)),
                    child: InAppIcon(
                      selected ? item.activeIcon : item.inactiveIcon,
                      size: dimen.dp(24),
                      color: selected ? primary : secondary,
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        children: [
          FeedHomePage(),
          FeedVerifiedPage(),
          FeedVerifierPage(),
          FeedNotificationPage(),
        ],
      ),
    );
  }
}
