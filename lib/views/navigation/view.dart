import 'package:flutter/material.dart';

import '../icon/view.dart';
import '../linear_layout/view.dart';
import '../text/view.dart';
import '../view/view.dart';

part 'controller.dart';
part 'item.dart';
part 'type.dart';
part 'typedefs.dart';

class NavigationView extends YMRView<NavigationViewController> {
  final int currentIndex;
  final double? iconSize;
  final ValueState<double>? iconSizeState;
  final Color? iconTint;
  final ValueState<Color>? iconTintState;
  final IconThemeData? iconTheme;
  final ValueState<IconThemeData>? iconThemeState;
  final Color? titleColor;
  final ValueState<Color>? titleColorState;
  final double? titleSize;
  final ValueState<double>? titleSizeState;
  final TextStyle? titleStyle;
  final ValueState<TextStyle>? titleStyleState;
  final double spaceBetween;
  final ValueState<double>? spaceBetweenState;
  final Color? itemBackground;
  final ValueState<Color>? itemBackgroundState;
  final double? itemMaxWidth;
  final double? itemMaxHeight;
  final double itemMinWidth;
  final double? itemMinHeight;
  final double? itemMargin;
  final double? itemMarginX;
  final double? itemMarginY;
  final double? itemPadding;
  final double? itemPaddingX;
  final double? itemPaddingY;

  final LinearLayoutController? itemController;
  final IconViewController? iconController;
  final TextViewController? labelController;

  final List<NavigationItem> items;
  final NavigationViewBuilder builder;
  final OnNavigationIndexChangeListener? onIndexChanged;

  const NavigationView({
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
    this.currentIndex = 0,
    this.iconSize,
    this.iconSizeState,
    this.iconTint,
    this.iconTintState,
    this.iconTheme,
    this.iconThemeState,
    this.titleColor,
    this.titleColorState,
    this.titleSize,
    this.titleSizeState,
    this.titleStyle,
    this.titleStyleState,
    this.spaceBetween = 2,
    this.spaceBetweenState,
    this.itemBackground,
    this.itemBackgroundState,
    this.itemMaxWidth,
    this.itemMaxHeight,
    this.itemMinWidth = 80,
    this.itemMinHeight,
    this.itemMargin,
    this.itemMarginX,
    this.itemMarginY,
    this.itemPadding,
    this.itemPaddingX,
    this.itemPaddingY,
    this.itemController,
    this.iconController,
    this.labelController,
    required this.items,
    required this.builder,
    this.onIndexChanged,
  });

  @override
  ViewRoots initRootProperties() => const ViewRoots(position: false);

  @override
  NavigationViewController initController() => NavigationViewController();

  @override
  NavigationViewController attachController(
    NavigationViewController controller,
  ) {
    return controller.fromNavigationView(this);
  }

  @override
  Widget root(
    BuildContext context,
    NavigationViewController controller,
    Widget parent,
  ) {
    var isMargin = controller.marginAll > 0;
    var type = controller.positionType;

    if (isMargin) {
      return Stack(
        alignment: Alignment.center,
        children: [
          Expanded(child: builder(context, controller.currentIndex)),
          Positioned(
            left: type.position.left,
            right: type.position.right,
            top: type.position.top,
            bottom: type.position.bottom,
            child: parent,
          ),
        ],
      );
    } else {
      if (controller.positionType.isYMode) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.positionType.isTopMode) parent,
            Expanded(child: builder(context, controller.currentIndex)),
            if (controller.positionType.isBottomMode) parent,
          ],
        );
      } else {
        return Row(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (controller.positionType.isLeftMode) parent,
            Expanded(child: builder(context, controller.currentIndex)),
            if (controller.positionType.isRightMode) parent,
          ],
        );
      }
    }
  }

  @override
  Widget? attach(
    BuildContext context,
    NavigationViewController controller,
  ) {
    Widget child = Flex(
      direction: controller.navDirection,
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: controller.navCrossDirection,
      mainAxisAlignment: controller.navMainDirection,
      children: List.generate(controller.length, (index) {
        var item = controller.items[index];
        var selected = index == controller.currentIndex;
        Widget child = NavigationItem(
          key: item.key,
          isSelected: item.isSelected ? true : selected,
          isVisible: item.isVisible,
          icon: item.icon,
          iconState: item.iconState,
          iconSize: item.iconSize,
          iconSizeState: item.iconSizeState ?? controller.iconSizeState,
          iconTint: item.iconTint ?? controller.iconTint,
          iconTintState: item.iconTintState ?? controller.iconTintState,
          iconTheme: item.iconTheme ?? controller.iconTheme,
          iconThemeState: item.iconThemeState ?? controller.iconThemeState,
          title: item.title,
          titleState: item.titleState,
          titleColor: item.titleColor ?? controller.titleColor,
          titleColorState: item.titleColorState ?? controller.titleColorState,
          titleSize: item.titleSize ?? controller.titleSize,
          titleSizeState: item.titleSizeState ?? controller.titleSizeState,
          titleStyle: item.titleStyle ?? controller.titleStyle,
          titleStyleState: item.titleStyleState ?? controller.titleStyleState,
          background: item.background ?? controller.background,
          backgroundState: item.backgroundState ?? controller.backgroundState,
          maxWidth: item.maxWidth ?? controller.itemMaxWidth,
          minWidth: item.minWidth ?? controller.itemMinWidth,
          maxHeight: item.maxHeight ?? controller.itemMaxHeight,
          minHeight: item.minHeight ?? controller.itemMinHeight,
          margin: item.margin ?? controller.itemMargin,
          marginX: item.marginX ?? controller.itemMarginX,
          marginY: item.marginY ?? controller.itemMarginY,
          padding: item.padding ?? controller.itemPadding,
          paddingX: item.paddingX ?? controller.itemPaddingX,
          paddingY: item.paddingY ?? controller.itemPaddingY,
          spaceBetween: item.spaceBetween ?? controller.spaceBetween,
          spaceBetweenState:
              item.spaceBetweenState ?? controller.spaceBetweenState,
          iconController: item.iconController ?? iconController,
          itemController: item.itemController ?? itemController,
          labelController: item.labelController ?? labelController,
          onClick: (context) {
            if (item.onClick != null) item.onClick?.call(context);
            controller.onNotify(index);
          },
        );
        if (controller.navigationType.isFixed) {
          return Expanded(child: child);
        } else {
          return child;
        }
      }),
    );

    if (controller.navigationType.isScrollable) {
      return SingleChildScrollView(
        scrollDirection: controller.navDirection,
        child: child,
      );
    }
    return child;
  }
}
