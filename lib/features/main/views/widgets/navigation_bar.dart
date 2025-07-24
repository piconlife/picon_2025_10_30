import 'dart:convert';

import 'package:app_color/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../../../roots/widgets/bottom_bar.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';

class NavigationItem {
  final String id;
  final String label;
  final dynamic icon;

  const NavigationItem({this.id = '', this.label = '', this.icon});

  factory NavigationItem.from(Object? source) {
    if (source is String) source = jsonDecode(source);
    if (source is! Map) return NavigationItem();
    final id = source['id'];
    final label = source['label'];
    final icon = source['icon'];
    return NavigationItem(
      id: id is String
          ? id
          : label.toString().toLowerCase().replaceAll(' ', '_'),
      label: label is String ? label : '',
      icon: icon is String ? icon : null,
    );
  }
}

class MainNavigationBar extends StatefulWidget {
  final int initialIndex;
  final List<NavigationItem> items;
  final ValueChanged<int>? onChanged;

  const MainNavigationBar({
    super.key,
    required this.initialIndex,
    required this.items,
    this.onChanged,
  });

  @override
  State<MainNavigationBar> createState() => _MainNavigationBarState();
}

class _MainNavigationBarState extends State<MainNavigationBar>
    with TranslationMixin, ColorMixin {
  late int selected = widget.initialIndex;

  void _change(int index) {
    setState(() => selected = index);
    widget.onChanged?.call(selected);
  }

  @override
  Widget build(BuildContext context) {
    return InAppBottomBar(
      height: kToolbarHeight,
      child: InAppLayout(
        layout: LayoutType.row,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(widget.items.length, (index) {
          return _buildItem(index, widget.items[index]);
        }),
      ),
    );
  }

  Widget _buildItem(int index, NavigationItem item) {
    final isSelected = selected == index;
    return Expanded(
      child: Center(
        child: InAppGesture(
          onTap: () => _change(index),
          child: Container(
            decoration: BoxDecoration(color: Colors.transparent),
            alignment: Alignment.center,
            child: InAppLayout(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InAppIcon(
                  item.icon,
                  flipByTextDirection: true,
                  color: isSelected ? color.base.secondary : color.icon.primary,
                ),
                SizedBox(height: 4),
                InAppText(
                  localize(item.label, defaultValue: item.label),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isSelected
                        ? color.base.secondary
                        : color.icon.primary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  String get name => "main";
}
