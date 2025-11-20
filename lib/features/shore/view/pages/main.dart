import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_androssy_kits/widgets.dart';
import 'package:in_app_navigator/route.dart';

import '../../../../app/devs/nav_content.dart';
import '../../../../app/res/icons.dart';
import '../../../../roots/widgets/floating_action_button.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/user_avatar.dart';
import '../../../../routes/paths.dart';
import '../../../main/views/widgets/search_box.dart';
import '../dialogs/bsd_grocery_format.dart';
import 'categories.dart';
import 'home.dart';
import 'nearby.dart';
import 'notification.dart';

class GroceryPage extends StatefulWidget {
  const GroceryPage({super.key});

  @override
  State<GroceryPage> createState() => _GroceryPageState();
}

class _GroceryPageState extends State<GroceryPage>
    with SingleTickerProviderStateMixin {
  final floatingBtnScale = ValueNotifier(1.0);
  final index = ValueNotifier(0);
  late TabController controller = TabController(
    length: tabs.length,
    vsync: this,
  );

  late List<NavigationContent> tabs = [
    NavigationContent(
      label: "Home",
      activeIcon: InAppIcons.navGrocery1.solid,
      inactiveIcon: InAppIcons.navGrocery1.regular,
    ),
    NavigationContent(
      label: "Nearby",
      activeIcon: InAppIcons.navGrocery2.solid,
      inactiveIcon: InAppIcons.navGrocery2.regular,
    ),
    NavigationContent(
      label: "Categories",
      activeIcon: InAppIcons.navGrocery3.solid,
      inactiveIcon: InAppIcons.navGrocery3.regular,
    ),
    NavigationContent(
      label: "Notifications",
      activeIcon: InAppIcons.navGrocery4.solid,
      inactiveIcon: InAppIcons.navGrocery4.regular,
    ),
  ];

  void _changeIndex(int index) {
    floatingBtnScale.value = index == 0 || index == 1 ? 1 : 0;
    this.index.value = index;
  }

  void _createANew(BuildContext context) async {
    final value = await GroceryFormatBSD.show(context);
    if (!context.mounted) return;
    Object? result;
    if (value == GroceryFormats.addAGrocery) {
      result = await context.open(Routes.addAGrocery);
      return;
    }
    _finally(result);
  }

  void _finally(Object? value) {}

  void _visitMenu(BuildContext context) {
    context.open(Routes.userGrocery);
  }

  void _visitSearch(BuildContext context) {
    context.open(Routes.searchGroceries);
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final primary = context.primary;
    final secondary = context.iconColor.mid;
    return Scaffold(
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
        primary: true,
        titleSpacing: 0,
        elevation: 0,
        backgroundColor: context.light,
        title: Container(
          height: kToolbarHeight,
          padding: EdgeInsets.symmetric(horizontal: dimen.dp(16)),
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MainSearchBox(
                text: "Search grocery products",
                onSearch: () => _visitSearch(context),
              ),
              dimen.dp(8).w,
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
                dividerColor: Colors.transparent,
                dividerHeight: 0,
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
        children: const [
          GroceryHomePage(),
          GroceryNearbyPage(),
          GroceryCategoriesPage(),
          GroceryNotificationPage(),
        ],
      ),
    );
  }
}
