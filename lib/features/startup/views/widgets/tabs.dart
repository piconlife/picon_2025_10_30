import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

class OnboardingTabs extends StatelessWidget {
  final TabController? controller;
  final List<String> tabs;
  final ValueChanged<int>? onChanged;

  const OnboardingTabs({
    super.key,
    this.controller,
    required this.tabs,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 180,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xff000000).withValues(alpha: 0.12),
            blurRadius: 17,
          ),
        ],
        borderRadius: BorderRadius.circular(100),
      ),
      child: Theme(
        data: ThemeData(
          useMaterial3: false,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: Directionality(
          textDirection: Translation.textDirection,
          child: TabBar(
            dividerHeight: 0,
            indicatorWeight: 0,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: onChanged,
            labelColor: Colors.white,
            labelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.5,
            ),
            unselectedLabelColor: Colors.black,
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            controller: controller,
            indicator: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Colors.black,
              boxShadow: [
                BoxShadow(
                  blurRadius: 17,
                  color: const Color(0xff000000).withValues(alpha: 0.12),
                ),
              ],
            ),
            tabs: List.generate(tabs.length, (index) {
              return Tab(text: tabs[index]);
            }),
          ),
        ),
      ),
    );
  }
}
