import 'package:flutter/material.dart';

import '../button/view.dart';
import '../icon/view.dart';
import '../text/view.dart';
import '../view/view.dart';

typedef NullableViewBuilder =
    Widget Function(BuildContext context, Widget parent);

class NullableView extends YMRView<NullableViewController> {
  ///IMAGE
  final dynamic icon;
  final NullableViewBuilder? iconBuilder;
  final Color? iconTint;
  final BlendMode iconTintMode;
  final double iconSize;
  final double iconSpacing;
  final bool iconVisible;
  final IconViewController? iconController;

  ///HEADER
  final String? header;
  final NullableViewBuilder? headerBuilder;
  final Color headerColor;
  final String? headerFontFamily;
  final FontWeight headerFontWeight;
  final double headerSize;
  final bool headerVisible;
  final TextViewController? headerController;

  ///BODY
  final String? body;
  final NullableViewBuilder? bodyBuilder;
  final Color bodyColor;
  final String? bodyFontFamily;
  final FontWeight bodyFontWeight;
  final double bodySize;
  final double bodySpacing;
  final bool bodyVisible;
  final TextViewController? bodyController;

  /// BUTTON
  final Color? buttonBackground;
  final NullableViewBuilder? buttonBuilder;
  final double buttonMinWidth;
  final double buttonPaddingX;
  final double buttonPaddingY;
  final String? buttonText;
  final Color? buttonTextColor;
  final String? buttonTextFontFamily;
  final FontWeight buttonTextFontWeight;
  final double buttonTextSize;
  final double buttonBorderRadius;
  final Color? buttonRippleColor;
  final double buttonSpacing;
  final bool buttonVisible;
  final ButtonController? buttonController;
  final OnViewClickListener? onButtonClick;

  /// SECONDARY BUTTON
  final Color? secondaryButtonBackground;
  final NullableViewBuilder? secondaryButtonBuilder;
  final double? secondaryButtonMinWidth;
  final double? secondaryButtonPaddingX;
  final double? secondaryButtonPaddingY;
  final String secondaryButtonText;
  final Color? secondaryButtonTextColor;
  final String? secondaryButtonTextFontFamily;
  final FontWeight? secondaryButtonTextFontWeight;
  final double? secondaryButtonTextSize;
  final double? secondaryButtonBorderRadius;
  final Color? secondaryButtonRippleColor;
  final double secondaryButtonSpacing;
  final bool secondaryButtonVisible;
  final ButtonController? secondaryButtonController;
  final OnViewClickListener? onSecondaryButtonClick;

  const NullableView({
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

    /// ICON PROPERTIES
    this.icon,
    this.iconBuilder,
    this.iconTint,
    this.iconTintMode = BlendMode.srcIn,
    this.iconSize = 50,
    this.iconSpacing = 24,
    this.iconVisible = true,
    this.iconController,

    /// HEADER PROPERTIES
    this.header,
    this.headerBuilder,
    this.headerColor = Colors.black,
    this.headerFontFamily,
    this.headerFontWeight = FontWeight.w500,
    this.headerSize = 24,
    this.headerVisible = true,
    this.headerController,

    /// BODY PROPERTIES
    this.body,
    this.bodyBuilder,
    this.bodyColor = const Color(0xff808080),
    this.bodyFontFamily,
    this.bodyFontWeight = FontWeight.normal,
    this.bodySize = 16,
    this.bodySpacing = 12,
    this.bodyVisible = true,
    this.bodyController,

    /// BUTTON PROPERTIES
    this.buttonBackground,
    this.buttonBorderRadius = 50,
    this.buttonBuilder,
    this.buttonMinWidth = 180,
    this.buttonPaddingX = 24,
    this.buttonPaddingY = 12,
    this.buttonRippleColor,
    this.buttonText,
    this.buttonTextColor,
    this.buttonTextFontFamily,
    this.buttonTextFontWeight = FontWeight.w500,
    this.buttonTextSize = 16,
    this.buttonSpacing = 24,
    this.buttonVisible = true,
    this.buttonController,
    this.onButtonClick,

    /// SECONDARY BUTTON PROPERTIES
    this.secondaryButtonBackground,
    this.secondaryButtonBorderRadius,
    this.secondaryButtonBuilder,
    this.secondaryButtonMinWidth,
    this.secondaryButtonPaddingX,
    this.secondaryButtonPaddingY,
    this.secondaryButtonRippleColor,
    this.secondaryButtonText = "",
    this.secondaryButtonTextColor,
    this.secondaryButtonTextFontFamily,
    this.secondaryButtonTextFontWeight,
    this.secondaryButtonTextSize,
    this.secondaryButtonSpacing = 24,
    this.secondaryButtonVisible = true,
    this.secondaryButtonController,
    this.onSecondaryButtonClick,
  });

  @override
  NullableViewController initController() => NullableViewController();

  @override
  NullableViewController attachController(NullableViewController controller) {
    return controller.fromErrorView(this);
  }

  @override
  Widget? attach(BuildContext context, NullableViewController controller) {
    final primaryColor = Theme.of(context).primaryColor;

    var mIcon = IconView(
      controller: iconController,
      visibility: controller.iconVisible,
      marginBottom: controller.iconSpacing,
      icon: controller.icon,
      size: controller.iconSize,
      tint: controller.iconTint,
      tintMode: controller.iconTintMode,
    );
    var mHeader = TextView(
      controller: headerController,
      visibility: controller.headerVisible,
      width: double.infinity,
      gravity: Alignment.center,
      text: controller.header,
      textColor: controller.headerColor,
      textAlign: TextAlign.center,
      textFontFamily: controller.headerFontFamily,
      textFontWeight: controller.headerFontWeight,
      textSize: controller.headerSize,
    );
    var mBody = TextView(
      controller: bodyController,
      visibility: controller.bodyVisible,
      width: double.infinity,
      gravity: Alignment.center,
      marginTop: controller.bodySpacing,
      text: controller.body,
      textAlign: TextAlign.center,
      textColor: controller.bodyColor,
      textFontFamily: controller.bodyFontFamily,
      textFontWeight: controller.bodyFontWeight,
      textSize: controller.bodySize,
    );
    var mButton = Button(
      controller: buttonController,
      visibility: controller.buttonVisible,
      marginTop: controller.buttonSpacing,
      background: controller.buttonBackground ?? primaryColor,
      widthMin: controller.buttonMinWidth,
      paddingHorizontal: controller.buttonPaddingX,
      paddingVertical: controller.buttonPaddingY,
      rippleColor: controller.buttonRippleColor ?? Colors.black26,
      pressedColor: Colors.black12,
      borderRadius: controller.buttonBorderRadius,
      text: controller.buttonText,
      textColor: controller.buttonTextColor ?? Colors.white,
      textFontWeight: controller.buttonTextFontWeight,
      textSize: controller.buttonTextSize,
      onClick: onButtonClick,
    );
    var mSecondaryButton = Button(
      controller: secondaryButtonController,
      visibility: controller.secondaryButtonVisible,
      marginTop: controller.secondaryButtonSpacing,
      background:
          controller.secondaryButtonBackground ??
          (controller.buttonBackground ?? primaryColor).withOpacity(0.1),
      widthMin: controller.secondaryButtonMinWidth,
      paddingHorizontal: controller.secondaryButtonPaddingX,
      paddingVertical: controller.secondaryButtonPaddingY,
      rippleColor:
          controller.secondaryButtonRippleColor ??
          (controller.buttonRippleColor ?? Colors.black26).withOpacity(0.2),
      pressedColor: Colors.black12,
      borderRadius:
          controller.secondaryButtonBorderRadius ??
          controller.buttonBorderRadius,
      text: controller.secondaryButtonText,
      textColor:
          controller.secondaryButtonTextColor ??
          controller.buttonBackground ??
          primaryColor,
      textFontWeight:
          controller.secondaryButtonTextFontWeight ??
          controller.buttonTextFontWeight,
      textSize: controller.secondaryButtonTextSize ?? controller.buttonTextSize,
      onClick: onSecondaryButtonClick,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        iconBuilder?.call(context, mIcon) ?? mIcon,
        headerBuilder?.call(context, mHeader) ?? mHeader,
        bodyBuilder?.call(context, mBody) ?? mBody,
        buttonBuilder?.call(context, mButton) ?? mButton,
        secondaryButtonBuilder?.call(context, mSecondaryButton) ??
            mSecondaryButton,
      ],
    );
  }
}

class NullableViewController extends ViewController {
  /// ICON
  dynamic icon;
  Color? iconTint;
  BlendMode iconTintMode = BlendMode.srcIn;
  double iconSize = 50;
  double iconSpacing = 24;
  bool _iconVisible = true;

  bool get iconVisible => icon != null && _iconVisible;

  /// HEADER
  String? header;
  Color headerColor = Colors.black;
  String? headerFontFamily;
  FontWeight headerFontWeight = FontWeight.w500;
  double headerSize = 24;
  bool _headerVisible = true;

  bool get headerVisible => (header ?? "").isNotEmpty && _headerVisible;

  /// BODY
  String? body;
  Color bodyColor = const Color(0xff808080);
  String? bodyFontFamily;
  FontWeight? bodyFontWeight;
  double bodySize = 16;
  double bodySpacing = 12;
  bool _bodyVisible = true;

  bool get bodyVisible => (body ?? "").isNotEmpty && _bodyVisible;

  /// BUTTON
  Color? buttonBackground;
  double buttonBorderRadius = 50;
  double buttonMinWidth = 180;
  double buttonPaddingX = 24;
  double buttonPaddingY = 12;
  String? buttonText;
  Color? buttonTextColor;
  String? buttonTextFontFamily;
  FontWeight buttonTextFontWeight = FontWeight.w500;
  double buttonTextSize = 16;
  Color? buttonRippleColor;
  double buttonSpacing = 24;
  bool _buttonVisible = false;

  bool get buttonVisible => (buttonText ?? "").isNotEmpty && _buttonVisible;

  /// SECONDARY BUTTON
  Color? secondaryButtonBackground;
  double? secondaryButtonBorderRadius;
  double? secondaryButtonMinWidth;
  double? secondaryButtonPaddingX;
  double? secondaryButtonPaddingY;
  String? secondaryButtonText;
  Color? secondaryButtonTextColor;
  String? secondaryButtonTextFontFamily;
  FontWeight? secondaryButtonTextFontWeight;
  double? secondaryButtonTextSize;
  Color? secondaryButtonRippleColor;
  double secondaryButtonSpacing = 24;
  bool _secondaryButtonVisible = false;

  bool get secondaryButtonVisible {
    return (secondaryButtonText ?? "").isNotEmpty && _secondaryButtonVisible;
  }

  /// SUPER PROPERTIES
  @override
  double get paddingHorizontal => super.paddingHorizontal ?? 24;

  @override
  double get paddingVertical => super.paddingVertical ?? 50;

  @override
  Alignment get gravity => super.gravity ?? Alignment.center;

  NullableViewController fromErrorView(NullableView view) {
    super.fromView(view);

    ///ICON
    icon = view.icon;
    iconTint = view.iconTint;
    iconTintMode = view.iconTintMode;
    iconSize = view.iconSize;
    iconSpacing = view.iconSpacing;
    _iconVisible = view.iconVisible;

    ///HEADER
    header = view.header;
    headerColor = view.headerColor;
    headerFontFamily = view.headerFontFamily;
    headerFontWeight = view.headerFontWeight;
    headerSize = view.headerSize;
    _headerVisible = view.headerVisible;

    ///BODY
    body = view.body;
    bodyColor = view.bodyColor;
    bodyFontFamily = view.bodyFontFamily;
    bodyFontWeight = view.bodyFontWeight;
    bodySize = view.bodySize;
    bodySpacing = view.bodySpacing;
    _bodyVisible = view.bodyVisible;

    ///BUTTON
    buttonBackground = view.buttonBackground;
    buttonBorderRadius = view.buttonBorderRadius;
    buttonMinWidth = view.buttonMinWidth;
    buttonPaddingX = view.buttonPaddingX;
    buttonPaddingY = view.buttonPaddingY;
    buttonRippleColor = view.buttonRippleColor;
    buttonText = view.buttonText;
    buttonTextColor = view.buttonTextColor;
    buttonTextFontFamily = view.buttonTextFontFamily;
    buttonTextFontWeight = view.buttonTextFontWeight;
    buttonTextSize = view.buttonTextSize;
    buttonSpacing = view.buttonSpacing;
    _buttonVisible = view.buttonVisible;

    ///SECONDARY BUTTON
    secondaryButtonBackground = view.secondaryButtonBackground;
    secondaryButtonBorderRadius = view.secondaryButtonBorderRadius;
    secondaryButtonMinWidth = view.secondaryButtonMinWidth;
    secondaryButtonPaddingX = view.secondaryButtonPaddingX;
    secondaryButtonPaddingY = view.secondaryButtonPaddingY;
    secondaryButtonRippleColor = view.secondaryButtonRippleColor;
    secondaryButtonText = view.secondaryButtonText;
    secondaryButtonTextColor = view.secondaryButtonTextColor;
    secondaryButtonTextFontFamily = view.secondaryButtonTextFontFamily;
    secondaryButtonTextFontWeight = view.secondaryButtonTextFontWeight;
    secondaryButtonTextSize = view.secondaryButtonTextSize;
    secondaryButtonSpacing = view.secondaryButtonSpacing;
    _secondaryButtonVisible = view.secondaryButtonVisible;
    return this;
  }
}
