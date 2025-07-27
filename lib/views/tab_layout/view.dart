import 'package:flutter/material.dart';

import '../tab/view.dart';
import '../view/view.dart';

part 'controller.dart';

part 'enums.dart';

part 'tab.dart';

part 'typedefs.dart';

class TabLayout extends YMRView<TabLayoutController> {
  /// BASE PROPERTIES
  final TabController tabController;
  final int initialIndex;
  final List<TabItem>? tabs;
  final Color? tabContentColor;
  final ValueState<Color>? tabContentColorState;
  final bool? tabInlineLabel;
  final EdgeInsets? tabMargin;
  final TabMode? tabMode;
  final EdgeInsets? tabPadding;

  /// TAB ICON PROPERTIES
  final double? tabIconSize;
  final ValueState<double>? tabIconSizeState;
  final Color? tabIconTint;
  final double? tabIconSpace;
  final ValueState<Color>? tabIconTintState;

  /// TAB TITLE PROPERTIES
  final double tabTitleSize;
  final ValueState<double>? tabTitleSizeState;
  final FontWeight? tabTitleWeight;
  final ValueState<FontWeight>? tabTitleWeightState;

  /// TAB INDICATOR PROPERTIES
  final Decoration? tabIndicator;
  final Color? tabIndicatorColor;
  final bool tabIndicatorFullWidth;
  final double tabIndicatorHeight;

  /// TAB LISTENER PROPERTIES
  final OnTabChangeListener? onTabChange;
  final OnTabContentVisibilityChecker? onTabIconVisibleWhenSelected;
  final OnTabContentVisibilityChecker? onTabTitleVisibleWhenSelected;

  const TabLayout({
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
    required this.tabController,
    this.initialIndex = 0,
    this.tabs,
    this.tabContentColor,
    this.tabContentColorState,
    this.tabInlineLabel,
    this.tabMargin,
    this.tabMode,
    this.tabPadding,
    this.tabIconSize,
    this.tabIconSizeState,
    this.tabIconTint,
    this.tabIconSpace,
    this.tabIconTintState,
    this.tabTitleSize = 12,
    this.tabTitleSizeState,
    this.tabTitleWeight,
    this.tabTitleWeightState,
    this.tabIndicator,
    this.tabIndicatorColor,
    this.tabIndicatorFullWidth = false,
    this.tabIndicatorHeight = 2,

    /// TAB LISTENER PROPERTIES
    this.onTabChange,
    this.onTabIconVisibleWhenSelected,
    this.onTabTitleVisibleWhenSelected,
  });

  @override
  TabLayoutController initController() => TabLayoutController();

  @override
  TabLayoutController attachController(TabLayoutController controller) {
    return controller.fromTabLayout(this);
  }

  @override
  void onInit(BuildContext context, TabLayoutController controller) {
    super.onInit(context, controller);
    final tc = tabController;
    controller.currentIndex = tc.index;
    final anim = tc.animation;
    if (anim != null) {
      anim.addListener(() => controller.setPage(anim.value));
    }
  }

  @override
  void onDispose(BuildContext context, TabLayoutController controller) {
    super.onDispose(context, controller);
    final anim = tabController.animation;
    if (anim != null) {
      anim.removeListener(() => controller.setPage(anim.value));
    }
  }

  @override
  Widget? attach(BuildContext context, TabLayoutController controller) {
    return TabBar(
      automaticIndicatorColorAdjustment: true,
      controller: tabController,
      dividerColor: null,
      enableFeedback: null,
      indicator: controller.tabIndicator,
      indicatorColor: controller.tabIndicatorColor,
      indicatorPadding: EdgeInsets.zero,
      indicatorSize: controller.tabIndicatorFullWidth
          ? TabBarIndicatorSize.tab
          : TabBarIndicatorSize.label,
      indicatorWeight: controller.tabIndicatorHeight,
      isScrollable: controller.tabMode == TabMode.scrollable,
      key: key,
      labelPadding: controller.tabMode == TabMode.scrollable
          ? controller.tabMargin
          : null,
      onTap: controller.setIndex,
      overlayColor: null,
      padding: null,
      physics: null,
      splashBorderRadius: null,
      splashFactory: null,
      tabs: List.generate(controller.tabs.length, (index) {
        final item = controller.tabs.elementAt(index);
        return TabView(
          activated: index == controller.currentIndex,
          contentColor: controller.tabContentColor,
          contentColorState: controller.tabContentColorState,
          icon: item.icon,
          iconState: item.iconState,
          iconSize: controller.tabIconSize,
          iconSizeState: controller.tabIconSizeState,
          iconSpace: controller.tabIconSpace,
          iconTint: controller.tabIconTint,
          iconTintState: controller.tabIconTintState,
          inline: controller.tabInlineLabel,
          title: item.title,
          titleState: item.titleState,
          titleSize: controller.tabTitleSize,
          titleSizeState: controller.tabTitleSizeState,
          titleWeight: controller.tabTitleWeight,
          titleWeightState: controller.tabTitleWeightState,
          onVisibleIconWhenTabSelected: controller.onTabIconVisibleWhenSelected,
          onVisibleTitleWhenTabSelected:
              controller.onTabTitleVisibleWhenSelected,
        );
      }),
    );
  }
}
