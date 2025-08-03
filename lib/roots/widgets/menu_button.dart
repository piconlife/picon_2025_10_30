import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';

import '../../app/res/icons.dart';
import 'icon.dart';

class InAppMenuButton<T> extends StatelessWidget {
  final dynamic icon;
  final Color? primary;
  final List<PopupMenuEntry<T>> Function(BuildContext context) itemBuilder;
  final ValueChanged<T> onChanged;

  const InAppMenuButton({
    super.key,
    this.primary,
    this.icon,
    required this.itemBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final dimen = context.dimens;
    final color = primary ?? context.dark;
    return PopupMenuButton<T>(
      onSelected: onChanged,
      itemBuilder: itemBuilder,
      surfaceTintColor: Colors.transparent,
      color: context.light,
      clipBehavior: Clip.antiAlias,
      constraints: BoxConstraints(minWidth: dimen.width * 0.35),
      menuPadding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(dimen.dp(16)),
      ),
      elevation: dimen.dp(10),
      child: Padding(
        padding: EdgeInsets.all(dimen.dp(8)),
        child: InAppIcon(
          icon ?? AppIcons.more.regular,
          size: dimen.dp(24),
          color: color.t50,
        ),
      ),
    );
  }
}
