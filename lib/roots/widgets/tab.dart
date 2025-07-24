import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/settings.dart';
import 'package:flutter_andomie/utils/translation.dart';

class InAppTabs extends StatefulWidget {
  final TabController? controller;
  final int? initialIndex;
  final String name;
  final List<String> tabs;
  final ValueChanged<int>? onChanged;
  final TextStyle? style;
  final TextStyle? unselectedStyle;
  final Color? primary;
  final Color? secondary;
  final BoxDecoration? decoration;
  final BorderRadius? borderRadius;

  const InAppTabs({
    super.key,
    this.controller,
    this.initialIndex,
    required this.name,
    required this.tabs,
    this.onChanged,
    this.style,
    this.unselectedStyle,
    this.primary,
    this.secondary,
    this.decoration,
    this.borderRadius,
  });

  @override
  State<InAppTabs> createState() => _InAppTabsState();
}

class _InAppTabsState extends State<InAppTabs>
    with SingleTickerProviderStateMixin {
  late final controller =
      widget.controller ??
      TabController(
        length: widget.tabs.length,
        vsync: this,
        initialIndex: widget.initialIndex ?? Settings.get(widget.name, 0),
      );

  void _changed(int index) {
    if (widget.initialIndex == null) Settings.set(widget.name, index);
    if (widget.onChanged == null) return;
    widget.onChanged!(index);
  }

  @override
  void dispose() {
    if (widget.controller == null) controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: Translation.textDirection,
      child: Theme(
        data: ThemeData(
          useMaterial3: false,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: TabBar(
          dividerHeight: 0,
          indicatorWeight: 0,
          indicatorSize: TabBarIndicatorSize.tab,
          onTap: _changed,
          labelColor: widget.style?.color ?? context.light,
          labelStyle: (widget.style ?? const TextStyle()).copyWith(
            fontWeight: widget.style?.fontWeight ?? FontWeight.bold,
            fontSize: widget.style?.fontSize ?? 16.5,
          ),
          unselectedLabelColor: widget.unselectedStyle?.color ?? context.dark,
          unselectedLabelStyle: (widget.unselectedStyle ?? const TextStyle())
              .copyWith(
                fontWeight:
                    widget.unselectedStyle?.fontWeight ?? FontWeight.bold,
                fontSize: widget.unselectedStyle?.fontSize ?? 16,
              ),
          controller: controller,
          indicator:
              widget.decoration ??
              BoxDecoration(
                borderRadius: widget.borderRadius ?? BorderRadius.circular(100),
                color: widget.primary ?? context.dark,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 17,
                    color: (widget.primary ?? context.dark).withValues(
                      alpha: 0.12,
                    ),
                  ),
                ],
              ),
          tabs: List.generate(widget.tabs.length, (index) {
            return Tab(text: widget.tabs[index]);
          }),
        ),
      ),
    );
  }
}
