import 'package:flutter/material.dart';

import '../view/view.dart';

part 'controller.dart';
part 'loading_state.dart';
part 'typedefs.dart';

class LoaderView<T> extends YMRView<LoaderViewController<T>> {
  final LoaderViewFutureDataLoader<T>? future;
  final LoaderViewStreamDataLoader<T>? stream;
  final LoaderViewBuilder<T>? onLoading;
  final LoaderViewBuilder<T> onLoaded;
  final LoaderViewBuilder<T>? onNullable;
  final LoaderViewBuilder<T>? onFailed;
  final bool connection;

  const LoaderView({
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
    this.connection = true,
    this.future,
    this.stream,
    this.onLoading,
    required this.onLoaded,
    this.onNullable,
    this.onFailed,
  });

  @override
  LoaderViewController<T> initController() => LoaderViewController();

  @override
  LoaderViewController<T> attachController(LoaderViewController<T> controller) {
    return controller.fromLoaderView(this);
  }

  @override
  Widget? attach(BuildContext context, LoaderViewController<T> controller) {
    if (connection) {
      if (stream != null) {
        return StreamBuilder(
          stream: stream?.call(),
          builder: (context, snapshot) {
            controller.data = snapshot.data;
            var state = LoadingState.from(snapshot);
            Widget? child;
            if (state.isLoading) {
              child = onLoading?.call(context, controller);
            } else if (state.isNullable) {
              child = onNullable?.call(context, controller);
            } else {
              return onLoaded(context, controller);
            }
            return child ?? onLoaded(context, controller);
          },
        );
      } else {
        return FutureBuilder(
          future: future?.call(),
          builder: (context, snapshot) {
            controller.data = snapshot.data;
            var state = LoadingState.from(snapshot);
            Widget? child;
            if (state.isLoading) {
              child = onLoading?.call(context, controller);
            } else if (state.isNullable) {
              child = onNullable?.call(context, controller);
            } else {
              return onLoaded(context, controller);
            }
            return child ?? onLoaded(context, controller);
          },
        );
      }
    } else {
      return onFailed?.call(context, controller) ??
          onLoaded(context, controller);
    }
  }
}
