import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../roots/widgets/auth.dart';
import '../../../../roots/widgets/paywall.dart';
import '../../../../roots/widgets/screen.dart';
import '../../../../roots/widgets/system_overlay.dart';
import '../widgets/navigation_bar.dart';
import '../widgets/timeline.dart';

const kNavigationIndex = "navigation_index";

class MainPage extends StatefulWidget {
  final Object? args;

  const MainPage({super.key, this.args});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TranslationMixin {
  late final index = ValueNotifier(Settings.get(kNavigationIndex, 0));

  void _changedIndex(int value) {
    index.value = value;
    Settings.set(kNavigationIndex, value);
  }

  @override
  void initState() {
    super.initState();
    initTimeline();
  }

  Widget findBody(String id) {
    switch (id) {
      default:
        return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    final contents = gets(
      key: "navigation",
      parser: NavigationItem.from,
      autoTranslatorFields: ["label"],
    );
    return InAppSystemOverlay(
      child: InAppAuth(
        name: name,
        enabled: false,
        isSkipMode: true,
        isBackMode: false,
        child: InAppPaywall(
          name: name,
          enabled: false,
          isSkipMode: true,
          isBackMode: false,
          child: InAppScreen(
            child: Scaffold(
              backgroundColor: Colors.transparent,
              bottomNavigationBar: MainNavigationBar(
                initialIndex: index.value,
                items: contents,
                onChanged: _changedIndex,
              ),
              body: ValueListenableBuilder(
                valueListenable: index,
                builder: (context, value, child) {
                  return IndexedStack(
                    index: value,
                    textDirection: textDirection,
                    children: contents.map((e) => findBody(e.id)).toList(),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "main";
}
