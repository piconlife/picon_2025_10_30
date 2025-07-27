import 'dart:math';

import 'package:flutter/material.dart';

import '../view/view.dart';

typedef OptionViewItemBuilder<T> = Widget Function(T item, bool selected);

class OptionViewBuilderController<T> extends ViewController {
  int currentIndex = 0;

  List<T> items = [];
  int? _itemCount;
  double spaceBetween = 0;

  OptionViewBuilderController<T> fromOptionView(OptionViewBuilder<T> view) {
    super.fromView(view);
    currentIndex = view.currentIndex;
    _itemCount = view.itemCount;
    spaceBetween = view.spaceBetween;
    items = view.items;
    onItemClick = view.onItemClick;
    return this;
  }

  bool get isSpacer => spaceBetween > 0;

  bool get isExpandable => !scrollable && expandable && !isVerticalMode;

  int get itemCount => min(_itemCount ?? (items.length + 1), items.length);

  bool get isVerticalMode => orientation == Axis.vertical;

  T get firstItem => items.first;

  T get lastItem => items.last;

  int get size => items.length;

  void setItem(T item) {
    super.onNotifyWithCallback(() {
      var list = List<T>.from(items);
      list.add(item);
      items = list;
    });
  }

  void setItems(List<T> items, [bool insertable = true]) {
    super.onNotifyWithCallback(() {
      if (insertable) {
        var list = List<T>.from(this.items);
        list.addAll(items);
        this.items = list;
      } else {
        this.items = items;
      }
    });
  }

  void setItemAt(T item, [int index = 0]) {
    super.onNotifyWithCallback(() {
      var list = List<T>.from(items);
      list.insert(index, item);
      items = list;
    });
  }

  void setItemAsFirst(T item) => setItemAt(item, 0);

  void setItemAsMiddle(T item) => setItemAt(item, itemCount ~/ 2);

  void setItemAsLast(T item) => setItemAt(item, itemCount);

  void removeItem(T item) {
    super.onNotifyWithCallback(() {
      var list = List<T>.from(items);
      list.remove(item);
      items = list;
    });
  }

  void removeItemAt(int index) {
    super.onNotifyWithCallback(() {
      var list = List<T>.from(items);
      list.removeAt(index);
      items = list;
    });
  }

  void setSpaceBetween(double value) {
    super.onNotifyWithCallback(() => spaceBetween = value);
  }

  OnViewItemClickListener<T>? _onItemClick;

  OnViewItemClickListener<T>? get onItemClick => enabled ? _onItemClick : null;

  set onItemClick(OnViewItemClickListener<T>? listener) =>
      _onItemClick ??= listener;

  void setOnItemClickListener(OnViewItemClickListener<T> listener) {
    _onItemClick = listener;
  }

  @override
  void onNotifyWithCallback(VoidCallback callback, {int index = 0}) {
    currentIndex = index;
    super.onNotifyWithCallback(() => callback());
  }
}

class OptionViewBuilder<T> extends YMRView<OptionViewBuilderController<T>> {
  final int currentIndex;
  final int? itemCount;
  final double spaceBetween;

  final List<T> items;
  final OptionViewItemBuilder<T> builder;
  final OnViewItemClickListener<T>? onItemClick;

  const OptionViewBuilder({
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
    required this.items,
    required this.builder,
    this.currentIndex = 0,
    this.itemCount,
    this.spaceBetween = 0,
    this.onItemClick,
  });

  @override
  ViewRoots initRootProperties() {
    return const ViewRoots(clickable: false);
  }

  @override
  OptionViewBuilderController<T> initController() =>
      OptionViewBuilderController();

  @override
  OptionViewBuilderController<T> attachController(
      OptionViewBuilderController<T> controller) {
    return controller.fromOptionView(this);
  }

  @override
  Widget? attach(
    BuildContext context,
    OptionViewBuilderController<T> controller,
  ) {
    return controller.itemCount > 0
        ? Flex(
            direction: controller.orientation,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: List.generate(controller.itemCount, (index) {
              var item = controller.items[index];
              var child = builder(item, index == controller.currentIndex);
              if (controller.isSpacer && controller.itemCount - 1 != index) {
                child = Flex(
                  direction: controller.orientation,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (controller.isExpandable)
                      Flexible(fit: FlexFit.tight, child: child)
                    else
                      child,
                    SizedBox(
                      width: controller.isVerticalMode
                          ? null
                          : controller.spaceBetween,
                      height: controller.isVerticalMode
                          ? controller.spaceBetween
                          : null,
                    ),
                  ],
                );
              }
              var root = GestureDetector(
                onTap: () => controller.onNotifyWithCallback(
                  () {
                    if (controller.onItemClick != null) {
                      controller.onItemClick?.call(context, item);
                    }
                  },
                  index: index,
                ),
                child: AbsorbPointer(child: child),
              );
              return controller.isExpandable ? Expanded(child: root) : root;
            }),
          )
        : null;
  }
}
