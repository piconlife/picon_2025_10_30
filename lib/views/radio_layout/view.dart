import 'package:flutter/material.dart';

import '../linear_layout/view.dart';
import '../text/view.dart';
import '../view/view.dart';

class RadioLayout extends YMRView<RadioLayoutController> {
  final int initialIndex;
  final String? title;
  final Color? titleColor;
  final FontWeight? titleFontWeight;
  final double? titleSize;
  final TextStyle? titleStyle;
  final EdgeInsets? titleMargin;
  final EdgeInsets? titlePadding;
  final Color? itemRippleColor;
  final Color? itemPressedColor;
  final Color? itemBackground;
  final ValueState<Color>? itemBackgroundState;
  final ViewCornerRadius? itemCornerRadius;
  final EdgeInsets? itemMargin;
  final EdgeInsets? itemPadding;
  final Color? itemRadioSelectedColor;
  final Color? itemRadioUnselectedColor;
  final double? itemSpaceBetween;
  final Color? itemTextColor;
  final ValueState<Color>? itemTextColorState;
  final double? itemTextSize;
  final ValueState<double>? itemTextSizeState;
  final TextStyle? itemTextStyle;
  final ValueState<TextStyle>? itemTextStyleState;
  final List<RadioButton> children;
  final OnViewItemChangeListener<int>? onItemChange;

  const RadioLayout({
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
    required this.children,
    this.initialIndex = 0,
    this.title,
    this.titleColor,
    this.titleFontWeight,
    this.titleSize,
    this.titleStyle,
    this.titleMargin,
    this.titlePadding,
    this.itemRippleColor,
    this.itemPressedColor,
    this.itemBackground,
    this.itemBackgroundState,
    this.itemCornerRadius,
    this.itemMargin,
    this.itemPadding,
    this.itemRadioSelectedColor,
    this.itemRadioUnselectedColor,
    this.itemSpaceBetween,
    this.itemTextColor,
    this.itemTextColorState,
    this.itemTextSize,
    this.itemTextSizeState,
    this.itemTextStyle,
    this.itemTextStyleState,
    this.onItemChange,
  });

  @override
  RadioLayoutController initController() => RadioLayoutController();

  @override
  RadioLayoutController attachController(RadioLayoutController controller) {
    return controller.fromRadioGroupView(this);
  }

  @override
  Widget? attach(BuildContext context, RadioLayoutController controller) {
    var titleDefaultMargin = controller.isTitledMargin ? 12.0 : 0.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextView(
          visibility: (controller.title ?? "").isNotEmpty,
          text: controller.title,
          textColor: controller.titleColor,
          textFontWeight: controller.titleFontWeight ?? FontWeight.w600,
          textSize: controller.titleSize ?? 16,
          textStyle: controller.titleStyle,
          marginTop: controller.titleMargin?.top,
          marginBottom: controller.titleMargin?.bottom,
          marginStart: controller.titleMargin?.left ?? titleDefaultMargin,
          marginEnd: controller.titleMargin?.right,
          paddingTop: controller.titlePadding?.top,
          paddingBottom: controller.titlePadding?.bottom,
          paddingStart: controller.titlePadding?.left,
          paddingEnd: controller.titlePadding?.right,
        ),
        ...List.generate(controller.children.length, (index) {
          var item = controller.children[index];
          return RadioButton(
            background: item.background ?? controller.itemBackground,
            backgroundState:
                item.backgroundState ?? controller.itemBackgroundState,
            cornerRadius: item.cornerRadius ?? controller.itemCornerRadius,
            index: index,
            key: item.key,
            margin: item.margin ?? controller.itemMargin,
            padding: item.padding ?? controller.itemPadding,
            pressedColor: item.pressedColor ?? controller.itemPressedColor,
            rippleColor: item.rippleColor ?? controller.itemRippleColor,
            radioSelectedColor:
                item.radioSelectedColor ?? controller.itemRadioSelectedColor,
            radioUnselectedColor: item.radioUnselectedColor ??
                controller.itemRadioUnselectedColor,
            selection: controller.currentIndex,
            spaceBetween: itemSpaceBetween,
            text: item.text,
            textState: item.textState,
            textColor: item.textColor ?? controller.itemTextColor,
            textColorState:
                item.textColorState ?? controller.itemTextColorState,
            textSize: item.textSize ?? controller.itemTextSize,
            textSizeState: item.textSizeState ?? controller.itemTextSizeState,
            textStyle: item.textStyle ?? controller.itemTextStyle,
            textStyleState:
                item.textStyleState ?? controller.itemTextStyleState,
            onClick: (context, index) {
              controller.setCurrentIndex(index);
              if (onItemChange != null) onItemChange?.call(context, index ?? 0);
            },
          );
        }),
      ],
    );
  }
}

class RadioLayoutController extends ViewController {
  RadioLayoutController fromRadioGroupView(RadioLayout view) {
    super.fromView(view);

    /// BASE PROPERTIES
    currentIndex = view.initialIndex;
    children = view.children;

    /// TITLE PROPERTIES
    title = view.title;
    titleColor = view.titleColor;
    titleFontWeight = view.titleFontWeight;
    titleSize = view.titleSize;
    titleStyle = view.titleStyle;
    titleMargin = view.titleMargin;
    titlePadding = view.titlePadding;

    /// ITEM PROPERTIES
    itemRippleColor = view.itemRippleColor;
    itemPressedColor = view.itemPressedColor;
    itemBackground = view.itemBackground;
    itemBackgroundState = view.itemBackgroundState;
    itemCornerRadius = view.itemCornerRadius;
    itemMargin = view.itemMargin;
    itemPadding = view.itemPadding;
    itemRadioSelectedColor = view.itemRadioSelectedColor;
    itemRadioUnselectedColor = view.itemRadioUnselectedColor;
    itemTextColor = view.itemTextColor;
    itemTextColorState = view.itemTextColorState;
    itemTextSize = view.itemTextSize;
    itemTextSizeState = view.itemTextSizeState;
    itemTextStyle = view.itemTextStyle;
    itemTextStyleState = view.itemTextStyleState;
    return this;
  }

  /// CUSTOMIZATIONS
  bool get isTitledMargin {
    return itemRippleColor == null && itemPressedColor == null;
  }

  /// BASE PROPERTIES
  int currentIndex = 0;
  List<RadioButton> children = const [];

  void setCurrentIndex(int? index) {
    onNotifyWithCallback(() => currentIndex = index ?? 0);
  }

  /// TITLE PROPERTIES
  String? title;
  Color? titleColor;
  FontWeight? titleFontWeight;
  double? titleSize;
  TextStyle? titleStyle;
  EdgeInsets? titleMargin;
  EdgeInsets? titlePadding;

  /// ITEM PROPERTIES
  Color? itemRippleColor;
  Color? itemPressedColor;
  Color? itemBackground;
  ValueState<Color>? itemBackgroundState;
  ViewCornerRadius? itemCornerRadius;
  EdgeInsets? itemMargin;
  EdgeInsets? itemPadding;
  Color? itemRadioSelectedColor;
  Color? itemRadioUnselectedColor;
  Color? itemTextColor;
  ValueState<Color>? itemTextColorState;
  double? itemTextSize;
  ValueState<double>? itemTextSizeState;
  TextStyle? itemTextStyle;
  ValueState<TextStyle>? itemTextStyleState;
}

class RadioButton extends StatelessWidget {
  final int index;
  final int selection;
  final Color? rippleColor;
  final Color? pressedColor;
  final Color? background;
  final ValueState<Color>? backgroundState;
  final ViewCornerRadius? cornerRadius;
  final EdgeInsets? margin;
  final EdgeInsets? padding;
  final Color? radioSelectedColor;
  final Color? radioUnselectedColor;
  final String text;
  final ValueState<String>? textState;
  final Color? textColor;
  final ValueState<Color>? textColorState;
  final double? textSize;
  final ValueState<double>? textSizeState;
  final TextStyle? textStyle;
  final ValueState<TextStyle>? textStyleState;
  final double? spaceBetween;
  final OnViewItemChangeListener<int?>? onClick;

  const RadioButton({
    super.key,
    this.index = 0,
    this.selection = 0,
    this.radioSelectedColor,
    this.radioUnselectedColor,
    required this.text,
    this.textColor,
    this.textColorState,
    this.onClick,
    this.rippleColor,
    this.pressedColor,
    this.background,
    this.backgroundState,
    this.cornerRadius,
    this.margin,
    this.padding,
    this.spaceBetween,
    this.textState,
    this.textSize,
    this.textSizeState,
    this.textStyle,
    this.textStyleState,
  });

  @override
  Widget build(BuildContext context) {
    var selected = index == selection;
    var ripple = rippleColor;
    return LinearLayout(
      activated: selected,
      background: background,
      backgroundState: backgroundState,
      borderRadiusTL: cornerRadius?.topLeft,
      borderRadiusTR: cornerRadius?.topRight,
      borderRadiusBL: cornerRadius?.bottomLeft,
      borderRadiusBR: cornerRadius?.bottomRight,
      marginTop: margin?.top,
      marginBottom: margin?.bottom,
      marginStart: margin?.left,
      marginEnd: margin?.right,
      paddingTop: padding?.top,
      paddingBottom: padding?.bottom,
      paddingStart: padding?.left,
      paddingEnd: padding?.right,
      orientation: Axis.horizontal,
      crossGravity: CrossAxisAlignment.center,
      absorbMode: true,
      rippleColor: ripple ?? Colors.transparent,
      pressedColor: pressedColor ?? Colors.transparent,
      onClick: onClick != null ? (context) => onClick!(context, index) : null,
      children: [
        Radio(
          value: index,
          groupValue: selection,
          onChanged: (index) => onClick?.call(context, index),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          fillColor: MaterialStateProperty.resolveWith((Set states) {
            if (states.contains(MaterialState.selected)) {
              return radioSelectedColor;
            } else {
              return radioUnselectedColor ?? Theme.of(context).primaryColor;
            }
          }),
        ),
        TextView(
          activated: selected,
          marginStart: spaceBetween,
          text: text,
          textState: textState,
          textColor: textColor,
          textColorState: textColorState,
          textSize: textSize,
          textSizeState: textSizeState,
          textStyle: textStyle,
          textStyleState: textStyleState,
        ),
      ],
    );
  }
}
