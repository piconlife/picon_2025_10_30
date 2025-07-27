part of 'view.dart';

class ViewDecoration {
  final bool? absorbMode;
  final int? animation;
  final Curve? animationType;
  final Color? background;
  final ValueState<Color>? backgroundState;
  final BlendMode? backgroundBlendMode;
  final Gradient? backgroundGradient;
  final ValueState<Gradient>? backgroundGradientState;
  final DecorationImage? backgroundImage;
  final ValueState<DecorationImage>? backgroundImageState;

  final ViewClickEffect? clickEffect;
  final Clip? clipBehavior;
  final double? dimensionRatio;
  final double? elevation;
  final bool? expandable;
  final int? flex;
  final Color? foreground;
  final BlendMode? foregroundBlendMode;
  final Gradient? foregroundGradient;
  final DecorationImage? foregroundImage;
  final Alignment? gravity;
  final double? height, heightMax, heightMin;
  final ValueState<double>? heightState;
  final Color? hoverColor;
  final Color? pressedColor;
  final Color? rippleColor;

  /// BACKDROP PROPERTIES
  final ImageFilter? backdropFilter;
  final BlendMode? backdropMode;

  /// BORDER PROPERTIES
  final Color? borderColor;
  final ValueState<Color>? borderColorState;
  final double? borderSize;
  final ValueState<double>? borderSizeState;
  final double? borderHorizontal, borderVertical;
  final ValueState<double>? borderHorizontalState, borderVerticalState;
  final double? borderTop, borderBottom, borderStart, borderEnd;
  final ValueState<double>? borderTopState, borderBottomState;
  final ValueState<double>? borderStartState, borderEndState;
  final double? borderStrokeAlign;

  /// BORDER RADIUS PROPERTIES
  final double? borderRadius;
  final ValueState<double>? borderRadiusState;
  final double? borderRadiusBL, borderRadiusBR, borderRadiusTL, borderRadiusTR;
  final ValueState<double>? borderRadiusBLState, borderRadiusBRState;
  final ValueState<double>? borderRadiusTLState, borderRadiusTRState;

  /// MARGIN PROPERTIES
  final double? margin;
  final double? marginHorizontal, marginVertical;
  final double? marginTop, marginBottom, marginStart, marginEnd;
  final EdgeInsets? marginCustom;

  /// OPACITY PROPERTIES
  final double? opacity;
  final ValueState<double>? opacityState;
  final bool opacityAlwaysIncludeSemantics;

  /// PADDING PROPERTIES
  final double? padding;
  final double? paddingHorizontal, paddingVertical;
  final double? paddingTop, paddingBottom, paddingStart, paddingEnd;
  final EdgeInsets? paddingCustom;

  /// SHADOW PROPERTIES
  final double? shadow;
  final double? shadowBlurRadius, shadowSpreadRadius;
  final double? shadowHorizontal, shadowVertical;
  final double? shadowStart, shadowEnd, shadowTop, shadowBottom;
  final Color? shadowColor;
  final BlurStyle? shadowBlurStyle;
  final ViewShadowType? shadowType;

  final ViewShape? shape;
  final double? width, widthMax, widthMin;
  final ValueState<double>? widthState;

  const ViewDecoration({
    this.animation,
    this.animationType,
    this.background,
    this.backgroundState,
    this.backgroundBlendMode,
    this.clickEffect,
    this.backdropFilter,
    this.backdropMode,
    this.borderColor,
    this.borderColorState,
    this.borderSize,
    this.borderSizeState,
    this.borderHorizontal,
    this.borderVertical,
    this.borderHorizontalState,
    this.borderVerticalState,
    this.borderTop,
    this.borderBottom,
    this.borderStart,
    this.borderEnd,
    this.borderTopState,
    this.borderBottomState,
    this.borderStartState,
    this.borderEndState,
    this.borderStrokeAlign,
    this.borderRadius,
    this.borderRadiusState,
    this.borderRadiusBL,
    this.borderRadiusBR,
    this.borderRadiusTL,
    this.borderRadiusTR,
    this.borderRadiusBLState,
    this.borderRadiusBRState,
    this.borderRadiusTLState,
    this.borderRadiusTRState,
    this.margin,
    this.marginHorizontal,
    this.marginVertical,
    this.marginTop,
    this.marginBottom,
    this.marginStart,
    this.marginEnd,
    this.marginCustom,
    this.opacity,
    this.opacityState,
    this.opacityAlwaysIncludeSemantics = false,
    this.padding,
    this.paddingHorizontal,
    this.paddingVertical,
    this.paddingTop,
    this.paddingBottom,
    this.paddingStart,
    this.paddingEnd,
    this.paddingCustom,
    this.pressedColor,
    this.rippleColor,
    this.shadow,
    this.shadowBlurRadius,
    this.shadowBlurStyle,
    this.shadowSpreadRadius,
    this.shadowHorizontal,
    this.shadowVertical,
    this.shadowStart,
    this.shadowEnd,
    this.shadowTop,
    this.shadowBottom,
    this.shadowColor,
    this.shadowType,
    this.shape,
    this.width,
    this.widthMax,
    this.widthMin,
    this.widthState,
    this.absorbMode,
    this.backgroundGradient,
    this.backgroundGradientState,
    this.backgroundImage,
    this.backgroundImageState,
    this.clipBehavior,
    this.dimensionRatio,
    this.elevation,
    this.expandable,
    this.flex,
    this.foreground,
    this.foregroundBlendMode,
    this.foregroundGradient,
    this.foregroundImage,
    this.gravity,
    this.height,
    this.heightMax,
    this.heightMin,
    this.heightState,
    this.hoverColor,
  });

  ViewDecoration copyWith({
    ViewClickEffect? clickEffect,

    /// BACKDROP PROPERTIES
    ImageFilter? backdropFilter,
    BlendMode? backdropMode,

    /// BORDER PROPERTIES
    Color? borderColor,
    ValueState<Color>? borderColorState,
    double? borderSize,
    ValueState<double>? borderSizeState,
    double? borderHorizontal,
    borderVertical,
    ValueState<double>? borderHorizontalState,
    borderVerticalState,
    double? borderTop,
    borderBottom,
    borderStart,
    borderEnd,
    ValueState<double>? borderTopState,
    borderBottomState,
    ValueState<double>? borderStartState,
    borderEndState,
    double? borderStrokeAlign,

    /// BORDER RADIUS PROPERTIES
    double? borderRadius,
    ValueState<double>? borderRadiusState,
    double? borderRadiusBL,
    borderRadiusBR,
    borderRadiusTL,
    borderRadiusTR,
    ValueState<double>? borderRadiusBLState,
    borderRadiusBRState,
    ValueState<double>? borderRadiusTLState,
    borderRadiusTRState,

    /// MARGIN PROPERTIES
    double? margin,
    double? marginHorizontal,
    marginVertical,
    double? marginTop,
    marginBottom,
    marginStart,
    marginEnd,
    EdgeInsets? marginCustom,

    /// OPACITY PROPERTIES
    double? opacity,
    ValueState<double>? opacityState,
    bool? opacityAlwaysIncludeSemantics,

    /// PADDING PROPERTIES
    double? padding,
    double? paddingHorizontal,
    paddingVertical,
    double? paddingTop,
    paddingBottom,
    paddingStart,
    paddingEnd,
    EdgeInsets? paddingCustom,

    /// SHADOW PROPERTIES
    double? shadow,
    double? shadowBlurRadius,
    shadowSpreadRadius,
    double? shadowHorizontal,
    shadowVertical,
    double? shadowStart,
    shadowEnd,
    shadowTop,
    shadowBottom,
  }) {
    return ViewDecoration(
      clickEffect: clickEffect ?? this.clickEffect,
      backdropFilter: backdropFilter ?? this.backdropFilter,
      backdropMode: backdropMode ?? this.backdropMode,
      borderColor: borderColor ?? this.borderColor,
      borderColorState: borderColorState ?? this.borderColorState,
      borderSize: borderSize ?? this.borderSize,
      borderSizeState: borderSizeState ?? this.borderSizeState,
      borderHorizontal: borderHorizontal ?? this.borderHorizontal,
      borderVertical: borderVertical ?? this.borderVertical,
      borderHorizontalState:
          borderHorizontalState ?? this.borderHorizontalState,
      borderVerticalState: borderVerticalState ?? this.borderVerticalState,
      borderTop: borderTop ?? this.borderTop,
      borderBottom: borderBottom ?? this.borderBottom,
      borderStart: borderStart ?? this.borderStart,
      borderEnd: borderEnd ?? this.borderEnd,
      borderTopState: borderTopState ?? this.borderTopState,
      borderBottomState: borderBottomState ?? this.borderBottomState,
      borderStartState: borderStartState ?? this.borderStartState,
      borderEndState: borderEndState ?? this.borderEndState,
      borderStrokeAlign: borderStrokeAlign ?? this.borderStrokeAlign,
      borderRadius: borderRadius ?? this.borderRadius,
      borderRadiusState: borderRadiusState ?? this.borderRadiusState,
      borderRadiusBL: borderRadiusBL ?? this.borderRadiusBL,
      borderRadiusBR: borderRadiusBR ?? this.borderRadiusBR,
      borderRadiusTL: borderRadiusTL ?? this.borderRadiusTL,
      borderRadiusTR: borderRadiusTR ?? this.borderRadiusTR,
      borderRadiusBLState: borderRadiusBLState ?? this.borderRadiusBLState,
      borderRadiusBRState: borderRadiusBRState ?? this.borderRadiusBRState,
      borderRadiusTLState: borderRadiusTLState ?? this.borderRadiusTLState,
      borderRadiusTRState: borderRadiusTRState ?? this.borderRadiusTRState,
      margin: margin ?? this.margin,
      marginHorizontal: marginHorizontal ?? this.marginHorizontal,
      marginVertical: marginVertical ?? this.marginVertical,
      marginTop: marginTop ?? this.marginTop,
      marginBottom: marginBottom ?? this.marginBottom,
      marginStart: marginStart ?? this.marginStart,
      marginEnd: marginEnd ?? this.marginEnd,
      marginCustom: marginCustom ?? this.marginCustom,
      opacity: opacity ?? this.opacity,
      opacityState: opacityState ?? this.opacityState,
      opacityAlwaysIncludeSemantics:
          opacityAlwaysIncludeSemantics ?? this.opacityAlwaysIncludeSemantics,
      padding: padding ?? this.padding,
      paddingHorizontal: paddingHorizontal ?? this.paddingHorizontal,
      paddingVertical: paddingVertical ?? this.paddingVertical,
      paddingTop: paddingTop ?? this.paddingTop,
      paddingBottom: paddingBottom ?? this.paddingBottom,
      paddingStart: paddingStart ?? this.paddingStart,
      paddingEnd: paddingEnd ?? this.paddingEnd,
      paddingCustom: paddingCustom ?? this.paddingCustom,
      shadow: shadow ?? this.shadow,
      shadowBlurRadius: shadowBlurRadius ?? this.shadowBlurRadius,
      shadowSpreadRadius: shadowSpreadRadius ?? this.shadowSpreadRadius,
      shadowHorizontal: shadowHorizontal ?? this.shadowHorizontal,
      shadowVertical: shadowVertical ?? this.shadowVertical,
      shadowStart: shadowStart ?? this.shadowStart,
      shadowEnd: shadowEnd ?? this.shadowEnd,
      shadowTop: shadowTop ?? this.shadowTop,
      shadowBottom: shadowBottom ?? this.shadowBottom,
    );
  }
}
