import 'package:flutter/material.dart';

import '../view/view.dart';

part 'controller.dart';
part 'painter.dart';
part 'raw.dart';

class TextView<T extends TextViewController> extends YMRView<T> {
  final int maxCharacters;
  final int? maxLines;

  final double? letterSpacing;
  final double lineSpacingExtra;
  final Color? selectionColor;
  final String? semanticsLabel;
  final bool? softWrap;
  final StrutStyle? strutStyle;
  final double? wordSpacing;

  final String? ellipsis;

  final Locale? locale;
  final String? text;
  final ValueState<String>? textState;
  final TextAlign? textAlign;
  final bool textAllCaps;
  final Color? textColor;
  final ValueState<Color>? textColorState;
  final TextDecoration? textDecoration;
  final Color? textDecorationColor;
  final TextDecorationStyle? textDecorationStyle;
  final double? textDecorationThickness;
  final TextDirection? textDirection;
  final String? textFontFamily;
  final FontStyle? textFontStyle;
  final FontWeight? textFontWeight;
  final ValueState<FontWeight>? textFontWeightState;
  final TextHeightBehavior? textHeightBehavior;
  final TextLeadingDistribution? textLeadingDistribution;
  final TextOverflow? textOverflow;
  final double? textSize;
  final ValueState<double>? textSizeState;
  final List<TextSpan> textSpans;
  final TextStyle? textStyle;
  final ValueState<TextStyle>? textStyleState;
  final TextWidthBasis textWidthBasis;
  final OnViewClickListener? onTextClick;

  ///PREFIX
  final FontStyle? prefixFontStyle;
  final FontWeight? prefixFontWeight;
  final ValueState<FontWeight>? prefixFontWeightState;
  final String? prefixText;
  final ValueState<String>? prefixTextState;
  final bool prefixTextAllCaps;
  final Color? prefixTextColor;
  final ValueState<Color>? prefixTextColorState;
  final TextDecoration? prefixTextDecoration;
  final Color? prefixTextDecorationColor;
  final TextDecorationStyle? prefixTextDecorationStyle;
  final double? prefixTextDecorationThickness;
  final double? prefixTextLetterSpace;
  final double? prefixTextSize;
  final ValueState<double>? prefixTextSizeState;
  final TextStyle? prefixTextStyle;
  final ValueState<TextStyle>? prefixTextStyleState;
  final bool prefixTextVisible;
  final OnViewClickListener? onPrefixClick;

  ///SUFFIX
  final FontStyle? suffixFontStyle;
  final FontWeight? suffixFontWeight;
  final ValueState<FontWeight>? suffixFontWeightState;
  final String? suffixText;
  final ValueState<String>? suffixTextState;
  final bool suffixTextAllCaps;
  final Color? suffixTextColor;
  final ValueState<Color>? suffixTextColorState;
  final TextDecoration? suffixTextDecoration;
  final Color? suffixTextDecorationColor;
  final TextDecorationStyle? suffixTextDecorationStyle;
  final double? suffixTextDecorationThickness;
  final double? suffixTextLetterSpace;
  final double? suffixTextSize;
  final ValueState<double>? suffixTextSizeState;
  final TextStyle? suffixTextStyle;
  final ValueState<TextStyle>? suffixTextStyleState;
  final bool suffixTextVisible;
  final OnViewClickListener? onSuffixClick;

  const TextView({
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
    this.ellipsis,
    this.letterSpacing,
    this.lineSpacingExtra = 0,
    this.locale,
    this.maxCharacters = 0,
    this.maxLines,
    this.selectionColor,
    this.semanticsLabel,
    this.softWrap,
    this.strutStyle,
    this.wordSpacing,
    required this.text,
    this.textState,
    this.textAlign,
    this.textAllCaps = false,
    this.textColor,
    this.textColorState,
    this.textDecoration,
    this.textDecorationColor,
    this.textDecorationStyle,
    this.textDecorationThickness,
    this.textDirection,
    this.textFontFamily,
    this.textFontStyle,
    this.textFontWeight,
    this.textFontWeightState,
    this.textHeightBehavior,
    this.textLeadingDistribution,
    this.textOverflow,
    this.textSize,
    this.textSizeState,
    this.textSpans = const [],
    this.textStyle,
    this.textStyleState,
    this.textWidthBasis = TextWidthBasis.parent,
    this.onTextClick,

    /// PREFIX
    this.prefixFontStyle,
    this.prefixFontWeight,
    this.prefixFontWeightState,
    this.prefixText,
    this.prefixTextState,
    this.prefixTextAllCaps = false,
    this.prefixTextColor,
    this.prefixTextColorState,
    this.prefixTextDecoration,
    this.prefixTextDecorationColor,
    this.prefixTextDecorationStyle,
    this.prefixTextDecorationThickness,
    this.prefixTextLetterSpace,
    this.prefixTextSize,
    this.prefixTextSizeState,
    this.prefixTextStyle,
    this.prefixTextStyleState,
    this.prefixTextVisible = true,
    this.onPrefixClick,

    /// SUFFIX
    this.suffixText,
    this.suffixTextState,
    this.suffixTextAllCaps = false,
    this.suffixTextColor,
    this.suffixTextColorState,
    this.suffixTextDecoration,
    this.suffixTextDecorationColor,
    this.suffixTextDecorationStyle,
    this.suffixTextDecorationThickness,
    this.suffixTextLetterSpace,
    this.suffixTextSize,
    this.suffixTextSizeState,
    this.suffixFontStyle,
    this.suffixFontWeight,
    this.suffixFontWeightState,
    this.suffixTextVisible = true,
    this.suffixTextStyle,
    this.suffixTextStyleState,
    this.onSuffixClick,
  });

  @override
  T initController() {
    return TextViewController() as T;
  }

  @override
  T attachController(T controller) {
    return controller.fromTextView(this) as T;
  }

  @override
  Widget? attach(BuildContext context, T controller) {
    return RawTextView(
      ellipsis: controller.ellipsis,
      letterSpacing: controller.letterSpacing,
      lineHeight: controller.spacingFactor,
      locale: controller.locale,
      maxLines: controller.maxLines,
      selectionColor: controller.selectionColor,
      semanticsLabel: controller.semanticsLabel,
      softWrap: controller.softWrap,
      strutStyle: controller.strutStyle,
      text: controller.text,
      textAlign: controller.textAlign,
      textColor: controller.textColor,
      textDecoration: controller.textDecoration,
      textDecorationColor: controller.textDecorationColor,
      textDecorationStyle: controller.textDecorationStyle,
      textDecorationThickness: controller.textDecorationThickness,
      textDirection: controller.textDirection,
      textFontFamily: controller.textFontFamily,
      textFontStyle: controller.textFontStyle,
      textFontWeight: controller.textFontWeight,
      textHeightBehavior: controller.textHeightBehavior,
      textLeadingDistribution: controller.textLeadingDistribution,
      textOverflow: controller.textOverflow,
      textSize: controller.textSize,
      textSpans: controller.textSpans,
      textStyle: controller.textStyle,
      textWidthBasis: controller.textWidthBasis,
      wordSpacing: controller.wordSpacing,
      onClick: controller.onTextClick,

      /// PREFIX
      prefixFontStyle: controller.prefixFontStyle,
      prefixFontWeight: controller.prefixFontWeight,
      prefixText: controller.prefixText,
      prefixTextColor: controller.prefixTextColor,
      prefixTextDecoration: controller.prefixTextDecoration,
      prefixTextDecorationColor: controller.prefixTextDecorationColor,
      prefixTextDecorationStyle: controller.prefixTextDecorationStyle,
      prefixTextDecorationThickness: controller.prefixTextDecorationThickness,
      prefixTextLetterSpace: controller.prefixTextLetterSpace,
      prefixTextSize: controller.prefixTextSize,
      prefixTextStyle: controller.prefixTextStyle,
      prefixTextVisible: controller.prefixTextVisible,
      onPrefixClick: controller.onPrefixClick,

      /// SUFFIX
      suffixFontStyle: controller.suffixFontStyle,
      suffixFontWeight: controller.suffixFontWeight,
      suffixText: controller.suffixText,
      suffixTextColor: controller.suffixTextColor,
      suffixTextDecoration: controller.suffixTextDecoration,
      suffixTextDecorationColor: controller.suffixTextDecorationColor,
      suffixTextDecorationStyle: controller.suffixTextDecorationStyle,
      suffixTextDecorationThickness: controller.suffixTextDecorationThickness,
      suffixTextLetterSpace: controller.suffixTextLetterSpace,
      suffixTextSize: controller.suffixTextSize,
      suffixTextStyle: controller.suffixTextStyle,
      suffixTextVisible: controller.suffixTextVisible,
      onSuffixClick: controller.onSuffixClick,
    );
  }
}
