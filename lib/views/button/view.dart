import 'package:flutter/material.dart';

import '../icon/view.dart';
import '../text/view.dart';
import '../view/view.dart';

part 'alignment.dart';
part 'controller.dart';
part 'icon.dart';
part 'text.dart';

class Button<T extends ButtonController> extends TextView<T> {
  final dynamic icon;
  final ValueState<dynamic>? iconState;
  final IconAlignment iconAlignment;
  final bool iconFlexible;
  final bool iconOnly;
  final Color? iconTint;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final ValueState<Color>? iconTintState;
  final bool iconTintEnabled;
  final double? iconSpace;
  final bool textCenter;

  const Button({
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

    /// SUPER TEXT PROPERTIES
    super.text,
    super.textSize,
    super.textFontWeight,
    super.textStyle,
    super.textAllCaps,
    super.textColor,
    super.textColorState,
    super.textState,

    /// CHILD PROPERTIES
    this.icon,
    this.iconState,
    this.iconAlignment = IconAlignment.end,
    this.iconFlexible = false,
    this.iconOnly = false,
    this.iconSize,
    this.iconSizeState,
    this.iconTint,
    this.iconTintState,
    this.iconTintEnabled = true,
    this.iconSpace,
    this.textCenter = false,
  });

  @override
  T initController() => ButtonController() as T;

  @override
  T attachController(T controller) => controller.fromButton(this) as T;

  @override
  Widget? attach(BuildContext context, T controller) {
    if (controller.iconOnly) {
      return _Icon(
        controller: controller,
        visible: controller.icon != null,
      );
    }
    return controller.isCenterText
        ? Stack(
            alignment: Alignment.center,
            children: [
              _Text(controller: controller),
              _Icon(
                controller: controller,
                visible: controller.icon != null,
              ),
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Icon(
                controller: controller,
                visible: controller.isStartIconVisible,
              ),
              if (controller.isStartIconFlex) const Spacer(),
              _Text(controller: controller),
              if (controller.isEndIconFlex) const Spacer(),
              _Icon(
                controller: controller,
                visible: controller.isEndIconVisible,
              ),
            ],
          );
  }
}
