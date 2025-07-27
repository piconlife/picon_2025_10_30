import 'dart:math';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../widgets/widget_wrapper.dart';

part 'controller.dart';

part 'decoration.dart';

part 'typedefs.dart';

part 'value_state.dart';

part 'value_state_type.dart';

part 'view_corner_radius.dart';

part 'view_error.dart';

part 'view_listener.dart';

part 'view_listener_effect.dart';

part 'view_position.dart';

part 'view_position_type.dart';

part 'view_recognizer.dart';

part 'view_roots.dart';

part 'view_scrolling_type.dart';

part 'view_shadow_type.dart';

part 'view_shape.dart';

part 'view_state.dart';

part 'view_toggle_content.dart';

class YMRView<T extends ViewController> extends StatefulWidget {
  /// ROOT PROPERTIES
  final T? controller;

  /// CALLBACK PROPERTIES
  final OnViewActivator? onActivator;
  final OnViewChangeListener? onChange;
  final OnViewErrorListener? onError;
  final OnViewHoverListener? onHover;
  final OnViewValidListener? onValid;
  final OnViewValidatorListener? onValidator;

  /// CLICK PROPERTIES
  final ViewClickEffect? clickEffect;
  final OnViewClickListener? onClick, onDoubleClick, onLongClick;
  final OnViewToggleListener? onToggleClick;
  final OnViewNotifyListener<T>? onClickHandler, onDoubleClickHandler;
  final OnViewNotifyListener<T>? onLongClickHandler;

  /// BACKDROP PROPERTIES
  final ImageFilter? backdropFilter;
  final BlendMode? backdropMode;

  /// BORDER PROPERTIES
  final Color? borderColor;
  final ValueState<Color>? borderColorState;
  final double? borderSize;
  final ValueState<double>? borderSizeState;
  final double? borderHorizontal, borderVertical;
  final ValueState<double>? borderHorizontalState, borderVerticalState;
  final double? borderTop, borderBottom, borderStart, borderEnd;
  final ValueState<double>? borderTopState, borderBottomState;
  final ValueState<double>? borderStartState, borderEndState;
  final double? borderStrokeAlign;

  /// BORDER RADIUS PROPERTIES
  final double? borderRadius;
  final ValueState<double>? borderRadiusState;
  final double? borderRadiusBL, borderRadiusBR, borderRadiusTL, borderRadiusTR;
  final ValueState<double>? borderRadiusBLState, borderRadiusBRState;
  final ValueState<double>? borderRadiusTLState, borderRadiusTRState;

  /// INDICATOR PROPERTIES
  final bool indicatorVisible;

  /// MARGIN PROPERTIES
  final double? margin;
  final double? marginHorizontal, marginVertical;
  final double? marginTop, marginBottom, marginStart, marginEnd;
  final EdgeInsets? marginCustom;

  /// OPACITY PROPERTIES
  final double? opacity;
  final ValueState<double>? opacityState;
  final bool opacityAlwaysIncludeSemantics;

  /// PADDING PROPERTIES
  final double? padding;
  final double? paddingHorizontal, paddingVertical;
  final double? paddingTop, paddingBottom, paddingStart, paddingEnd;
  final EdgeInsets? paddingCustom;

  /// SHADOW PROPERTIES
  final double? shadow;
  final double? shadowBlurRadius, shadowSpreadRadius;
  final double? shadowHorizontal, shadowVertical;
  final double? shadowStart, shadowEnd, shadowTop, shadowBottom;

  ///
  ///
  ///
  ///
  ///
  final int? flex;
  final bool? absorbMode, activated, enabled, expandable, scrollable, wrapper;

  final int? animation;
  final Curve? animationType;

  final double? elevation;
  final double? dimensionRatio;

  final double? width, widthMax, widthMin;
  final ValueState<double>? widthState;
  final double? height, heightMax, heightMin;
  final ValueState<double>? heightState;

  final Color? background, foreground, shadowColor;
  final Color hoverColor, pressedColor, rippleColor;

  final DecorationImage? backgroundImage, foregroundImage;
  final Gradient? backgroundGradient, foregroundGradient;
  final Matrix4? transform;

  final Alignment? gravity, transformGravity;
  final BlendMode? backgroundBlendMode, foregroundBlendMode;
  final BlurStyle? shadowBlurStyle;
  final Clip? clipBehavior;

  final ValueState<Color>? backgroundState;
  final ValueState<Gradient>? backgroundGradientState;
  final ValueState<DecorationImage>? backgroundImageState;

  final Axis? orientation;
  final ViewScrollingType? scrollingType;
  final ScrollController? scrollController;

  final ViewShadowType? shadowType;
  final ViewPosition? position;
  final ViewPositionType? positionType;
  final ViewShape? shape;
  final bool? visibility;

  final Widget? child;

  const YMRView({
    /// ROOT PROPERTIES
    super.key,

    /// LISTENER PROPERTIES
    this.clickEffect,
    this.onClick,
    this.onDoubleClick,
    this.onLongClick,
    this.onClickHandler,
    this.onDoubleClickHandler,
    this.onLongClickHandler,
    this.onHover,
    this.onToggleClick,

    /// CALLBACK PROPERTIES
    this.onActivator,
    this.onChange,
    this.onError,
    this.onValid,
    this.onValidator,

    ///BASE PROPERTIES
    this.controller,
    this.absorbMode,
    this.activated,
    this.background,
    this.backgroundState,
    this.backgroundBlendMode,
    this.backgroundGradient,
    this.backgroundGradientState,
    this.backgroundImage,
    this.backgroundImageState,
    this.clipBehavior,
    this.dimensionRatio,
    this.elevation,
    this.enabled,
    this.expandable,
    this.foreground,
    this.foregroundBlendMode,
    this.foregroundGradient,
    this.foregroundImage,
    this.flex,
    this.gravity,
    this.height,
    this.heightState,
    this.heightMax,
    this.heightMin,
    this.hoverColor = Colors.transparent,
    this.orientation,
    this.position,
    this.positionType,
    this.pressedColor = Colors.transparent,
    this.rippleColor = Colors.transparent,
    this.scrollable,
    this.scrollController,
    this.scrollingType,
    this.shape,
    this.transform,
    this.transformGravity,
    this.visibility,
    this.width,
    this.widthState,
    this.widthMax,
    this.widthMin,

    /// ANIMATION PROPERTIES
    this.animation,
    this.animationType,

    /// BACKDROP PROPERTIES
    this.backdropFilter,
    this.backdropMode,

    /// BORDER PROPERTIES
    this.borderColor,
    this.borderColorState,
    this.borderSize,
    this.borderSizeState,
    this.borderHorizontal,
    this.borderHorizontalState,
    this.borderVertical,
    this.borderVerticalState,
    this.borderTop,
    this.borderTopState,
    this.borderBottom,
    this.borderBottomState,
    this.borderStart,
    this.borderStartState,
    this.borderEnd,
    this.borderEndState,
    this.borderStrokeAlign,

    /// BORDER RADIUS PROPERTIES
    this.borderRadius,
    this.borderRadiusState,
    this.borderRadiusBL,
    this.borderRadiusBLState,
    this.borderRadiusBR,
    this.borderRadiusBRState,
    this.borderRadiusTL,
    this.borderRadiusTLState,
    this.borderRadiusTR,
    this.borderRadiusTRState,

    /// INDICATOR PROPERTIES
    this.indicatorVisible = false,

    /// MARGIN PROPERTIES
    this.margin,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginBottom,
    this.marginStart,
    this.marginEnd,
    this.marginCustom,

    /// OPACITY PROPERTIES
    this.opacity,
    this.opacityState,
    this.opacityAlwaysIncludeSemantics = false,

    /// PADDING PROPERTIES
    this.padding,
    this.paddingHorizontal,
    this.paddingVertical,
    this.paddingTop,
    this.paddingBottom,
    this.paddingStart,
    this.paddingEnd,
    this.paddingCustom,

    /// SHADOW PROPERTIES
    this.shadow,
    this.shadowBlurRadius,
    this.shadowBlurStyle,
    this.shadowColor,
    this.shadowType,
    this.shadowSpreadRadius,
    this.shadowHorizontal,
    this.shadowVertical,
    this.shadowStart,
    this.shadowEnd,
    this.shadowTop,
    this.shadowBottom,

    /// OPTIONAL PROPERTIES
    this.wrapper,
    this.child,
  });

  T initController() => ViewController() as T;

  T attachController(T controller) => controller.fromView(this) as T;

  void onViewCreated(BuildContext context, T controller) {}

  void onToggleHandler(BuildContext context, T controller) {}

  Widget root(BuildContext context, T controller, Widget parent) => parent;

  Widget build(BuildContext context, T controller, Widget parent) => parent;

  Widget? attach(BuildContext context, T controller) => controller.child;

  ViewRoots initRootProperties() => const ViewRoots();

  @mustCallSuper
  void onInit(BuildContext context, T controller) {}

  @mustCallSuper
  void onReady(BuildContext context, T controller) {}

  @mustCallSuper
  void onUpdateWidget(BuildContext context, T controller, dynamic oldWidget) {}

  @mustCallSuper
  void onChangeDependencies(BuildContext context, T controller) {}

  @mustCallSuper
  void onDispose(BuildContext context, T controller) => controller._dispose();

  @override
  State<YMRView<T>> createState() => _ViewState<T>();
}
