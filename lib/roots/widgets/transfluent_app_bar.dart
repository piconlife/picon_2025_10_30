import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TransfluentAppBar extends AppBar {
  TransfluentAppBar({
    super.key,
    super.leading,
    super.automaticallyImplyLeading = false,
    super.title,
    super.actions,
    super.automaticallyImplyActions = false,
    super.flexibleSpace,
    super.bottom,
    super.elevation,
    super.scrolledUnderElevation,
    super.notificationPredicate = defaultScrollNotificationPredicate,
    super.shadowColor,
    super.surfaceTintColor = Colors.transparent,
    super.shape,
    super.backgroundColor = Colors.transparent,
    super.foregroundColor,
    super.iconTheme,
    super.actionsIconTheme,
    super.primary = true,
    super.centerTitle,
    super.excludeHeaderSemantics = false,
    super.titleSpacing,
    super.toolbarOpacity = 1.0,
    super.bottomOpacity = 1.0,
    super.leadingWidth,
    super.toolbarTextStyle,
    super.titleTextStyle,
    super.forceMaterialTransparency = false,
    super.useDefaultSemanticsOrder = true,
    super.clipBehavior,
    super.actionsPadding,
    super.animateColor = false,
    double? toolbarHeight,
    SystemUiOverlayStyle systemOverlayStyle = SystemUiOverlayStyle.light,
  }) : super(
         toolbarHeight:
             !automaticallyImplyLeading &&
                     !automaticallyImplyActions &&
                     (leading ??
                             title ??
                             actions?.firstOrNull ??
                             flexibleSpace ??
                             bottom) ==
                         null
                 ? 0
                 : toolbarHeight,
         systemOverlayStyle: systemOverlayStyle.copyWith(
           systemStatusBarContrastEnforced: false,
           systemNavigationBarContrastEnforced: false,
         ),
       );
}
