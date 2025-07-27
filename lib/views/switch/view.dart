import 'package:flutter/material.dart';

import '../icon/view.dart';
import '../view/view.dart';

part 'config.dart';
part 'controller.dart';
part 'extensions.dart';
part 'raw.dart';

class SwitchView extends YMRView<SwitchViewController> {
  final double size;

  final Color? activeThumbColor;
  final Color? inactiveThumbColor;
  final Color? activeThumbStrokeColor;
  final Color? inactiveThumbStrokeColor;
  final Color? activeTrackColor;
  final Color? inactiveTrackColor;
  final Color? activeTrackStrokeColor;
  final Color? inactiveTrackStrokeColor;

  final dynamic activeThumbIcon;
  final dynamic inactiveThumbIcon;
  final Color? activeThumbIconTint;
  final Color? inactiveThumbIconTint;

  final double? activeThumbSpacing;
  final double? inactiveThumbSpacing;
  final double? activeThumbStrokeSize;
  final double? inactiveThumbStrokeSize;

  final double? thumbIconSpacing;
  final int thumbWalkingTime;
  final double? trackBorderRadius;
  final double? trackStrokeSize;
  final double trackRatio;

  const SwitchView({
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
    this.size = 30,
    this.activeThumbColor,
    this.inactiveThumbColor,
    this.activeThumbStrokeColor,
    this.inactiveThumbStrokeColor,
    this.activeTrackColor,
    this.inactiveTrackColor,
    this.activeTrackStrokeColor,
    this.inactiveTrackStrokeColor,
    this.activeThumbIcon,
    this.inactiveThumbIcon,
    this.activeThumbIconTint,
    this.inactiveThumbIconTint,
    this.activeThumbSpacing,
    this.inactiveThumbSpacing,
    this.activeThumbStrokeSize,
    this.inactiveThumbStrokeSize,
    this.thumbIconSpacing,
    this.thumbWalkingTime = 200,
    this.trackBorderRadius,
    this.trackStrokeSize,
    this.trackRatio = 1.65,
    bool? value,
  }) : super(activated: value);

  @override
  SwitchViewController initController() {
    return SwitchViewController();
  }

  @override
  SwitchViewController attachController(controller) {
    return controller.fromSwitchView(this);
  }

  @override
  Widget? attach(context, controller) {
    return SwitchButton(
      activeThumbColor: activeThumbColor,
      activeThumbIcon: activeThumbIcon,
      activeThumbIconTint: activeThumbIconTint,
      activeThumbStrokeColor: activeThumbStrokeColor,
      activeThumbStrokeSize: activeThumbStrokeSize,
      activeThumbSpacing: activeThumbSpacing,
      activeTrackColor: activeTrackColor,
      activeTrackStrokeColor: activeTrackStrokeColor,
      inactiveThumbColor: inactiveThumbColor,
      inactiveThumbIcon: inactiveThumbIcon,
      inactiveThumbIconTint: inactiveThumbIconTint,
      inactiveThumbStrokeColor: inactiveThumbStrokeColor,
      inactiveThumbStrokeSize: inactiveThumbStrokeSize,
      inactiveThumbSpacing: inactiveThumbSpacing,
      inactiveTrackColor: inactiveTrackColor,
      inactiveTrackStrokeColor: inactiveTrackStrokeColor,
      enabled: controller.enabled,
      size: size,
      thumbIconSpacing: thumbIconSpacing,
      thumbWalkingTime: thumbWalkingTime,
      trackBorderRadius: trackBorderRadius,
      trackRatio: trackRatio,
      trackStrokeSize: trackStrokeSize,
      value: controller.activated,
    );
  }
}
