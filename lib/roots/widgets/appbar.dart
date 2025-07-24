import 'package:app_dimen/app_dimen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_andomie/utils/translation.dart';

import '../../app/widgets/leading.dart';
import 'layout.dart';
import 'position.dart';

class InAppAppbar extends StatelessWidget implements PreferredSizeWidget {
  final DimenData? dimen;
  final bool showLeading;
  final Widget? leading;
  final Widget? title;
  final String? titleText;
  final double titleSpace;
  final TextStyle titleStyle;
  final double height;
  final EdgeInsets padding;
  final bool centerTitle;
  final double elevation;
  final Color? elevationColor;
  final Color? color;
  final Color? backgroundColor;
  final List<Widget>? actions;
  final Widget? bottom;
  final Widget? Function(BuildContext context, TextStyle style)? titleBuilder;

  const InAppAppbar({
    super.key,
    this.dimen,
    this.color,
    this.backgroundColor,
    this.showLeading = true,
    this.leading,
    this.title,
    this.titleText,
    this.titleSpace = 12,
    this.titleStyle = const TextStyle(fontSize: 16),
    this.height = kToolbarHeight,
    this.padding = const EdgeInsets.only(top: 40, left: 8, right: 8),
    this.centerTitle = false,
    this.elevation = 1,
    this.elevationColor,
    this.actions,
    this.titleBuilder,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor ?? Colors.transparent,
      surfaceTintColor: Colors.transparent,
      child: Directionality(
        textDirection: Translation.textDirection,
        child: _build(context),
      ),
    );
  }

  Widget _build(BuildContext context) {
    return Container(
      height: height + padding.vertical,
      color: backgroundColor,
      padding: padding,
      child: InAppLayout(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: centerTitle ? _centerMode(context) : _sideMode(context),
          ),
          if (bottom != null) _buildBottom(context),
          if (elevation > 0)
            Divider(
              height: elevation,
              color: elevationColor ?? Colors.grey.withValues(alpha: 0.1),
            ),
        ],
      ),
    );
  }

  Widget _title(BuildContext context) {
    return title ?? Text(titleText ?? "", style: titleStyle);
  }

  Widget _centerMode(BuildContext context) {
    return InAppLayout(
      layout: LayoutType.stack,
      alignment: Alignment.center,
      children: [
        if (leading != null)
          InAppPositioned(left: 0, child: leading!)
        else if (showLeading && Navigator.canPop(context))
          InAppPositioned(left: 0, child: _buildLeading()),
        Center(child: _title(context)),
        if (actions != null && actions!.isNotEmpty)
          InAppPositioned(
            right: 0,
            child: InAppLayout(
              layout: LayoutType.row,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: actions ?? [],
            ),
          ),
      ],
    );
  }

  Widget _sideMode(BuildContext context) {
    return InAppLayout(
      layout: LayoutType.row,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (leading != null)
          leading!
        else if (showLeading && Navigator.canPop(context))
          _buildLeading(),
        SizedBox(width: titleSpace),
        Expanded(child: _title(context)),
        if (actions != null) ...actions!,
      ],
    );
  }

  Widget _buildLeading() {
    return InAppLeading();
  }

  Widget _buildBottom(BuildContext context) {
    return bottom!;
  }

  @override
  Size get preferredSize {
    return Size.fromHeight(height + elevation + padding.vertical).apply(dimen);
  }
}
