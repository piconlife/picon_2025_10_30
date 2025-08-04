import 'package:app_color/app_color.dart';
import 'package:app_color/extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../app/widgets/leading.dart';
import 'column.dart';

class InAppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool automaticallyImplyLeading;
  final List<Widget> actions;
  final Color? backgroundColor;
  final PreferredSizeWidget? bottom;
  final bool centerTitle;
  final double elevation;
  final Color? elevationColor;
  final double height;
  final Widget? leading;
  final Widget? title;
  final double titleSpacing;
  final String? titleText;
  final TextStyle titleTextStyle;
  final bool hide;

  const InAppAppbar({
    super.key,
    this.actions = const [],
    this.automaticallyImplyLeading = true,
    this.backgroundColor,
    this.bottom,
    this.centerTitle = false,
    this.elevation = 1,
    this.elevationColor,
    this.height = kToolbarHeight,
    this.leading,
    this.title,
    this.titleSpacing = 12,
    this.titleText,
    this.titleTextStyle = const TextStyle(fontSize: 18),
    this.hide = false,
  });

  const InAppAppbar.hide({Key? key, Color? backgroundColor})
    : this(key: key, backgroundColor: backgroundColor, hide: true);

  @override
  Widget build(BuildContext context) {
    final style = backgroundColor?.isDark ?? context.isDarkMode
        ? SystemUiOverlayStyle.light.copyWith(
            systemNavigationBarColor: Colors.black.withAlpha(0),
            statusBarColor: Colors.black.withAlpha(0),
          )
        : SystemUiOverlayStyle.dark.copyWith(
            systemNavigationBarColor: Colors.white.withAlpha(0),
            statusBarColor: Colors.white.withAlpha(0),
          );
    if (hide) {
      return AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        toolbarHeight: 0,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: style,
      );
    }
    return InAppColumn(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          automaticallyImplyLeading: automaticallyImplyLeading,
          surfaceTintColor: Colors.transparent,
          backgroundColor: backgroundColor ?? context.light,
          centerTitle: centerTitle,
          titleSpacing: titleSpacing,
          leading: leading ?? InAppLeading(),
          title: title ?? Text(titleText ?? "", style: titleTextStyle),
          elevation: 0,
          bottom: bottom,
          actions: actions.isNotEmpty ? [...actions, SizedBox(width: 8)] : null,
          systemOverlayStyle: style,
        ),
        if (elevation > 0)
          Divider(
            height: elevation,
            color: elevationColor ?? context.dark.withValues(alpha: 0.05),
          ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height + elevation);
}
