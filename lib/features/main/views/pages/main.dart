import 'package:app_color/app_color.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:auth_management/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/extensions/spacing.dart';
import 'package:flutter_androssy_dialogs/dialogs.dart';
import 'package:in_app_navigator/in_app_navigator.dart';

import '../../../../app/devs/nav_content.dart';
import '../../../../app/res/icons.dart';
import '../../../../data/models/user.dart';
import '../../../../roots/preferences/preferences.dart';
import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../../../../roots/widgets/text.dart';
import '../../../../routes/paths.dart';
import '../../../channel/view/pages/main.dart';
import '../../../shop/view/pages/main.dart';
import '../../../shore/view/pages/main.dart';
import '../../../social/view/pages/main.dart';

const _kNavIndex = "main_nav_index";

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int index = Preferences.getInt(_kNavIndex);

  void _changeIndex(int index) {
    setState(() {
      this.index = index;
      Preferences.setInt(_kNavIndex, index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    return AuthObserver<User>(
      onError: (context, value) => context.showErrorSnackBar(value),
      onLoading: (context, value) {
        if (value) {
          context.showLoader();
        } else {
          context.hideLoader();
        }
      },
      onMessage: (context, value) => context.showSnackBar(value),
      onStatus: (context, value) {
        if (value.isUnauthenticated) context.clear(Routes.intro);
      },
      child: InAppSystemOverlay(
        child: InAppScreen(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: InAppBottomBar(
              enabled: false,
              child: _NavBar(
                index: index,
                dimen: dimen,
                onChanged: _changeIndex,
                items: [
                  NavigationContent(
                    label: "Home",
                    activeIcon: InAppIcons.navHome.solid,
                    inactiveIcon: InAppIcons.navHome.regular,
                  ),
                  NavigationContent(
                    label: "Market",
                    activeIcon: InAppIcons.navMarket.solid,
                    inactiveIcon: InAppIcons.navMarket.regular,
                  ),
                  NavigationContent(
                    label: "Grocery",
                    activeIcon: InAppIcons.navGrocery.solid,
                    inactiveIcon: InAppIcons.navGrocery.regular,
                  ),
                  NavigationContent(
                    label: "Tube",
                    activeIcon: InAppIcons.navTube.solid,
                    inactiveIcon: InAppIcons.navTube.regular,
                  ),
                ],
              ),
            ),
            body: IndexedStack(
              index: index,
              children: const [
                FeedPage(),
                MarketPage(),
                GroceryPage(),
                MetubePage(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavBar extends StatelessWidget {
  final int index;
  final List<NavigationContent> items;
  final DimenData dimen;
  final ValueChanged<int> onChanged;

  const _NavBar({
    required this.index,
    required this.items,
    required this.dimen,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final primary = context.primary;
    final secondary = context.mid;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: List.generate(items.length, (index) {
        final selected = this.index == index;
        final item = items.elementAt(index);
        return InAppGesture(
          onTap: () => onChanged(index),
          child: Container(
            color: Colors.transparent,
            padding: EdgeInsets.all(dimen.dp(8)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InAppIcon(
                  selected ? item.activeIcon : item.inactiveIcon,
                  size: dimen.dp(24),
                  color: selected ? primary : secondary,
                ),
                dimen.dp(4).h,
                InAppText(
                  item.label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: selected ? primary : secondary,
                    fontWeight: context.mediumFontWeight,
                    fontSize: dimen.dp(12),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
