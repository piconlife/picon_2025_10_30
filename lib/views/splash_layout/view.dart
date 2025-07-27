import 'dart:async';

import 'package:flutter/material.dart';

import '../axis/view.dart';
import '../view/view.dart';

typedef OnSplashLayoutExecuteListener = Future Function(BuildContext context);
typedef OnSplashLayoutRouteListener = Function(BuildContext context);

class SplashLayout<T extends SplashLayoutController> extends YMRView<T> {
  final int duration;
  final double axisY;
  final double axisX;

  final Widget? content;
  final Widget? footer;

  final OnSplashLayoutExecuteListener? onExecute;
  final OnSplashLayoutRouteListener? onRoute;

  const SplashLayout({
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
    this.duration = 5000,
    this.axisX = 0,
    this.axisY = 0,
    this.content,
    this.footer,
    this.onRoute,
    this.onExecute,
  });

  @override
  T initController() => SplashLayoutController() as T;

  @override
  T attachController(T controller) {
    return controller.fromSplashLayout(this) as T;
  }

  @override
  Widget? attach(BuildContext context, T controller) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AxisView(
            x: controller.axisX,
            y: controller.axisY,
            child: controller.content,
          ),
          Positioned(
            bottom: 0,
            child: controller.footer ?? const SizedBox(),
          ),
        ],
      ),
    );
  }

  @override
  void onReady(context, controller) {
    super.onReady(context, controller);
    controller._config(context);
  }

  @override
  void onDispose(BuildContext context, T controller) {
    controller._dispose();
    super.onDispose(context, controller);
  }
}

class SplashLayoutController extends ViewController {
  double axisX = 0;

  void setAxisX(double value) {
    onNotifyWithCallback(() => axisX = value);
  }

  double axisY = 0;

  void setAxisY(double value) {
    onNotifyWithCallback(() => axisY = value);
  }

  int duration = 500;

  void setDuration(int value) {
    onNotifyWithCallback(() => duration = value);
  }

  Widget? content;

  void setContent(Widget? value) {
    onNotifyWithCallback(() => content = value);
  }

  Widget? footer;

  void setFooter(Widget? value) {
    onNotifyWithCallback(() => footer = value);
  }

  OnSplashLayoutExecuteListener? _onExecute;

  OnSplashLayoutExecuteListener? get onExecute => enabled ? _onExecute : null;

  void setOnExecuteListener(OnSplashLayoutExecuteListener listener) {
    _onExecute = listener;
  }

  OnSplashLayoutRouteListener? _onRoute;

  OnSplashLayoutRouteListener? get onRoute => enabled ? _onRoute : null;

  void setOnRouteListener(OnSplashLayoutRouteListener listener) {
    _onRoute = listener;
  }

  SplashLayoutController fromSplashLayout(SplashLayout view) {
    super.fromView(view);
    axisX = view.axisX;
    axisY = view.axisY;
    duration = view.duration;
    content = view.content;
    footer = view.footer;
    _onExecute = view.onExecute;
    _onRoute = view.onRoute;
    return this;
  }

  Timer? _timer;

  bool get isExecutable => onExecute != null;

  void _config(BuildContext context) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: duration), () {
      if (isExecutable) {
        onExecute?.call(context).whenComplete(() {
          return onRoute?.call(context);
        });
      } else {
        onRoute?.call(context);
      }
    });
  }

  void _dispose() {
    _timer?.cancel();
  }
}
