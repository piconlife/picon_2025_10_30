import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../text/view.dart';
import '../view/view.dart';

class ToolbarView extends YMRView<ToolbarViewController> {
  final List<Widget>? actions;
  final Color elevationColor;
  final IconThemeData? iconTheme;

  ///LEADING
  final Widget? leading;
  final bool? leadingAutoImply;
  final dynamic leadingIcon;
  final Color? leadingIconColor;
  final double? leadingIconSize;
  final double? leadingSize;
  final bool? leadingVisible;
  final OnViewClickListener? onLeadingClick;

  ///STATUS BAR
  final Color? statusBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;

  ///TITLE
  final String? title;
  final bool? titleCenter;
  final Color? titleColor;
  final Widget? titleCustom;
  final double? titleSize;
  final double? titleSpacing;
  final TextStyle? titleStyle;

  const ToolbarView({
    /// ROOT PROPERTIES
    super.key,
    super.controller,

    /// CALLBACK PROPERTIES
    super.onActivator,
    super.onChange,
    super.onError,
    super.onHover,
    super.onValid,
    super.onValidator,

    /// CLICK PROPERTIES
    super.clickEffect,
    super.onClick,
    super.onDoubleClick,
    super.onLongClick,
    super.onToggleClick,
    super.onClickHandler,
    super.onDoubleClickHandler,
    super.onLongClickHandler,

    ///BASE PROPERTIES
    super.absorbMode,
    super.activated,
    super.background,
    super.backgroundState,
    super.backgroundBlendMode,
    super.backgroundGradient,
    super.backgroundGradientState,
    super.backgroundImage,
    super.backgroundImageState,
    super.clipBehavior,
    super.dimensionRatio,
    super.elevation,
    super.enabled,
    super.expandable,
    super.foreground,
    super.foregroundBlendMode,
    super.foregroundGradient,
    super.foregroundImage,
    super.flex,
    super.gravity,
    super.height,
    super.heightState,
    super.heightMax,
    super.heightMin,
    super.hoverColor,
    super.orientation,
    super.position,
    super.positionType,
    super.pressedColor,
    super.rippleColor,
    super.scrollable,
    super.scrollController,
    super.scrollingType,
    super.shape,
    super.transform,
    super.transformGravity,
    super.visibility,
    super.width,
    super.widthState,
    super.widthMax,
    super.widthMin,

    /// ANIMATION PROPERTIES
    super.animation,
    super.animationType,

    /// BACKDROP PROPERTIES
    super.backdropFilter,
    super.backdropMode,

    /// BORDER PROPERTIES
    super.borderColor,
    super.borderColorState,
    super.borderSize,
    super.borderSizeState,
    super.borderHorizontal,
    super.borderHorizontalState,
    super.borderVertical,
    super.borderVerticalState,
    super.borderTop,
    super.borderTopState,
    super.borderBottom,
    super.borderBottomState,
    super.borderStart,
    super.borderStartState,
    super.borderEnd,
    super.borderEndState,
    super.borderStrokeAlign,

    /// BORDER RADIUS PROPERTIES
    super.borderRadius,
    super.borderRadiusState,
    super.borderRadiusBL,
    super.borderRadiusBLState,
    super.borderRadiusBR,
    super.borderRadiusBRState,
    super.borderRadiusTL,
    super.borderRadiusTLState,
    super.borderRadiusTR,
    super.borderRadiusTRState,

    /// INDICATOR PROPERTIES
    super.indicatorVisible,

    /// MARGIN PROPERTIES
    super.margin,
    super.marginHorizontal,
    super.marginVertical,
    super.marginTop,
    super.marginBottom,
    super.marginStart,
    super.marginEnd,
    super.marginCustom,

    /// OPACITY PROPERTIES
    super.opacity,
    super.opacityState,
    super.opacityAlwaysIncludeSemantics,

    /// PADDING PROPERTIES
    super.padding,
    super.paddingHorizontal,
    super.paddingVertical,
    super.paddingTop,
    super.paddingBottom,
    super.paddingStart,
    super.paddingEnd,
    super.paddingCustom,

    /// SHADOW PROPERTIES
    super.shadow,
    super.shadowBlurRadius,
    super.shadowBlurStyle,
    super.shadowColor,
    super.shadowType,
    super.shadowSpreadRadius,
    super.shadowHorizontal,
    super.shadowVertical,
    super.shadowStart,
    super.shadowEnd,
    super.shadowTop,
    super.shadowBottom,

    /// CHILD PROPERTIES
    this.actions,
    this.elevationColor = Colors.black12,
    this.iconTheme,

    ///LEADING
    this.leading,
    this.leadingAutoImply,
    this.leadingIcon,
    this.leadingIconColor,
    this.leadingIconSize,
    this.leadingSize,
    this.leadingVisible,
    this.onLeadingClick,

    ///STATUS BAR
    this.statusBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,

    ///TITLE
    this.title,
    this.titleCenter,
    this.titleColor,
    this.titleCustom,
    this.titleSize,
    this.titleSpacing,
    this.titleStyle,
  });

  @override
  void onInit(context, controller) {
    super.onInit(context, controller);
    return controller.changeStatusBar();
  }

  @override
  void onUpdateWidget(context, controller, oldWidget) {
    super.onUpdateWidget(context, controller, oldWidget);
    return controller.changeStatusBar();
  }

  @override
  ToolbarViewController initController() => ToolbarViewController();

  @override
  ToolbarViewController attachController(ToolbarViewController controller) {
    return controller.fromToolbarView(this);
  }

  @override
  Widget root(
    BuildContext context,
    ToolbarViewController controller,
    Widget parent,
  ) {
    if (controller.isElevated) {
      return Column(
        children: [
          parent,
          Container(
            width: double.infinity,
            height: controller.elevation,
            color: controller.elevationColor,
          )
        ],
      );
    } else {
      return parent;
    }
  }

  @override
  Widget? attach(BuildContext context, ToolbarViewController controller) {
    return AppBar(
      actions: controller.actions,
      actionsIconTheme: controller.iconTheme,
      automaticallyImplyLeading: controller.leadingAutoImply,
      backgroundColor: Colors.transparent,
      centerTitle: controller.titleCenter,
      elevation: 0,
      iconTheme: controller.iconTheme,
      leading: controller.leading == null
          ? null
          : Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [
                SizedBox(
                  width: controller.leadingSize,
                  child: controller.leading,
                ),
              ],
            ),
      leadingWidth: controller.leadingSize,
      systemOverlayStyle: controller.statusBarStyle,
      title: controller.titleCustom != null
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              children: [controller.titleCustom!],
            )
          : RawTextView(
              text: controller.title,
              textSize: controller.titleSize,
              textColor: controller.titleColor,
              textFontWeight: FontWeight.w500,
            ),
      titleSpacing: controller.titleSpacing,
      titleTextStyle: controller.titleStyle,
    );
  }
}

class ToolbarViewController extends ViewController {
  List<Widget>? actions;
  Color elevationColor = Colors.black12;
  IconThemeData? iconTheme;

  bool get isElevated => elevation > 0;

  ///LEADING
  Widget? leading;
  bool leadingAutoImply = true;
  dynamic leadingIcon = Icons.arrow_back;
  Color leadingIconColor = Colors.black;
  double leadingIconSize = 24;
  double? leadingSize;
  bool leadingVisible = true;
  OnViewClickListener? onLeadingClick;

  ///STATUS BAR
  Color? _statusBarColor;
  Brightness statusBarBrightness = Brightness.dark;
  Brightness? _statusBarIconBrightness;

  Color? get statusBarColor => _statusBarColor ?? Colors.transparent;

  set statusBarColor(Color? value) => _statusBarColor = value;

  Brightness get statusBarIconBrightness =>
      _statusBarIconBrightness ?? statusBarBrightness;

  set statusBarIconBrightness(Brightness? value) =>
      _statusBarIconBrightness = value;

  SystemUiOverlayStyle get statusBarStyle {
    return SystemUiOverlayStyle(
      statusBarBrightness: statusBarBrightness,
      statusBarIconBrightness: statusBarIconBrightness,
      statusBarColor: statusBarColor,
    );
  }

  void changeStatusBarColor(Color? color) {
    changeStatusBar(statusBarStyle.copyWith(statusBarColor: color));
  }

  void changeStatusBarBrightness(Brightness? brightness) {
    changeStatusBar(statusBarStyle.copyWith(
      statusBarBrightness: brightness,
    ));
  }

  void changeStatusBarIconBrightness(Brightness? brightness) {
    changeStatusBar(statusBarStyle.copyWith(
      statusBarIconBrightness: brightness,
    ));
  }

  void changeStatusBar([SystemUiOverlayStyle? style]) =>
      SystemChrome.setSystemUIOverlayStyle(style ?? statusBarStyle);

  ///TITLE
  String? title;
  bool? titleCenter;
  Color titleColor = Colors.black;
  Widget? titleCustom;
  double titleSize = 16;
  double? titleSpacing;
  TextStyle? titleStyle;

  ToolbarViewController fromToolbarView(ToolbarView view) {
    super.fromView(view);
    actions = view.actions;
    elevationColor = view.elevationColor;
    iconTheme = view.iconTheme;

    ///LEADING
    leading = view.leading;
    leadingAutoImply = view.leadingAutoImply ?? true;
    leadingIcon = view.leadingIcon;
    leadingIconColor = view.leadingIconColor ?? Colors.black;
    leadingIconSize = view.leadingIconSize ?? 24;
    leadingSize = view.leadingSize;
    leadingVisible = view.leadingVisible ?? true;
    onLeadingClick = view.onLeadingClick;

    ///STATUS BAR
    statusBarColor = view.statusBarColor;
    statusBarBrightness = view.statusBarBrightness ?? Brightness.dark;
    statusBarIconBrightness = view.statusBarIconBrightness;

    ///TITLE
    title = view.title;
    titleCenter = view.titleCenter;
    titleColor = view.titleColor ?? Colors.black;
    titleCustom = view.titleCustom;
    titleSize = view.titleSize ?? 16;
    titleSpacing = view.titleSpacing;
    titleStyle = view.titleStyle;

    return this;
  }
}
