import 'package:flutter/material.dart';

import '../icon/view.dart';
import '../text/view.dart';
import '../view/view.dart';

part 'controller.dart';
part 'model.dart';
part 'typedefs.dart';

class DropdownView<T extends Object>
    extends TextView<DropdownViewController<T>> {
  final int selectedIndex;
  final List<DropdownItem<T>> items;

  /// DRAWABLE PROPERTIES
  final dynamic leadingIcon;
  final ValueState<dynamic>? leadingIconState;
  final DropdownDrawableBuilder? leadingIconBuilder;
  final double? leadingIconSize;
  final ValueState<double>? leadingIconSizeState;
  final Color? leadingIconTint;
  final ValueState<Color>? leadingIconTintState;
  final bool leadingIconVisible;

  final dynamic trailingIcon;
  final ValueState<dynamic>? trailingIconState;
  final DropdownDrawableBuilder? trailingIconBuilder;
  final double? trailingIconSize;
  final ValueState<double>? trailingIconSizeState;
  final Color? trailingIconTint;
  final ValueState<Color>? trailingIconTintState;
  final bool trailingIconVisible;

  final dynamic trailingSelectedIcon;
  final ValueState<dynamic>? trailingSelectedIconState;
  final DropdownDrawableBuilder? trailingSelectedIconBuilder;
  final double? trailingSelectedIconSize;
  final ValueState<double>? trailingSelectedIconSizeState;
  final Color? trailingSelectedIconTint;
  final ValueState<Color>? trailingSelectedIconTintState;
  final bool trailingSelectedIconVisible;

  /// LISTENERS
  final DropdownItemSelectedListener<T>? onItemSelected;

  const DropdownView({
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
    super.textStyle,

    /// CHILD PROPERTIES
    this.selectedIndex = 0,
    required this.items,

    /// DRAWABLE PROPERTIES
    this.leadingIcon,
    this.leadingIconState,
    this.leadingIconBuilder,
    this.leadingIconSize,
    this.leadingIconSizeState,
    this.leadingIconTint,
    this.leadingIconTintState,
    this.leadingIconVisible = true,
    this.trailingIcon,
    this.trailingIconState,
    this.trailingIconBuilder,
    this.trailingIconSize,
    this.trailingIconSizeState,
    this.trailingIconTint,
    this.trailingIconTintState,
    this.trailingIconVisible = true,
    this.trailingSelectedIcon,
    this.trailingSelectedIconState,
    this.trailingSelectedIconBuilder,
    this.trailingSelectedIconSize,
    this.trailingSelectedIconSizeState,
    this.trailingSelectedIconTint,
    this.trailingSelectedIconTintState,
    this.trailingSelectedIconVisible = true,

    /// LISTENERS
    this.onItemSelected,
  }) : super(text: "");

  @override
  DropdownViewController<T> initController() => DropdownViewController();

  @override
  DropdownViewController<T> attachController(
    DropdownViewController<T> controller,
  ) {
    return controller.fromDropdownView(this);
  }

  @override
  Widget? attach(BuildContext context, DropdownViewController<T> controller) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return DropdownMenu<T>(
          width: constraints.maxWidth,
          initialSelection: controller.selectedItem,
          textStyle: controller.textStyle,
          leadingIcon: controller.leadingIconVisible
              ? Builder(
                  builder: (context) {
                    if (leadingIconBuilder != null) {
                      return leadingIconBuilder!(context);
                    } else {
                      return RawIconView(
                        icon: controller.leadingIcon,
                        tint: controller.leadingIconTint,
                        size: controller.leadingIconSize ?? 18,
                      );
                    }
                  },
                )
              : null,
          trailingIcon: controller.trailingIconVisible
              ? Builder(
                  builder: (context) {
                    if (trailingIconBuilder != null) {
                      return trailingIconBuilder!(context);
                    } else {
                      return RawIconView(
                        icon: controller.trailingIcon ??
                            Icons.keyboard_arrow_down,
                        tint: controller.trailingIconTint,
                        size: controller.trailingIconSize ?? 18,
                      );
                    }
                  },
                )
              : const SizedBox(),
          selectedTrailingIcon: controller.trailingSelectedIconVisible
              ? Builder(
                  builder: (context) {
                    if (trailingSelectedIconBuilder != null) {
                      return trailingSelectedIconBuilder!(context);
                    } else {
                      return RawIconView(
                        icon: controller.trailingSelectedIcon ??
                            Icons.keyboard_arrow_up,
                        tint: controller.trailingSelectedIconTint,
                        size: controller.trailingSelectedIconSize ?? 18,
                      );
                    }
                  },
                )
              : const SizedBox(),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: InputBorder.none,
            constraints: BoxConstraints(
              minWidth: constraints.minWidth,
              minHeight: constraints.minHeight,
              maxWidth: constraints.maxWidth,
              maxHeight: constraints.maxHeight,
            ),
            contentPadding: EdgeInsets.zero,
          ),
          menuStyle: MenuStyle(
            padding: MaterialStateProperty.all(EdgeInsets.zero),
          ),
          dropdownMenuEntries: items.map((e) {
            return DropdownMenuEntry<T>(
              value: e.value,
              label: e.name,
            );
          }).toList(),
          onSelected: onItemSelected,
        );
      },
    );
  }
}
