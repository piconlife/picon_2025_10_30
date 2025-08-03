import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';

import '../../../../configs/extensions/text_direction.dart';
import '../../../../roots/widgets/gesture.dart';
import '../../../../roots/widgets/icon.dart';
import '../../../../roots/widgets/layout.dart';
import '../../../../roots/widgets/text.dart';
import 'card_layout.dart';

class SettingsCardData {
  final int index;
  final dynamic icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsCardData({
    required this.icon,
    required this.label,
    this.trailing,
    this.index = 0,
    this.onTap,
  });

  SettingsCardData copyWith({
    int? index,
    dynamic icon,
    String? label,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return SettingsCardData(
      index: index ?? this.index,
      icon: icon ?? this.icon,
      label: label ?? this.label,
      trailing: trailing ?? this.trailing,
      onTap: onTap ?? this.onTap,
    );
  }
}

class SettingsCard extends StatefulWidget {
  final Color? borderColor;
  final String title;
  final List<SettingsCardData> data;

  const SettingsCard({
    super.key,
    this.borderColor,
    required this.data,
    required this.title,
  });

  @override
  State<SettingsCard> createState() => _SettingsCardState();
}

class _SettingsCardState extends State<SettingsCard> with ColorMixin {
  @override
  Widget build(BuildContext context) {
    return InAppLayout(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
          child: InAppText(
            widget.title,
            style: TextStyle(
              fontSize: 18,
              color: dark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SettingsCardLayout(
          child: InAppLayout(
            children: List.generate(widget.data.length, (index) {
              return SettingsCardItem(
                data: widget.data[index].copyWith(index: index),
              );
            }),
          ),
        ),
      ],
    );
  }
}

class SettingsCardItem extends StatelessWidget {
  final SettingsCardData data;

  const SettingsCardItem({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return InAppGesture(
      onTap: data.onTap,
      child: Container(
        padding: EdgeInsets.only(
          left: 24,
          right: 12,
          top: 16,
          bottom: 16,
        ).directional,
        child: InAppLayout(
          layout: LayoutType.row,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            InAppIcon(data.icon, color: context.primary.t50, size: 24),
            SizedBox(width: 20),
            Expanded(
              child: InAppText(
                data.label,
                style: TextStyle(color: context.dark, fontSize: 16),
              ),
            ),
            if (data.trailing != null) data.trailing!,
            SizedBox(width: 8),
            InAppIcon(
              flipByTextDirection: true,
              Icons.keyboard_arrow_right,
              size: 28,
              color: context.primary.t50,
            ),
          ],
        ),
      ),
    );
  }
}
