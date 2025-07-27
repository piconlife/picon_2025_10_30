import 'package:flutter/material.dart';

import '../icon/view.dart';
import '../view/view.dart';

class TabView extends YMRView<TabViewController> {
  final Color? contentColor;
  final ValueState<Color>? contentColorState;
  final dynamic icon;
  final ValueState? iconState;
  final Color? iconTint;
  final ValueState<Color>? iconTintState;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final double? iconSpace;
  final bool? inline;
  final String? title;
  final ValueState<String>? titleState;
  final double? titleSize;
  final ValueState<double>? titleSizeState;
  final FontWeight? titleWeight;
  final ValueState<FontWeight>? titleWeightState;

  final bool Function(bool selected)? onVisibleIconWhenTabSelected;
  final bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  const TabView({
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
    this.contentColor,
    this.contentColorState,
    this.icon,
    this.iconState,
    this.iconTint,
    this.iconTintState,
    this.iconSize,
    this.iconSizeState,
    this.iconSpace,
    this.inline,
    this.title,
    this.titleState,
    this.titleSize,
    this.titleSizeState,
    this.titleWeight,
    this.titleWeightState,
    this.onVisibleIconWhenTabSelected,
    this.onVisibleTitleWhenTabSelected,
  });

  @override
  TabViewController initController() {
    return TabViewController();
  }

  @override
  TabViewController attachController(TabViewController controller) {
    return controller.fromView(
      this,
      contentColor: contentColor,
      contentColorState: contentColorState,
      icon: icon,
      iconState: iconState,
      size: iconSize,
      iconSizeState: iconSizeState,
      iconSpace: iconSpace,
      iconTint: iconTint,
      iconTintState: iconTintState,
      inline: inline,
      title: title,
      titleState: titleState,
      titleSize: titleSize,
      titleSizeState: titleSizeState,
      titleWeight: titleWeight,
      titleWeightState: titleWeightState,
      onVisibleIconWhenTabSelected: onVisibleIconWhenTabSelected,
      onVisibleTitleWhenTabSelected: onVisibleTitleWhenTabSelected,
    );
  }

  @override
  Widget? attach(BuildContext context, TabViewController controller) {
    return controller.inline
        ? _TabViewX(controller: controller)
        : _TabViewY(controller: controller);
  }
}

class TabViewController extends ViewController {
  Color _contentColor = const Color(0xFF808080);
  ValueState<Color>? contentColorState;
  dynamic _icon;
  ValueState? iconState;
  Color? _iconTint;
  ValueState<Color>? iconTintState;
  double _iconSize = 24;
  ValueState<double>? iconSizeState;
  double iconSpace = 6;
  bool inline = false;
  String? _title;
  ValueState<String>? titleState;
  double _titleSize = 12;
  ValueState<double>? titleSizeState;
  FontWeight? _titleWeight;
  ValueState<FontWeight>? titleWeightState;

  bool Function(bool selected)? onVisibleIconWhenTabSelected;
  bool Function(bool selected)? onVisibleTitleWhenTabSelected;

  @override
  TabViewController fromView(
    YMRView<ViewController> view, {
    Color? contentColor,
    ValueState<Color>? contentColorState,
    dynamic icon,
    ValueState? iconState,
    Color? iconTint,
    ValueState<Color>? iconTintState,
    double? size,
    ValueState<double>? iconSizeState,
    double? iconSpace,
    bool? inline,
    String? title,
    ValueState<String>? titleState,
    double? titleSize,
    ValueState<double>? titleSizeState,
    FontWeight? titleWeight,
    ValueState<FontWeight>? titleWeightState,
    bool Function(bool selected)? onVisibleIconWhenTabSelected,
    bool Function(bool selected)? onVisibleTitleWhenTabSelected,
  }) {
    super.fromView(view);
    _contentColor = contentColor ?? const Color(0xFF808080);
    this.contentColorState = contentColorState;
    _icon = icon;
    this.iconState = iconState;
    _iconTint = iconTint;
    this.iconTintState = iconTintState;
    _iconSize = size ?? 24;
    this.iconSizeState = iconSizeState;
    this.iconSpace = iconSpace ?? 6;
    this.inline = inline ?? false;
    _title = title;
    this.titleState = titleState;
    _titleSize = titleSize ?? 12;
    this.titleSizeState = titleSizeState;
    _titleWeight = titleWeight;
    this.titleWeightState = titleWeightState;
    this.onVisibleIconWhenTabSelected = onVisibleIconWhenTabSelected;
    this.onVisibleTitleWhenTabSelected = onVisibleTitleWhenTabSelected;
    return this;
  }

  Color? get contentColor =>
      contentColorState?.fromController(this) ?? _contentColor;

  String get title => titleState?.fromController(this) ?? _title ?? "";

  double get titleSize => titleSizeState?.fromController(this) ?? _titleSize;

  FontWeight? get titleWeight =>
      titleWeightState?.fromController(this) ?? _titleWeight;

  dynamic get icon => iconState?.fromController(this) ?? _icon;

  Color? get iconTint =>
      iconTintState?.fromController(this) ?? _iconTint ?? contentColor;

  double get iconSize => iconSizeState?.fromController(this) ?? _iconSize;

  double get _iconSpacingX => inline && titleVisible ? iconSpace : 0;

  double get _iconSpacingY => inline && titleVisible ? 0 : iconSpace;

  bool get iconVisible => icon != null && _isVisibleIconWhenSelected;

  bool get titleVisible => title.isNotEmpty && _isVisibleTitleWhenSelected;

  bool get _isVisibleIconWhenSelected {
    return onVisibleIconWhenTabSelected?.call(activated) ?? true;
  }

  bool get _isVisibleTitleWhenSelected {
    return onVisibleTitleWhenTabSelected?.call(activated) ?? true;
  }
}

class _TabViewX extends StatelessWidget {
  final TabViewController controller;

  const _TabViewX({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (controller.iconVisible) _TabViewIcon(controller: controller),
        if (controller.titleVisible) _TabViewText(controller: controller),
      ],
    );
  }
}

class _TabViewY extends StatelessWidget {
  final TabViewController controller;

  const _TabViewY({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (controller.iconVisible) _TabViewIcon(controller: controller),
        if (controller.titleVisible) _TabViewText(controller: controller),
      ],
    );
  }
}

class _TabViewIcon extends StatelessWidget {
  final TabViewController controller;

  const _TabViewIcon({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        right: controller._iconSpacingX,
        bottom: controller._iconSpacingY,
      ),
      child: RawIconView(
        icon: controller.icon,
        size: controller.iconSize,
        tint: controller.iconTint,
      ),
    );
  }
}

class _TabViewText extends StatelessWidget {
  final TabViewController controller;

  const _TabViewText({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Text(
      controller.title,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: controller.contentColor,
        fontWeight: controller.titleWeight,
        fontSize: controller.titleSize,
      ),
    );
  }
}
